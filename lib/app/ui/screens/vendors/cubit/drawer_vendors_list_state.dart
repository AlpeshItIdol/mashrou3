
import 'package:equatable/equatable.dart';

sealed class DrawerVendorListState extends Equatable {
  DrawerVendorListState();
}
final class DrawerVendorListInitial extends DrawerVendorListState {
  @override
  List<Object> get props => [];
}