part of 'cms_cubit.dart';

sealed class CmsState extends Equatable {
  const CmsState();
}

final class CmsInitial extends CmsState {
  @override
  List<Object> get props => [];
}
