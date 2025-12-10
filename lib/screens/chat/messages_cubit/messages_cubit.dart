import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String userDocId;
late String userName;
  Future<void> sendMessage({
    required String groupId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    await _firestore
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add({
      "text": text,
      "senderId": senderId,
      "senderName": senderName,
      "timestamp": FieldValue.serverTimestamp()
    });
  }

  Stream<QuerySnapshot> getMessages(String groupId) {
    return _firestore
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();
  }


Future<void> getCurrentUserDoc() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final querySnapshot = await FirebaseFirestore.instance
      .collection("users")
      .where("uid", isEqualTo: uid) // افترضنا إن عندك حقل uid في المستند
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    userDocId = querySnapshot.docs.first.id; // هنا doc id
    userName = querySnapshot.docs.first.data()['name'] ?? "Unknown";
  }
}
}