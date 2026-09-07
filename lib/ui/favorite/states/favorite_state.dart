import 'package:jobish_task/models/product_list_model.dart';

abstract class FavoriteState {
  const FavoriteState();
}

class FavoriteInitialState extends FavoriteState {}

class FavoriteUpdatedState extends FavoriteState {
  const FavoriteUpdatedState(this.favorites);

  final List<Products> favorites;
}
