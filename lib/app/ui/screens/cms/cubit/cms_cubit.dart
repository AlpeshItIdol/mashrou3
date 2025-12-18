import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cms_state.dart';

class CmsCubit extends Cubit<CmsState> {
  CmsCubit() : super(CmsInitial());
}
