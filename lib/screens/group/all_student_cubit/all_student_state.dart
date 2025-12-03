part of 'all_student_cubit.dart';

abstract class AllStudentsState {}

class StudentsInitial extends AllStudentsState {}

class StudentsLoading extends AllStudentsState {}

class StudentsSuccess extends AllStudentsState {
  final List<UserModel> students;
  StudentsSuccess(this.students);
}

class StudentsFailure extends AllStudentsState {
  final String error;
  StudentsFailure(this.error);
}