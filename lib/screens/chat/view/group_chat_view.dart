import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradtrack/core/custom_app_bar.dart';


import 'package:gradtrack/screens/auth/model/group_model.dart';
import 'package:gradtrack/screens/chat/messages_cubit/messages_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

 Future<void> fetchCurrentUser() async {
  final prefs = await SharedPreferences.getInstance();

  final savedUserId = prefs.getString("userId");
  final savedName = prefs.getString("userName");

  if (savedUserId == null) {
    print("===== No Saved User ID, user not logged in =====");
    return;
  }

  print("Loaded User → ID: $savedUserId | Name: $savedName");

  setState(() {
    userId = savedUserId;
    userName = savedName ?? "Unknown";
  });
}


  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => MessagesCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
         appBar:AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: SafeArea(
            child: Row(
             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: width * 0.10,
                      height: width * 0.10,
                      child: IconButton(
                        onPressed: () {
                          (context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,color: Colors.white,
                        ),
                      ),
                    ),
                   SizedBox(width:14,),
                     Text(
                       widget.groupModel.name,
                       style: const TextStyle(
                         fontSize: 24,
                         fontWeight: FontWeight.w700,
                         color: Colors.black87,
                       ),
                     ),
                 ],
               ),
          ),),
        body: userId == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
              children: [
                // GROUP TITLE
              
            
                // STREAM OF MESSAGES
                StreamBuilder<QuerySnapshot>(
                  stream: context
                      .read<MessagesCubit>()
                      .getMessages(widget.groupModel.id),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs ?? [];
            
                    final firestoreMsgs = docs.map((d) {
                      return d.data() as Map<String, dynamic>;
                    }).toList();
            
                    final allMsgs =firestoreMsgs;
            
                    if (allMsgs.isEmpty) {
                      return const Center(child: Text("No messages yet"));
                    }
            
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: allMsgs.length,
                      itemBuilder: (context, i) {
                        final msg = allMsgs[i];
                        final isMe = msg["senderId"] == userId;
            
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                            color: isMe?Colors.black:const Color.fromARGB(255, 15, 78, 129),
                              // gradient:
                              //   isMe?LinearGradient(colors: []):  LinearGradient(colors: kGradient),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg["senderName"] ?? "Unknown",
                                  style: const TextStyle(
                                    color: Color(0xFF3B82F6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  msg["text"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Spacer(),
                Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black87,
           // borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: msgController,
                  decoration: const InputDecoration(

                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14),
                    hintText: "Write a message...",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, size: 28, color: Colors.white),
                onPressed: () {
                  final text = msgController.text.trim();
                  if (text.isEmpty) return;

                  if (userId == null || userName == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Loading user data...")),
                    );
                    return;
                  }

                  final newMsg = {
                    "senderId": userId!,
                    "senderName": userName!,
                    "text": text,
                  };

                  // setState(() {
                  //   localMessages.add(newMsg);
                  // });

                  context.read<MessagesCubit>().sendMessage(
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

        // INPUT FIELD
       // bottomNavigationBar: 
      ),
    );
  }
}
