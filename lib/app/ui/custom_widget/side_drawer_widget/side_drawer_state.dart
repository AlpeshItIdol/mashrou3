part of 'side_drawer_cubit.dart';

sealed class SideDrawerState extends Equatable {
  const SideDrawerState();
}

final class SideDrawerInitial extends SideDrawerState {
  @override
  List<Object> get props => [];
}
final class SideDrawerDataSet extends SideDrawerState {
  @override
  List<Object> get props => [];
}
final class SideDrawerImgDataSet extends SideDrawerState {
  @override
  List<Object> get props => [];
}