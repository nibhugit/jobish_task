import 'package:jobish_task/models/product_list_model.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class ProductsLoading extends HomeState {}

class ProductsLoaded extends HomeState {}

class GetProductsState extends HomeState {
  GetProductsState(this.model);

  final ProductListModel model;
}

class ProductsError extends HomeState {
  ProductsError(this.message);

  final String message;
}

class ProductsLoadingMore extends HomeState {}

class ProductsLoadMoreError extends HomeState {
  ProductsLoadMoreError(this.message);

  final String message;
}
