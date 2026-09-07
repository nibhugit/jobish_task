import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobish_task/models/product_list_model.dart';
import 'package:jobish_task/ui/favorite/states/favorite_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitialState()) {
    loadFavorites();
  }

  static FavoriteCubit get(final BuildContext context) =>
      BlocProvider.of<FavoriteCubit>(context);

  static const String _favoritePreferenceKey = 'key_favorite_products';

  List<Products> favoriteProducts = [];

  bool isFavorite(final int? productId) {
    if (productId == null) return false;
    return favoriteProducts.any((final item) => item.id == productId);
  }

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_favoritePreferenceKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = jsonDecode(jsonStr);
        if (decoded is List) {
          favoriteProducts = decoded
              .map(
                (final item) =>
                    Products.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
      }
    } catch (_) {}
    emit(FavoriteUpdatedState(List<Products>.from(favoriteProducts)));
  }

  Future<void> toggleFavorite(final Products product) async {
    if (product.id == null) return;

    final index =
        favoriteProducts.indexWhere((final item) => item.id == product.id);

    if (index >= 0) {
      favoriteProducts.removeAt(index);
    } else {
      favoriteProducts.add(product);
    }

    emit(FavoriteUpdatedState(List<Products>.from(favoriteProducts)));

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList =
          favoriteProducts.map((final item) => item.toJson()).toList();
      await prefs.setString(_favoritePreferenceKey, jsonEncode(jsonList));
    } catch (_) {}
  }
}
