import 'package:flutter/material.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../config/resources/app_values.dart';
import '../../../../../utils/ui_components.dart';

class VisitorOwnerWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final bool isRightSide;
  final VoidCallback onTap;

  const VisitorOwnerWidget(
      {super.key, required this.title, required this.subTitle, required this.image, required this.onTap, this.isRightSide = false});

  @override
  Widget build(BuildContext context) {
    final isTablet = AppValues.screenWidth > 600;
    if (isTablet) {
      return isRightSide
          ? UIComponent.customInkWellWidget(
              onTap: onTap,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: AppValues.screenWidth / 4.0),
                    child: Container(
                      height: AppValues.screenWidth / 2.32,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      ),
                      padding: EdgeInsetsDirectional.only(start: 14, end: AppValues.screenWidth / 2.0),
                    ),
                  ),
                  PositionedDirectional(
                    top: 0,
                    end: AppValues.screenWidth / 1.4,
                    bottom: 0,
                    start: 50,
                    child: Container(
                      // color: Colors.pink,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MediaQuery(
                            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                            child: Text(
                              title,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.white),
                            ),
                          ),
                          8.0.verticalSpace,
                          Text(
                            subTitle,
                            textAlign: TextAlign.start,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 0,
                    bottom: 0,
                    end: 0,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 26.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                          width: AppValues.screenWidth / 2.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : UIComponent.customInkWellWidget(
              onTap: onTap,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: AppValues.screenWidth / 4.0),
                    child: Container(
                      height: AppValues.screenWidth / 2.32,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      ),
                      padding: EdgeInsetsDirectional.only(
                        start: AppValues.screenWidth / 2.3,
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 0,
                    start: AppValues.screenWidth / 1.8,
                    bottom: 0,
                    child: Container(
                      // color: Colors.pink,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MediaQuery(
                            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                            child: Text(
                              title,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.white),
                            ),
                          ),
                          8.0.verticalSpace,
                          Text(
                            subTitle,
                            textAlign: TextAlign.start,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: 0,
                    top: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 26.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                          width: AppValues.screenWidth / 2.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
    } else {
      return isRightSide
          ? UIComponent.customInkWellWidget(
              onTap: onTap,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: AppValues.screenWidth / 3.4),
                    child: Container(
                      height: AppValues.screenWidth / 2.32,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      ),
                      padding: EdgeInsetsDirectional.only(start: 14, end: AppValues.screenWidth / 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MediaQuery(
                            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                            child: Text(
                              title,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.white),
                            ),
                          ),
                          8.0.verticalSpace,
                          Text(
                            subTitle,
                            textAlign: TextAlign.start,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 0,
                    bottom: 0,
                    end: 0,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                          width: AppValues.screenWidth / 2.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : UIComponent.customInkWellWidget(
              onTap: onTap,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: AppValues.screenWidth / 4.0),
                    child: Container(
                      height: AppValues.screenWidth / 2.32,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      ),
                      padding: EdgeInsetsDirectional.only(
                        start: AppValues.screenWidth / 3.4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MediaQuery(
                            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                            child: Text(
                              title,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.white),
                            ),
                          ),
                          8.0.verticalSpace,
                          Text(
                            subTitle,
                            textAlign: TextAlign.start,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: 0,
                    top: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                          width: AppValues.screenWidth / 2.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
    }
  }
}
