import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'group_creation_state.dart';

class GroupCreationCubit extends Cubit<GroupCreationState> {
  GroupCreationCubit() : super(GroupCreationInitial());

  Future<void> createGroup({
    required String groupName,
    required List<String> memberIds,
  }) async {
    emit(GroupCreationLoading());

    try {
      final doc = await FirebaseFirestore.instance.collection('groups').add({
        "name": groupName,
        "members": memberIds,
        "membersCount": memberIds.length,
        "lastMsg": "",
        "lastMsgTime": FieldValue.serverTimestamp(),
        "createdAt": Timestamp.now(),
      });

      // مهم جداً: نرجّع الـ groupId
      emit(GroupCreationSuccess(groupid:  doc.id));

    } catch (e) {
      emit(GroupCreationFailure(errmssg: e.toString()));
    }
  }
}
