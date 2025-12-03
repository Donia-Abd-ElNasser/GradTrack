
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradtrack/screens/all_chats/group/groups_state.dart';
import 'package:gradtrack/screens/auth/model/group_model.dart';


class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit() : super(GroupsInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ▌▌ 1) Create Group
   Future<void> fetchGroups() async {
    try {
      emit(GroupsLoading());

      final snap = await _firestore.collection("groups").get();

      final groups = snap.docs
          .map((doc) => GroupModel.fromJson(doc.data(), doc.id))
          .toList();

      emit(GroupsSuccess(groups));
    } catch (e) {
      emit(GroupsFailure(e.toString()));
    }
  }
}
