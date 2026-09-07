import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobish_task/api/dio_helper.dart';
import 'package:jobish_task/app_config.dart';
import 'package:jobish_task/models/product_list_model.dart';
import 'package:jobish_task/ui/home/states/home_state.dart';
import 'package:jobish_task/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(final BuildContext context) =>
      BlocProvider.of<HomeCubit>(context);

  late final TextEditingController searchController = TextEditingController();

  static const int pageLimit = 30;

  static const String _cachedProductsKey = 'cached_products';
  static const String _cachedTotalKey = 'cached_total';

  List<Products> allProducts = [];
  List<Products> productList = [];

  int totalProducts = 0;

  bool isLoadingMore = false;

  void clearControllers() {
    searchController.clear();
  }

  Future<void> _saveProductsToCache() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final productsJson = allProducts
          .map((final product) => product.toJson())
          .toList();

      await preferences.setString(_cachedProductsKey, jsonEncode(productsJson));

      await preferences.setInt(_cachedTotalKey, totalProducts);

      debugPrint('Products cached successfully: ${allProducts.length}');
    } catch (error) {
      debugPrint('Cache save error: $error');
    }
  }

  Future<bool> loadProductsFromCache() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final cachedData = preferences.getString(_cachedProductsKey);

      if (cachedData == null || cachedData.isEmpty) {
        return false;
      }

      final decodedData = jsonDecode(cachedData);

      if (decodedData is! List) {
        return false;
      }

      final cachedProducts = decodedData
          .map(
            (final product) =>
                Products.fromJson(product as Map<String, dynamic>),
          )
          .toList();

      if (cachedProducts.isEmpty) {
        return false;
      }

      allProducts = List<Products>.from(cachedProducts);
      productList = List<Products>.from(cachedProducts);

      totalProducts = preferences.getInt(_cachedTotalKey) ?? 0;

      emit(
        GetProductsState(
          ProductListModel(
            products: productList,
            total: totalProducts,
            skip: 0,
            limit: pageLimit,
          ),
        ),
      );

      debugPrint('Products loaded from cache: ${allProducts.length}');

      return true;
    } catch (error) {
      debugPrint('Cache load error: $error');
      return false;
    }
  }

  Future<void> getProductList({required final int offset}) async {
    if (offset == 0) {
      emit(ProductsLoading());
    } else {
      isLoadingMore = true;

      emit(
        GetProductsState(
          ProductListModel(products: productList, total: totalProducts),
        ),
      );
    }

    try {
      final response = await DioHelper.getData(
        url: ApiConfig.products,
        query: {'limit': pageLimit, 'skip': offset},
      );

      if (response.statusCode == 200) {
        final successModel = ProductListModel.fromJson(
          response.data as Map<String, dynamic>? ?? {},
        );

        final products = successModel.products;

        totalProducts = successModel.total ?? 0;

        if (offset == 0) {
          allProducts = List<Products>.from(products);
          productList = List<Products>.from(products);
        } else {
          allProducts.addAll(products);
          productList.addAll(products);
        }

        await _saveProductsToCache();

        emit(
          GetProductsState(
            ProductListModel(
              products: productList,
              total: totalProducts,
              skip: successModel.skip,
              limit: successModel.limit,
            ),
          ),
        );
      } else {
        await _handleApiError(offset, statusCode: response.statusCode);
      }
    } on DioException catch (error) {
      debugPrint('API Error: $error');

      await _handleApiError(offset, statusCode: error.response?.statusCode);
    } catch (error) {
      debugPrint('API Error: $error');

      await _handleApiError(offset);
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> _handleApiError(
    final int offset, {
    final int? statusCode,
  }) async {
    if (offset == 0) {
      final hasCache = await loadProductsFromCache();

      if (hasCache) {
        debugPrint('Showing cached products because API failed.');
        return;
      }
    }

    final message = _messageForStatusCode(statusCode);

    showMessage(message: message);

    emit(ProductsError(message));
  }

  String _messageForStatusCode(final int? statusCode) {
    switch (statusCode) {
      case 429:
        return 'Too many requests. Please wait a few seconds and try again.';
      case 500:
      case 502:
      case 503:
        return 'Something went wrong on our end. Please try again later.';
      case null:
        return 'No internet connection. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  void searchProducts(final String query) {
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      productList = List<Products>.from(allProducts);
    } else {
      productList = allProducts.where((final product) {
        final title = product.title?.toLowerCase() ?? '';
        final description = product.description?.toLowerCase() ?? '';
        final category = product.category?.toLowerCase() ?? '';

        return title.contains(searchQuery) ||
            description.contains(searchQuery) ||
            category.contains(searchQuery);
      }).toList();
    }

    emit(
      GetProductsState(
        ProductListModel(products: productList, total: totalProducts),
      ),
    );
  }
}
