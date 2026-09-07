import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/models/product_list_model.dart';
import 'package:jobish_task/routes/navigation_routes.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/ui/favorite/cubit/favorite_cubit.dart';
import 'package:jobish_task/ui/favorite/states/favorite_state.dart';
import 'package:jobish_task/ui/product_details/product_details_screen.dart';
import 'package:jobish_task/widgets/base_stateful_widget_state.dart';
import 'package:jobish_task/widgets/common_appbar.dart';
import 'package:jobish_task/widgets/text_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends BaseStatefulWidgetState<FavoriteScreen> {
  @override
  bool useSafeArea = true, extendBodyBehindAppBar = false;

  @override
  PreferredSizeWidget? buildAppBar(final BuildContext context) =>
      const CommonAppBar(title: 'Favorites', shouldShowBackButton: false);

  @override
  Widget buildBody(final BuildContext context) =>
      BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (final context, final state) {
          final favoriteCubit = FavoriteCubit.get(context);
          final favorites = favoriteCubit.favoriteProducts;

          if (favorites.isEmpty) {
            return _buildEmptyFavoritesView(context);
          }

          return _buildFavoritesGrid(context, favorites);
        },
      );

  Widget _buildEmptyFavoritesView(final BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 60.r,
              color: AppColors.primary,
            ),
          ),
          16.verticalSpace,
          TextWidget(
            text: 'No Favorites Yet',
            fontSize: 18.r,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
          8.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.r),
            child: TextWidget(
              text: 'Tap the heart icon on any product to save it here.',
              textAlign: TextAlign.center,
              fontSize: 13.r,
              color: textColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid(
    final BuildContext context,
    final List<Products> favorites,
  ) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textPrimary = theme.colorScheme.onSurface;
    final favoriteCubit = FavoriteCubit.get(context);

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 20.r),
      itemCount: favorites.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (final context, final index) {
        final product = favorites[index];

        return GestureDetector(
          onTap: () {
            navigate(enterPage: ProductDetailsScreen(product: product));
          },
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12.r),
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
                      padding: EdgeInsets.all(8.r),
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

                // Favorite Heart Button
                Positioned(
                  top: 8.r,
                  right: 8.r,
                  child: GestureDetector(
                    onTap: () => favoriteCubit.toggleFavorite(product),
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 18.r,
                        color: AppColors.primary,
                      ),
                    ),
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
