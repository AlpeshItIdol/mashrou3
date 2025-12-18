import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/model/property/property_list_response_model.dart';

part 'web_view_state.dart';

class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit() : super(WebViewInitial());
  var supportData = Support();

  Future<void> getData() async {
    supportData =
        (await GetIt.I<AppPreferences>().getSupportDetails()) ?? Support();
    emit(SupportDataLoaded());
  }

  void startLoading() => emit(WebViewLoadingStatus(true));

  void finishLoading() => emit(WebViewLoadingStatus(false));
}
