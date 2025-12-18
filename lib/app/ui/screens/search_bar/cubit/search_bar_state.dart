part of 'search_bar_cubit.dart';

abstract class SearchBarState extends Equatable {
  const SearchBarState();
}

class SearchBarInitial extends SearchBarState {
  @override
  List<Object> get props => [];
}

class SearchBarLoading extends SearchBarState {
  @override
  List<Object> get props => [];
}

class SearchBarSuccess extends SearchBarState {


  const SearchBarSuccess();

  @override
  List<Object> get props => [];
}

class GetSearchUpdate extends SearchBarState {
  @override
  List<Object> get props => [];
}

class SearchInit extends SearchBarState {
  @override
  List<Object> get props => [];
}

class SetSearchUpdate extends SearchBarState {
  @override
  List<Object> get props => [];
}
class SearchBarError extends SearchBarState {
  final String errorMessage;

  const SearchBarError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}



class SuffixBoolChangedStateInitial extends SearchBarState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedState extends SearchBarState {
  bool showBool;

  SuffixBoolChangedState({required this.showBool});

  @override
  List<Object> get props => [this.showBool];
}
