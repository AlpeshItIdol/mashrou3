part of 'web_view_cubit.dart';

abstract class WebViewState extends Equatable {}

final class WebViewInitial extends WebViewState {
  @override
  List<Object?> get props => [];
}

final class WebViewLoadingStatus extends WebViewState {
  final bool isLoading;

  WebViewLoadingStatus(this.isLoading);

  @override
  List<Object?> get props => [isLoading];
}

final class SupportDataLoaded extends WebViewState {
  @override
  List<Object?> get props => [];
}
