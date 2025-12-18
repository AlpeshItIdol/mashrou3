part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();
}

final class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

final class NotificationLoading extends NotificationState {
  @override
  List<Object> get props => [];
}
final class NotificationMoreLoading extends NotificationState {
  @override
  List<Object> get props => [];
}

final class NoNotificationAvailable extends NotificationState {
  @override
  List<Object> get props => [];
}

final class ReadNotificationLoading extends NotificationState {
  @override
  List<Object> get props => [];
}
final class NotificationReadSuccessFully extends NotificationState {
  int index;

  NotificationReadSuccessFully(this.index);

  @override
  List<Object> get props => [this.index];
}

final class NotificationAvailable extends NotificationState {
  bool isLastPage;
  int currentKey;
  List<NotificationList> notificationList;

    NotificationAvailable(this.isLastPage, this.currentKey, this.notificationList);

  @override
  List<Object> get props => [];
}

final class NotificationError extends NotificationState {
  final String errorMessage;

  const NotificationError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
