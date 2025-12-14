import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

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
    // 1. Get the safe file extension using the 'path' package
    final fileExtension = p.extension(file.path).toLowerCase().replaceAll('.', '');
    
    // Fallback in case path package fails to extract a standard extension
    if (fileExtension.isEmpty) {
        throw Exception("Could not determine file extension for path: ${file.path}");
    }

    // 2. Tweak the storage path
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("group_images/$groupId/${DateTime.now().millisecondsSinceEpoch}.$fileExtension");

    print("UPLOAD TO PATH: ${storageRef.fullPath}");
    print("FILE PATH: ${file.path}");

    // 3. Use putFile (Simpler and often more reliable than putData)
    await storageRef.putFile(
      file,
      SettableMetadata(
        contentType: "image/$fileExtension", // Correct MIME type, e.g., image/jpeg
      ),
    );
    
    final imageUrl = await storageRef.getDownloadURL();

    // 4. Store in Firestore
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add({
      "senderId": senderId,
      "senderName": senderName,
      "fileUrl": imageUrl, // Changed from "imageUrl" to "fileUrl" for consistency with PDF
      "type": "image",
      "timestamp": FieldValue.serverTimestamp(),
    });

  } catch (e) {
    print("Image upload error: $e");
    // Re-throw the error so the UI can catch it (important for debugging)
    rethrow; 
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
    // تنظيف اسم الملف لتجنب مسافات أو أحرف غريبة
    final originalFileName = file.path.split('/').last;
    final extension = originalFileName.split('.').last.toLowerCase().trim();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';

    // تجهيز مسار التخزين
    final ref = FirebaseStorage.instance.ref()
        .child("group_files/$groupId/$fileName");

    print("UPLOAD PDF TO PATH: ${ref.fullPath}");
    print("LOCAL FILE PATH: ${file.path}");

    // رفع الملف
    final uploadTask = await ref.putFile(
      file,
      SettableMetadata(contentType: "application/pdf"),
    );

    print("Upload Done: ${uploadTask.bytesTransferred} bytes");

    // الحصول على رابط التحميل
    final url = await ref.getDownloadURL();
    print("Download URL: $url");

    // تخزين الرابط في Firestore
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add({
      "senderId": senderId,
      "senderName": senderName,
      "fileUrl": url,
      "fileName": originalFileName, // حفظ الاسم الأصلي للعرض
      "type": "pdf",
      "timestamp": FieldValue.serverTimestamp(),
    });

    print("PDF upload and Firestore entry successful.");
  } catch (e) {
    print("PDF upload error: $e");
  }
}
}
