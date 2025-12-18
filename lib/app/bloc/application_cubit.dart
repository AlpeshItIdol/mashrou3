import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/resources/app_constants.dart';
import '../../config/utils.dart';
import '../model/property/property_category_response_model.dart';
import 'common_api_services/common_api_cubit.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationInitial());

  List<PropertyCategoryData>? propertyCategoryList = [];

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context) async {
    // await getPropertyCategoryList(context);
  }

  /// Property Category List API
  ///
  Future<void> getPropertyCategoryList(BuildContext context) async {
    emit(ApplicationLoading());

    final response =
        await context.read<CommonApiCubit>().fetchPropertyCategoryList(context);

    if (response is String) {
      emit(ApplicationError(errorMessage: response));
    } else {
      propertyCategoryList = response;
      printf("propertyCategoryList--------${propertyCategoryList?.length}");
      if (!context.mounted) return;
      AppConstants.setPropertyCategory(context, propertyCategoryList);
      emit(APISuccess());
    }
  }
}
