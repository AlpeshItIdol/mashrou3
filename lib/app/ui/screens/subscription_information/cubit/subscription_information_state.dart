part of 'subscription_information_cubit.dart';

sealed class SubscriptionInformationState extends Equatable {
  const SubscriptionInformationState();
}

final class SubscriptionInformationInitial extends SubscriptionInformationState {
  @override
  List<Object> get props => [];
}

final class LoadingUserStatus extends SubscriptionInformationState {
  @override
  List<Object> get props => [];
}
final class UserStatusSubscribed extends SubscriptionInformationState {
  @override
  List<Object> get props => [];
}
