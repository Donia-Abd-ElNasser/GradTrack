import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradtrack/core/shared_preferences.dart';
import 'package:gradtrack/screens/auth/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final FirebaseAuth auth = FirebaseAuth.instance;
  static const usersCollection = "users";
    User? get currentUser => auth.currentUser;
  String? get currentUserId => auth.currentUser?.uid;

 Future<void> loginStudent({
  required String name,
  required String code,
}) async {
  emit(AuthLoading());

  try {
    final result = await _firestore
        .collection(usersCollection)
        .where("role", isEqualTo: "student")
        .where("code", isEqualTo: code.trim())
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      emit(AuthFailure(errmssg: "No student found with this code"));
      return;
    }

    final doc = result.docs.first;
    final data = doc.data();

    if (data["name"].toString().toLowerCase() != name.toLowerCase().trim()) {
      emit(AuthFailure(errmssg: "Wrong student name"));
      return;
    }

    final user = UserModel.fromJson(data, doc.id);

    // SAVE USER DATA LOCALLY
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", doc.id);
    await prefs.setString("userName", data["name"]);
    await prefs.setString("role", data["role"]);

    emit(AuthSuccess(userModel: user));
  } catch (e) {
    emit(AuthFailure(errmssg: e.toString()));
  }
}


  Future<void> loginSupervisor({
  required String name,
  required String phone,
}) async {
  emit(AuthLoading());

  try {
    final result = await _firestore
        .collection(usersCollection)
        .where("role", isEqualTo: "supervisor")
        .where("phone", isEqualTo: phone.trim())
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      emit(AuthFailure(errmssg: "Supervisor not found"));
      return;
    }

    final doc = result.docs.first;
    final data = doc.data();

    if (data["name"].toString().toLowerCase() != name.toLowerCase().trim()) {
      emit(AuthFailure(errmssg: "Wrong supervisor name"));
      return;
    }

    final user = UserModel.fromJson(data, doc.id);

    // SAVE USER DATA LOCALLY
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", doc.id);
    await prefs.setString("userName", data["name"]);
    await prefs.setString("role", data["role"]);
 final savedprefs = await SharedPreferences.getInstance();
    final savedUserId = savedprefs.getString("userId");
    final savedrole = savedprefs.getString("userId");
    //final savedUserId = savedprefs.getString("userId");
    print('===================>${savedUserId}${savedrole}==============');
    emit(AuthSuccess(userModel: user));
  } catch (e) {
    emit(AuthFailure(errmssg: e.toString()));
  }

}

Future<UserModel?> getCurrentUserData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    // No saved user
    if (userId == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();

    if (!doc.exists || doc.data() == null) return null;

    return UserModel.fromJson(doc.data()!, doc.id);
  } catch (e) {
    print("Error fetching current user: $e");
    return null;
  }
}

void Logout()async{
 await CacheHelper.removeData(key: 'token');



}
}
