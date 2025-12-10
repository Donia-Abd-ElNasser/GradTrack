part of 'group_creation_cubit.dart';


abstract class GroupCreationState {}

final class GroupCreationInitial extends GroupCreationState {}
final class GroupCreationSuccess extends GroupCreationState {
  final String groupid;

  GroupCreationSuccess({required this.groupid});
}
final class GroupCreationLoading extends GroupCreationState {
  
}
final class GroupCreationFailure extends GroupCreationState {
  final String errmssg;

  GroupCreationFailure({required this.errmssg});

}