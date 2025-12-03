import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/model/user_model.dart';

part 'all_student_state.dart';

class AllStudentCubit extends Cubit<AllStudentsState> {
  AllStudentCubit() : super(StudentsLoading()) {
    getAllStudents();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<UserModel> _students = [];

  void getAllStudents() async {
    emit(StudentsLoading());
    try {
      final res = await _firestore
          .collection("users")
          .where("role", isEqualTo: "student")
          .get();

     _students = res.docs
    .map((e) => UserModel.fromJson(e.data(), e.id))
    .toList();


      emit(StudentsSuccess(List.from(_students)));
    } catch (e) {
      emit(StudentsFailure(e.toString()));
    }
  }

  /// ⭐ Toggle Checkbox
  void toggleSelect(int index) {
    _students[index].selected = !_students[index].selected;
    emit(StudentsSuccess(List.from(_students)));
  }

  /// ⭐ Return selected students
  List<UserModel> getSelectedStudents() {
    return _students.where((e) => e.selected).toList();
  }
}
