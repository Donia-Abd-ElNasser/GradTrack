class UserModel {
  final String name;
  final String role;
  final String code;
  final String phone;
  final String email;
  final String gender;
  final String id; // <-- doc.id الحقيقي
  final String t1, t2, t3;

  bool selected;

  UserModel({
    this.selected = false,
    required this.t1,
    required this.t2,
    required this.t3,
    required this.id,
    required this.name,
    required this.role,
    required this.code,
    required this.phone,
    required this.email,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String docId) {
    return UserModel(
      selected: false,
      id: docId,
      name: json['name'] ?? "",
      role: json['role'] ?? "",
      code: json['code'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      gender: json['gender'] ?? "",
      t1: json['team1'] ?? '',
      t2: json['team2'] ?? '',
      t3: json['team3'] ?? '',
    );
  }
}
