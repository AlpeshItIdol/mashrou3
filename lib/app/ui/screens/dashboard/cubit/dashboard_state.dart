part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

final class DashboardLoading extends DashboardState {
  @override
  List<Object> get props => [];
}

final class APISuccess extends DashboardState {
  @override
  List<Object> get props => [];
}

final class PropertyCategoryListUpdate extends DashboardState {
  @override
  List<Object> get props => [];
}

final class GuestUserState extends DashboardState {
  @override
  List<Object> get props => [];
}

final class GuestUserInitState extends DashboardState {
  @override
  List<Object> get props => [];
}

final class LogoutSuccess extends DashboardState {
  @override
  List<Object> get props => [];
}

final class LogoutLoading extends DashboardState {
  @override
  List<Object> get props => [];
}


class LogoutError extends DashboardState {
  String errorMessage;

  LogoutError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}


class DashboardSideDrawerChange extends DashboardState {
  final int drawerIndex;

  const DashboardSideDrawerChange({this.drawerIndex = 0});

  @override
  List<Object?> get props => [drawerIndex];
}

class DashboardPageChange extends DashboardState {
  final int pageIndex;

  const DashboardPageChange({this.pageIndex = 0});

  @override
  List<Object?> get props => [pageIndex];
}
