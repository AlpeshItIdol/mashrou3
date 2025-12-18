import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../../../../../config/resources/app_assets.dart';
import '../../../../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../../../../utils/ui_components.dart';
import '../../../../../../../utils/app_localization.dart';
import '../../../../../../../utils/read_more_text.dart';
import '../../../../../../model/offers/my_offers_list_response_model.dart';
import '../cubit/add_my_offers_cubit.dart';

class AddMyOffersCard extends StatefulWidget {
  final String? name;
  final String? price;
  final String? description;
  final String? country;
  final String? city;
  final String? imageUrl;
  final OfferData? myOffersListData;

  const AddMyOffersCard({
    super.key,
    this.name,
    this.price,
    this.description,
    this.country,
    this.city,
    this.imageUrl,
    this.myOffersListData,
  });

  @override
  State<AddMyOffersCard> createState() => _AddMyOffersCardState();
}

class _AddMyOffersCardState extends State<AddMyOffersCard> {
  @override
  Widget build(BuildContext context) {
    AddMyOffersCubit cubit = context.read<AddMyOffersCubit>();
    return BlocConsumer<AddMyOffersCubit, AddMyOffersState>(
        listener: (context, state) {},
        builder: (context, state) {
          bool isSelected =
              cubit.offersIds.contains(widget.myOffersListData?.sId);
          return UIComponent.customInkWellWidget(
            onTap: () {
              cubit.toggleOfferSelection(
                  id: widget.myOffersListData!.sId.toString(),
                  isSelected: isSelected);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white.adaptiveColor(context,
                    lightModeColor: AppColors.white,
                    darkModeColor: AppColors.black2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.greyE9.adaptiveColor(
                    context,
                    lightModeColor: AppColors.greyE9,
                    darkModeColor: AppColors.black2E,
                  ),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        padding: const EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color:
                                                AppColors.greyE9.adaptiveColor(
                                              context,
                                              lightModeColor: AppColors.greyE9,
                                              darkModeColor: AppColors.greyB0,
                                            ),
                                            width: 1,
                                          ), // Round
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: UIComponent
                                              .cachedNetworkImageWidget(
                                                  imageUrl: widget.imageUrl),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // 5.verticalSpace,
                                ],
                              ),
                            ),
                            8.horizontalSpace,
                            Flexible(
                              flex: 4,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.name ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context)
                                                      .highlightColor),
                                        ),
                                        8.verticalSpace,
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 18.0),
                                          child: Text(
                                            widget.price ?? "-",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  isSelected
                                      ? SVGAssets.checkboxEnableIcon.toSvg(
                                          height: 18,
                                          width: 18,
                                          context: context)
                                      : SVGAssets.checkboxDisableIcon.toSvg(
                                          height: 18,
                                          width: 18,
                                          context: context),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 2,
                            end: 2,
                          ),
                          child: ReadMoreText(
                            widget.description ?? "",
                            trimMode: TrimMode.Line,
                            trimLines: 3,
                            locale: Locale(cubit.selectedLanguage),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey8A.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.grey8A,
                                        darkModeColor: AppColors.greyB0)),
                            trimCollapsedText:
                                '\n${appStrings(context).readMore}',
                            trimExpandedText:
                                '\n${appStrings(context).readLess}',
                            lessStyle: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.colorPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.colorPrimary)),
                            moreStyle: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.colorPrimary.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.colorPrimary,
                                        darkModeColor: AppColors.colorPrimary)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
