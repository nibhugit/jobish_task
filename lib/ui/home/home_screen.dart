import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/routes/navigation_routes.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/ui/favorite/cubit/favorite_cubit.dart';
import 'package:jobish_task/ui/favorite/states/favorite_state.dart';
import 'package:jobish_task/ui/home/cubit/home_cubit.dart';
import 'package:jobish_task/ui/home/states/home_state.dart';
import 'package:jobish_task/ui/product_details/product_details_screen.dart';
import 'package:jobish_task/widgets/base_stateful_widget_state.dart';
import 'package:jobish_task/widgets/common_appbar.dart';
import 'package:jobish_task/widgets/text_field_widget.dart';
import 'package:jobish_task/widgets/text_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStatefulWidgetState<HomeScreen> {
  late final HomeCubit _homeCubit = HomeCubit.get(context);

  @override
  bool useSafeArea = true, extendBodyBehindAppBar = false;

  @override
  void initialize() {
    super.initialize();
    _homeCubit.clearControllers();
    _homeCubit.getProductList(offset: 0);

    _loadInitialProducts();
  }

  @override
  PreferredSizeWidget? buildAppBar(final BuildContext context) => CommonAppBar(
    title: 'Products',
    shouldShowBackButton: false,
    prefixWidget: Padding(
      padding: EdgeInsets.only(right: 20.r),
      child: IconButton(
        onPressed: () {},
        icon: Icon(Icons.notifications_none_rounded, size: 25.r),
      ),
    ),
  );

  Future<void> _loadInitialProducts() async {
    final hasCache = await _homeCubit.loadProductsFromCache();

    if (!hasCache) {
      await _homeCubit.getProductList(offset: 0);
    } else {
      await _homeCubit.getProductList(offset: 0);
    }
  }

  Future<void> _onRefresh() async {
    _homeCubit.clearControllers();

    await _homeCubit.getProductList(offset: 0);
  }

  @override
  Widget buildBody(final BuildContext context) => Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
        child: TextFieldWidget(
          hint: 'Search products...',
          maxLength: 40,
          controller: _homeCubit.searchController,
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.search,
          prefixIconWidget: Icon(Icons.search, size: 23.r),
          onChanged: (final value) {
            _homeCubit.searchProducts(value);
          },
        ),
      ),

      Expanded(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _onRefresh,
              child: _buildProductGrid(context),
            ),

            // 👇 NEW: bottom center loader for pagination (uses cubit's existing state stream)
            BlocBuilder<HomeCubit, HomeState>(
              builder: (final context, final state) => _homeCubit.isLoadingMore
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 16.r,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            height: 22.r,
                            width: 22.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildProductGrid(
    final BuildContext context,
  ) => BlocBuilder<HomeCubit, HomeState>(
    builder: (final context, final state) {
      final theme = Theme.of(context);
      final cardColor = theme.cardColor;
      final textPrimary = theme.colorScheme.onSurface;

      if (state is ProductsLoading) {
        return _buildProductShimmer(context);
      }

      if (state is ProductsError) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [TextWidget(text: state.message, color: textPrimary)],
          ),
        );
      }

      final products = _homeCubit.productList;

      if (products.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 300.r,
              child: Center(
                child: TextWidget(
                  text: 'No products found',
                  color: textPrimary,
                ),
              ),
            ),
          ],
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (final notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200) {
            _loadMoreProducts();
          }

          return false;
        },
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (final context, final index) {
            final product = products[index];

            return GestureDetector(
              onTap: () {
                navigate(enterPage: ProductDetailsScreen(product: product));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            product.thumbnail ?? '',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                                  final context,
                                  final error,
                                  final stackTrace,
                                ) => const Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: product.title ?? '',
                                maxLines: 2,
                                textOverflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.r,
                                color: textPrimary,
                              ),
                              4.verticalSpace,
                              Row(
                                children: [
                                  TextWidget(
                                    text:
                                        '\$${product.price?.toStringAsFixed(2) ?? '-'}',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.r,
                                    color: Colors.green,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.star,
                                    size: 12.r,
                                    color: Colors.amber,
                                  ),
                                  2.horizontalSpace,
                                  TextWidget(
                                    text: '${product.rating ?? 0}',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.r,
                                    color: textPrimary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Favorite Button
                    Positioned(
                      top: 8.r,
                      right: 8.r,
                      child: BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (final context, final favoriteState) {
                          final favoriteCubit = FavoriteCubit.get(context);
                          final isFav = favoriteCubit.isFavorite(product.id);

                          return GestureDetector(
                            onTap: () => favoriteCubit.toggleFavorite(product),
                            child: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                size: 18.r,
                                color: isFav ? AppColors.primary : Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );

  Future<void> _loadMoreProducts() async {
    final currentLength = _homeCubit.allProducts.length;

    if (_homeCubit.totalProducts > 0 &&
        currentLength >= _homeCubit.totalProducts) {
      return;
    }

    await _homeCubit.getProductList(offset: currentLength);
  }

  Widget _buildProductShimmer(final BuildContext context) => GridView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(12),
    itemCount: 6,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.62,
    ),
    itemBuilder: (final context, final index) =>
        _buildProductShimmerCard(context),
  );

  Widget _buildProductShimmerCard(final BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;
    final cardBg = isDark ? AppColors.darkCardBackground : Colors.white;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(width: double.infinity, color: cardBg),
            ),

            Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14.r,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),

                  6.verticalSpace,

                  Container(
                    height: 14.r,
                    width: 80.r,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),

                  10.verticalSpace,

                  Row(
                    children: [
                      Container(
                        height: 12.r,
                        width: 55.r,
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        height: 12.r,
                        width: 35.r,
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
