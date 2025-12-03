// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final List<String> members;
  final Timestamp time;

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.time,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json, String docId) {
    return GroupModel(
      time: json['createdAt']??"",
      id: docId,
      name: json["name"] ?? "",
      members: List<String>.from(json["members"] ?? []),

    );
  }
}
