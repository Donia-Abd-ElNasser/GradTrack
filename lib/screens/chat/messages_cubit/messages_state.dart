part of 'messages_cubit.dart';

@immutable
sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}
final class MessagesSuccess extends MessagesState {}
final class MessagesFailure extends MessagesState {}
final class MessagesLoading extends MessagesState {}
