


import 'package:gradtrack/screens/auth/model/group_model.dart';

abstract class GroupsState {}

final class GroupsInitial extends GroupsState {}

final class GroupsSuccess extends GroupsState {
 final List<GroupModel> groups;

  GroupsSuccess( this.groups);
}
final class GroupsLoading extends GroupsState {}
final class GroupsFailure extends GroupsState {
  final String errrmssg;

  GroupsFailure( this.errrmssg);
}