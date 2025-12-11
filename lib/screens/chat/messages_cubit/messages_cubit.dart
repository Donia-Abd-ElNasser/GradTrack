import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // ----------------------------------------------------------
  // SEND TEXT
  // ----------------------------------------------------------
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
      "timestamp": FieldValue.serverTimestamp(),
      "type": "text",
    });
  }

  // ----------------------------------------------------------
  // STREAM
  // ----------------------------------------------------------
  Stream<QuerySnapshot> getMessages(String groupId) {
    return _firestore
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // ----------------------------------------------------------
  // IMAGE UPLOAD (FIXED)
  // ----------------------------------------------------------
  Future<void> sendImageMessage({
  required String groupId,
  required File file,
  required String senderId,
  required String senderName,
}) async {
 
  try {

    final extension = file.path.split('/').last;
   
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("group_images/$groupId/${DateTime.now().millisecondsSinceEpoch}.jpg");

    print("UPLOAD TO PATH: ${storageRef.fullPath}");
    print("FILE PATH: ${file.path}");

    // اقرأ الصورة كـ bytes
    final bytes = await file.readAsBytes();

    // ارفعها بـ putData بدلاً من putFile
    await storageRef.putData(
      bytes,
      SettableMetadata(contentType: "image/$extension"),
    );

    final imageUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add({
      "senderId": senderId,
      "senderName": senderName,
      "imageUrl": imageUrl,
      "type": "image",
      "timestamp": FieldValue.serverTimestamp(),
    });
  } catch (e) {
     print("FILE PATH: ${file.path}");
     print('------------------$groupId--------${file.path}---------$senderId----------$senderName-------------');
    print("Image upload error: $e");
  }
}

  // ----------------------------------------------------------
  // PDF UPLOAD (FIXED)
  // ----------------------------------------------------------
  Future<void> sendPDFMessage({
    required String groupId,
    required File file,
    required String senderId,
    required String senderName,
  }) async {
    try {
      final fileName = file.path.split('/').last;

      final ref = _storage.ref(
        "group_files/$groupId/${DateTime.now().millisecondsSinceEpoch}.pdf",
      );

      final uploadTask = await ref.putFile(file);
print('Upload Done ${uploadTask.bytesTransferred}');

      final url = await ref.getDownloadURL();

      await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("messages")
          .add({
        "senderId": senderId,
        "senderName": senderName,
        "fileUrl": url,
        "fileName": fileName,
        "type": "pdf",
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("PDF upload error: $e");
    }
  }
}
