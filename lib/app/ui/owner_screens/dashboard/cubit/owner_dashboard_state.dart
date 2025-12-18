part of 'owner_dashboard_cubit.dart';

sealed class OwnerDashboardState extends Equatable {
  const OwnerDashboardState();
}

final class OwnerDashboardInitial extends OwnerDashboardState {
  @override
  List<Object> get props => [];
}

final class OwnerDashboardLoading extends OwnerDashboardState {
  @override
  List<Object> get props => [];
}

final class OwnerDashboardError extends OwnerDashboardState {
  String errorMessage;

  OwnerDashboardError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class APISuccess extends OwnerDashboardState {
  @override
  List<Object> get props => [];
}

final class LogoutSuccess extends OwnerDashboardState {
  @override
  List<Object> get props => [];
}

final class LogoutLoading extends OwnerDashboardState {
  @override
  List<Object> get props => [];
}

class LogoutError extends OwnerDashboardState {
  final String errorMessage;

  const LogoutError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class PropertyCategoryListUpdate extends OwnerDashboardState {
  @override
  List<Object> get props => [];
}

final class GuestUserState extends OwnerDashboardState {
  @override
  List<Object> get props => [];
}

class OwnerDashboardSideDrawerChange extends OwnerDashboardState {
  final int drawerIndex;

  const OwnerDashboardSideDrawerChange({this.drawerIndex = 0});

  @override
  List<Object?> get props => [drawerIndex];
}

class OwnerDashboardPageChange extends OwnerDashboardState {
  final int pageIndex;

  const OwnerDashboardPageChange({this.pageIndex = 0});

  @override
  List<Object?> get props => [pageIndex];
}
