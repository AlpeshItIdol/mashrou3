
import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawer_vendors_list_state.dart';

class DrawerVendorsListCubit extends Cubit<DrawerVendorListState> {
  final dynamic repository;
  
  DrawerVendorsListCubit({required this.repository}) : super(DrawerVendorListInitial());
}