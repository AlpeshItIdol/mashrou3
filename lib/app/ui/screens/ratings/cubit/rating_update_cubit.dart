import 'package:bloc/bloc.dart';

class RatingUpdateCubit extends Cubit<int?> {
  RatingUpdateCubit() : super(null) {
    selectDefaultRating();
  }

  void selectDefaultRating() {
    const defaultRating = 0;
    emit(defaultRating);
  }

  void updateRating(int rating) => emit(rating);
}
