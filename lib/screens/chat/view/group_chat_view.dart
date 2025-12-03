// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:gradtrack/screens/auth/model/group_model.dart';
import 'package:gradtrack/screens/chat/messages_cubit%5D/messages_cubit.dart';

class GroupChatView extends StatefulWidget {
  final GroupModel groupModel;

  const GroupChatView({Key? key, required this.groupModel}) : super(key: key);

  @override
  State<GroupChatView> createState() => _GroupChatViewState();
}

class _GroupChatViewState extends State<GroupChatView> {
  final TextEditingController msgController = TextEditingController();
  List<Map<String, dynamic>> localMessages = [];

  late String userId;
  late String userName;

  @override
  void initState() {
    super.initState();
    getCurrentUserDoc();
  }

  Future<void> getCurrentUserDoc() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      setState(() {
        userId = doc.id;
        print(
          '---------------->${doc.id}------------------>',
        );
        userName = doc.data()['name'] ?? "Unknown";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessagesCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,appBar: AppBar(backgroundColor: Colors.white,
          leading: BackButton(),),
        body: SingleChildScrollView(
         // padding: EdgeInsets.all(15),
          child: Column(
            children: [
              // عنوان الجروب
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.groupModel.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
          
              // الرسائل
              StreamBuilder(
                stream: BlocProvider.of<MessagesCubit>(
                  context,
                ).getMessages(widget.groupModel.id),
                builder: (context, snapshot) {
                  final docs = snapshot.data?.docs ?? [];
                  List<Map<String, dynamic>> firestoreMessages =
                      docs
                          .map((d) => d.data() as Map<String, dynamic>? ?? {})
                          .toList();
                        
                  final allMessages = [...localMessages, ...firestoreMessages];
                        
                  if (allMessages.isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }
                        
                  return ListView.builder(
                     shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: allMessages.length,
                    itemBuilder: (context, i) {
                      final msg = allMessages[i];
                      final isMe = (msg["senderId"] ?? "") == (userId ?? "");
                        
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: kGradient),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg["senderName"] ?? "Unknown",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                msg["text"] ?? "",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          
              // كتابة رسالة
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: msgController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(14),
                          hintText: "Write a message...",
                          // border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, size: 28),
                      onPressed: () {
    if (userId == null || userName == null) {
      // المستخدم لسه البيانات بتاعته مش جاهزة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Loading user data...")),
      );
      return;
    }

    final text = msgController.text.trim();
    if (text.isEmpty) return;

    final newMsg = {
      "senderId": userId!,
      "senderName": userName!,
      "text": text,
    };

    setState(() {
      localMessages.add(newMsg);
    });

    BlocProvider.of<MessagesCubit>(context).sendMessage(
      groupId: widget.groupModel.id,
      text: text,
      senderId: userId!,
      senderName: userName!,
    );

    msgController.clear();
  },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
