import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradtrack/screens/auth/model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const usersCollection = "users";

  Future<void> loginStudent({
    required String name,
    required String code,
  }) async {
    emit(AuthLoading());

    try {
      final result =
          await _firestore
              .collection(usersCollection)
              .where("role", isEqualTo: "student")
              .where("code", isEqualTo: code.trim())
              .limit(1)
              .get();
      print('<================>${result}<=======================>');
      if (result.docs.isEmpty) {
        emit(AuthFailure(errmssg: "No student found with this code"));
        return;
      }

      // final data = result.docs.first.data();
      final doc = result.docs.first;
      final data = doc.data();

      // Check if name matches
      if (data["name"].toString().toLowerCase() != name.toLowerCase().trim()) {
        emit(AuthFailure(errmssg: "Wrong student name"));
        return;
      }

      final user = UserModel.fromJson(data, doc.id);

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
      final result =
          await _firestore
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

      emit(AuthSuccess(userModel: user));
    } catch (e) {
      emit(AuthFailure(errmssg: e.toString()));
    }
  }
}
