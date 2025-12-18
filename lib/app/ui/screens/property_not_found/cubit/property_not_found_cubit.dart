import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/common_only_message_response_model.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/country_selection_cubit.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../../../../../config/resources/app_constants.dart';

part 'property_not_found_state.dart';

class PropertyNotFoundCubit extends Cubit<PropertyNotFoundState> {
  

  PropertyNotFoundCubit() : super(PropertyNotFoundInitial());

  var token = "";

 

}
