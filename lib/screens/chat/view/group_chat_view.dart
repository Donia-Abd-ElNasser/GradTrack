// group_chat_view.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gradtrack/screens/auth/model/group_model.dart';
import 'package:gradtrack/screens/chat/messages_cubit/messages_cubit.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupChatView extends StatefulWidget {
  final GroupModel groupModel;

  const GroupChatView({Key? key, required this.groupModel}) : super(key: key);

  @override
  State<GroupChatView> createState() => _GroupChatViewState();
}

class _GroupChatViewState extends State<GroupChatView> {
  final TextEditingController msgController = TextEditingController();
  String? userId;
  String? userName;
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserFromPrefs();
  }

  Future<void> fetchCurrentUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString("userId");
    final savedName = prefs.getString("userName");

   
    if (savedUserId != null) {
      setState(() {
        userId = savedUserId;
        userName = savedName ?? "Unknown";
      });
      return;
    }

    

    
  }

  Future<void> pickImageAndSend() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;

    final file = File(picked.path);
    await _uploadAndSendFile(file, "image");
  }

  Future<void> pickPdfAndSend() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null || result.files.isEmpty) return;

    final path = result.files.first.path;
    if (path == null) return;
    final file = File(path);
    await _uploadAndSendFile(file, "pdf");
  }

 Future<void> _uploadAndSendFile(File file, String type) async {
    if (userId == null || userName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not loaded yet")));
      return;
    }

    setState(() => uploading = true);
    try {
      final cubit = context.read<MessagesCubit>();

      if (type == "image") {
        await cubit.sendImageMessage( // <-- Use sendImageMessage for images
          groupId: widget.groupModel.id,
          senderId: userId!,
          senderName: userName!,
          file: file,
        );
      } else if (type == "pdf") {
        await cubit.sendPDFMessage( // <-- Use sendPDFMessage for PDFs
          groupId: widget.groupModel.id,
          senderId: userId!,
          senderName: userName!,
          file: file,
        );
      } else {
         ScaffoldMessenger.of(context)
             .showSnackBar(const SnackBar(content: Text("Unsupported file type")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    } finally {
      if (mounted) setState(() => uploading = false);
    }
  }
  Future<void> _sendText() async {
    final text = msgController.text.trim();
    if (text.isEmpty) return;
    if (userId == null || userName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not loaded yet")));
      return;
    }

    try {
      await context.read<MessagesCubit>().sendMessage(
            groupId: widget.groupModel.id,
            senderId: userId!,
            senderName: userName!,
            text: text,
          );
      msgController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Send failed: $e")));
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cannot open file")));
    }
  }

  @override
  Widget build(BuildContext context) {
  //  final chatCubit = MessagesCubit(); 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.groupModel.name, style: const TextStyle(color: Colors.black87)),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: BlocProvider.of<MessagesCubit>(context).getMessages(widget.groupModel.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
    
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
    
                final docs = snapshot.data?.docs ?? [];
    
                if (docs.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }
    
                final messages = docs.map((d) {
                  final m = d.data() as Map<String, dynamic>;
                  m["docId"] = d.id;
                  return m;
                }).toList();
    
                return ListView.builder(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    final isMe = msg["senderId"] == userId;
                    final type = (msg["type"] ?? "text").toString();
    
                    Widget bubbleChild;
                    if (type == "text") {
                      bubbleChild = Text(
                        msg["text"] ?? "",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      );
                    } else if (type == "image") {
                      final url = msg["fileUrl"] ?? "";
                      bubbleChild = GestureDetector(
                        onTap: () {
                          // full screen image
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => _FullScreenImage(url: url),
                          ));
                        },
                        child: Image.network(
                          url,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox(child: Text("Image load failed")),
                        ),
                      );
                    } else if (type == "pdf") {
                      final url = msg["fileUrl"] ?? "";
                      final fileName = msg["fileName"] ?? "Document.pdf";
                      bubbleChild = GestureDetector(
                        onTap: () => _openUrl(url),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.picture_as_pdf, color: Colors.white),
                            const SizedBox(width: 8),
                            Flexible(
                                child: Text(
                              fileName,
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            )),
                          ],
                        ),
                      );
                    } else {
                      bubbleChild = Text("Unsupported message type");
                    }
    
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          
                          color: isMe ? Colors.black87 : const Color(0xFF0F4E82),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg["senderName"] ?? "Unknown",
                              style: const TextStyle(
                                  color: Color(0xFF3B82F6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            bubbleChild,
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
    
          if (uploading) LinearProgressIndicator(),
    
          // input row: [image][pdf][text field][send]
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)
              ],
            ),
            child: Row(
              children: [
                // image button
                IconButton(
                  icon: const Icon(Icons.photo, color: Colors.black87),
                  onPressed: pickImageAndSend,
                ),
    
                // pdf button
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.black87),
                  onPressed: pickPdfAndSend,
                ),
    
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black87,
                    controller: msgController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87)
                      ),
                      hintText: "Write a message...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
    
                // send button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _sendText,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  final String url;
  const _FullScreenImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black87),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          child: Image.network(url, errorBuilder: (_, __, ___) => const Text("Can't load")),
        ),
      ),
    );
  }
}
