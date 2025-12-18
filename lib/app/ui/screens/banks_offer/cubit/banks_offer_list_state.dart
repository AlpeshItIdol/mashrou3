// part of 'banks_offer_list_cubit.dart';
//
// sealed class BanksOfferListState extends Equatable {
//   const BanksOfferListState();
// }
//
// final class BankOffersListInitial extends BanksOfferListState {
//   @override
//   List<Object> get props => [];
// }
//
// final class BankOffersListLoading extends BanksOfferListState {
//   @override
//   List<Object> get props => [];
// }
//
// final class BankOffersListSuccess extends BanksOfferListState {
//   final List<dynamic> offers;
//   final bool isLastPage;
//   final int currentPage;
//
//   const BankOffersListSuccess(this.offers, this.isLastPage, this.currentPage);
//
//   @override
//   List<Object?> get props => [offers, isLastPage, currentPage];
// }
//
// final class NoBankOffersFoundState extends BanksOfferListState {
//   @override
//   List<Object> get props => [];
// }
//
// final class BankOffersListError extends BanksOfferListState {
//   final String message;
//   const BankOffersListError(this.message);
//
//   @override
//   List<Object> get props => [message];
// }
//
// final class BankOffersRefreshLoading extends BanksOfferListState {
//   @override
//   List<Object> get props => [];
// }
//

part of 'banks_offer_list_cubit.dart';

@immutable
abstract class BanksOfferListState extends Equatable {
  const BanksOfferListState();

  @override
  List<Object?> get props => [];
}

class BankOffersListInitial extends BanksOfferListState {}

class BankOffersListLoading extends BanksOfferListState {}

class BankOffersRefreshLoading extends BanksOfferListState {}

// Success state now includes 'offers' and 'hasMoreData'
class BankOffersListSuccess extends BanksOfferListState {
  final List<BankUserList> offers;
  final bool hasMoreData;

  const BankOffersListSuccess({required this.offers, required this.hasMoreData});

  @override
  List<Object?> get props => [offers, hasMoreData];
}

class NoBankOffersFoundState extends BanksOfferListState {}

// Error state now includes 'isFirstFetch'
class BankOffersListError extends BanksOfferListState {
  final String message;
  final bool isFirstFetch;

  const BankOffersListError(this.message, {required this.isFirstFetch});

  @override
  List<Object?> get props => [message, isFirstFetch];
}
