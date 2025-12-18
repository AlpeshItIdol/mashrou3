import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/ui/screens/app_prefereces/cubit/app_preferences_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/model/review_list_response_model.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../utils/ui_components.dart';

class ReviewItemWidget extends StatelessWidget {
  const ReviewItemWidget({super.key, required this.data});

  final ReviewData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CircleAvatar(
                        radius: 20,
                        child: UIComponent.cachedNetworkImageWidget(
                          imageUrl: data.companyLogo,
                          fit: BoxFit.cover,
                        ))
                    .showIf(data.companyLogo != null &&
                        data.companyLogo!.isNotEmpty),
              ),
              // Circle Avatar
              CircleAvatar(
                backgroundColor: AppColors.colorPrimary,
                radius: 20,
                child: Text(
                  data.firstName?[0] ?? '',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white.adaptiveColor(context,
                          lightModeColor: AppColors.white,
                          darkModeColor: AppColors.goldA1)),
                ),
              ).showIf(data.companyLogo == null || data.companyLogo!.isEmpty),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      "${data.firstName ?? ""} ${data.lastName ?? ""}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.black14.adaptiveColor(context,
                              lightModeColor: AppColors.black14,
                              darkModeColor: AppColors.grey77)),
                    ),
                    const SizedBox(height: 4),
                    // Rating and Date
                    Row(
                      children: [
                        SVGAssets.starFilledIcon.toSvg(context: context),
                        const SizedBox(width: 4),
                        Text(
                          data.rating.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: AppColors.black14.adaptiveColor(
                                      context,
                                      lightModeColor: AppColors.black14,
                                      darkModeColor: AppColors.grey77)),
                        ),
                        const SizedBox(width: 8),
                        // Divider
                        Text(
                          "|",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        // Published Date
                        BlocConsumer<AppPreferencesCubit, AppPreferencesState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            final cubit = context.watch<AppPreferencesCubit>();
                            final isArabic = cubit.isArabicSelected;
                            return Text(
                              Utils.getTimeDifferenceWithContext(
                                      context,
                                      data.createdAt != null
                                          ? DateTime.tryParse(
                                                  data.createdAt!) ??
                                              DateTime.now()
                                          : DateTime.now())
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: AppColors.black14.adaptiveColor(
                                          context,
                                          lightModeColor: AppColors.black14,
                                          darkModeColor: AppColors.grey77)),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Review Text
          (data.isActive ?? false)
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16.0,top: 16),
                  child: Text(
                    data.comment ?? "",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black3D.adaptiveColor(context,
                            lightModeColor: AppColors.black3D,
                            darkModeColor: AppColors.greyB0)),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
