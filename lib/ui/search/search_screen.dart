import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/models/product_list_model.dart';
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends BaseStatefulWidgetState<SearchScreen> {
  late final HomeCubit _homeCubit = HomeCubit.get(context);

  bool hasSearched = false;

  @override
  bool useSafeArea = true, extendBodyBehindAppBar = false;

  @override
  PreferredSizeWidget? buildAppBar(final BuildContext context) => CommonAppBar(
    title: ' Search Products',
    shouldShowBackButton: false,
    prefixWidget: Padding(
      padding: EdgeInsets.only(right: 20.r),
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.notifications_none_rounded,
          size: 25.r,
        ),
      ),
    ),
  );

  @override
  void initialize() {
    super.initialize();

    _homeCubit.clearControllers();
  }

  @override
  void dispose() {
    _homeCubit.clearControllers();
    super.dispose();
  }

  void _onSearchChanged(final String value) {
    final query = value.trim();

    if (query.isEmpty) {
      setState(() {
        hasSearched = false;
      });

      _homeCubit.searchProducts('');

      return;
    }

    setState(() {
      hasSearched = true;
    });

    _homeCubit.searchProducts(query);
  }

  @override
  Widget buildBody(final BuildContext context) => Column(
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(20.r, 8.r, 20.r, 12.r),
        child: TextFieldWidget(
          hint: 'Search products...',
          maxLength: 40,
          controller: _homeCubit.searchController,
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.search,
          prefixIconWidget: Icon(
            Icons.search,
            size: 23.r,
            color: AppColors.primary,
          ),
          onChanged: _onSearchChanged,
        ),
      ),

      Expanded(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (final context, final state) {
            if (!hasSearched) {
              return _buildSearchInitialView(context);
            }

            if (state is ProductsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final products = _homeCubit.productList;

            if (products.isEmpty) {
              return _buildNoResultView(context);
            }

            return _buildProductGrid(context, products);
          },
        ),
      ),
    ],
  );

  Widget _buildSearchInitialView(final BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search,
            size: 55.r,
            color: textColor.withValues(alpha: 0.4),
          ),
          12.verticalSpace,
          TextWidget(
            text: 'Search for products',
            fontSize: 17.r,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          5.verticalSpace,
          TextWidget(
            text: 'Find products by name or category',
            fontSize: 13.r,
            color: textColor.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultView(final BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 55.r,
            color: textColor.withValues(alpha: 0.4),
          ),
          12.verticalSpace,
          TextWidget(
            text: 'No products found',
            fontSize: 17.r,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          5.verticalSpace,
          TextWidget(
            text: 'Try searching with another keyword',
            fontSize: 13.r,
            color: textColor.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(
    final BuildContext context,
    final List<Products> products,
  ) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textPrimary = theme.colorScheme.onSurface;

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(12.r, 4.r, 12.r, 20.r),
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
                            (final context, final error, final stackTrace) =>
                                const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                  ),
                                ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8),
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

                              Icon(Icons.star, size: 12.r, color: Colors.amber),

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
    );
  }
}
