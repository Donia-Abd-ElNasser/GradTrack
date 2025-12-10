import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradtrack/screens/all_groups/group/groups_state.dart';
import 'package:gradtrack/screens/auth/model/group_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit() : super(GroupsInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchGroups() async {
    try {
      emit(GroupsLoading());

      // LOAD USER ID
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("userId");

      if (userId == null) {
        emit(GroupsFailure("No user logged in"));
        return;
      }

      // QUERY GROUPS THAT CONTAIN THIS USER
      final snap = await _firestore
          .collection("groups")
          .where("members", arrayContains: userId)
          .get();

      final groups = snap.docs
          .map((doc) => GroupModel.fromJson(doc.data(), doc.id))
          .toList();

      emit(GroupsSuccess(groups));
    } catch (e) {
      emit(GroupsFailure(e.toString()));
    }
  }
}
