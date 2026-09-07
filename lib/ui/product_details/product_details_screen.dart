import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/models/product_list_model.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/ui/favorite/cubit/favorite_cubit.dart';
import 'package:jobish_task/ui/favorite/states/favorite_state.dart';
import 'package:jobish_task/widgets/base_stateful_widget_state.dart';
import 'package:jobish_task/widgets/common_appbar.dart';
import 'package:jobish_task/widgets/text_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({required this.product, super.key});

  final Products product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends BaseStatefulWidgetState<ProductDetailsScreen> {
  @override
  PreferredSizeWidget? buildAppBar(final BuildContext context) => CommonAppBar(
        title: widget.product.title ?? '',
        prefixWidget: Padding(
          padding: EdgeInsets.only(right: 16.r),
          child: BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (final context, final favoriteState) {
              final favoriteCubit = FavoriteCubit.get(context);
              final isFav = favoriteCubit.isFavorite(widget.product.id);

              return IconButton(
                onPressed: () => favoriteCubit.toggleFavorite(widget.product),
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav
                      ? AppColors.primary
                      : Theme.of(context).colorScheme.onSurface,
                  size: 24.r,
                ),
              );
            },
          ),
        ),
      );

  @override
  bool useSafeArea = true, extendBodyBehindAppBar = false;

  @override
  Widget buildBody(final BuildContext context) {
    final theme = Theme.of(context);
    final textPrimary = theme.colorScheme.onSurface;
    final textSecondary = textPrimary.withValues(alpha: 0.7);
    final reviewCardBg = theme.cardColor;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageCarousel(),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: widget.product.title ?? '',
                  fontWeight: FontWeight.w700,
                  fontSize: 20.r,
                  color: textPrimary,
                ),
                6.verticalSpace,
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16.r),
                    4.horizontalSpace,
                    TextWidget(
                      text: '${widget.product.rating ?? 0}',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.r,
                      color: textPrimary,
                    ),
                    12.horizontalSpace,
                    if (widget.product.brand != null)
                      TextWidget(
                        text: widget.product.brand ?? '',
                        fontSize: 13.r,
                        color: textSecondary,
                      ),
                  ],
                ),
                12.verticalSpace,
                Row(
                  children: [
                    TextWidget(
                      text:
                          '\$${widget.product.price?.toStringAsFixed(2) ?? '-'}',
                      fontWeight: FontWeight.w700,
                      fontSize: 20.r,
                      color: Colors.green,
                    ),
                    8.horizontalSpace,
                    if (widget.product.discountPercentage != null)
                      TextWidget(
                        text:
                            '${widget.product.discountPercentage!.toStringAsFixed(0)}% off',
                        fontWeight: FontWeight.w500,
                        fontSize: 13.r,
                        color: Colors.redAccent,
                      ),
                  ],
                ),
                12.verticalSpace,
                TextWidget(
                  text:
                      'Stock: ${widget.product.stock ?? 0} • '
                      '${widget.product.availabilityStatus ?? ''}',
                  fontWeight: FontWeight.w500,
                  fontSize: 13.r,
                  color: textSecondary,
                ),
                16.verticalSpace,
                TextWidget(
                  text: 'Description',
                  fontWeight: FontWeight.w700,
                  fontSize: 15.r,
                  color: textPrimary,
                ),
                6.verticalSpace,
                TextWidget(
                  text: widget.product.description ?? '',
                  fontSize: 13.r,
                  color: textSecondary,
                ),
                16.verticalSpace,
                if (widget.product.warrantyInformation != null ||
                    widget.product.shippingInformation != null ||
                    widget.product.returnPolicy != null) ...[
                  TextWidget(
                    text: 'Additional Info',
                    fontWeight: FontWeight.w700,
                    fontSize: 15.r,
                    color: textPrimary,
                  ),
                  8.verticalSpace,
                  if (widget.product.warrantyInformation != null)
                    TextWidget(
                      text: 'Warranty: ${widget.product.warrantyInformation}',
                      fontSize: 12.r,
                      color: textSecondary,
                    ),
                  if (widget.product.shippingInformation != null)
                    TextWidget(
                      text: 'Shipping: ${widget.product.shippingInformation}',
                      fontSize: 12.r,
                      color: textSecondary,
                    ),
                  if (widget.product.returnPolicy != null)
                    TextWidget(
                      text: 'Return Policy: ${widget.product.returnPolicy}',
                      fontSize: 12.r,
                      color: textSecondary,
                    ),
                  16.verticalSpace,
                ],
                if (widget.product.reviews != null &&
                    widget.product.reviews!.isNotEmpty) ...[
                  TextWidget(
                    text: 'Reviews',
                    fontWeight: FontWeight.w700,
                    fontSize: 15.r,
                    color: textPrimary,
                  ),
                  8.verticalSpace,
                  ...widget.product.reviews!.map(
                    (final review) => Container(
                      margin: EdgeInsets.only(bottom: 10.r),
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: reviewCardBg,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextWidget(
                                text: review.reviewerName ?? '',
                                fontWeight: FontWeight.w600,
                                fontSize: 13.r,
                                color: textPrimary,
                              ),
                              const Spacer(),
                              Icon(Icons.star, size: 13.r, color: Colors.amber),
                              TextWidget(
                                text: '${review.rating ?? 0}',
                                fontWeight: FontWeight.w500,
                                fontSize: 12.r,
                                color: textPrimary,
                              ),
                            ],
                          ),
                          4.verticalSpace,
                          TextWidget(
                            text: review.comment ?? '',
                            fontSize: 12.r,
                            color: textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    final images =
        (widget.product.images != null && widget.product.images!.isNotEmpty)
        ? widget.product.images!
        : [widget.product.thumbnail ?? ''];

    return SizedBox(
      height: 280.r,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (final context, final index) => Image.network(
          images[index],
          width: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (final context, final error, final stackTrace) =>
              const Icon(Icons.image_not_supported, size: 60),
        ),
      ),
    );
  }
}
