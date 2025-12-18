import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/screens/personal_information/component/info_row.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../config/resources/app_assets.dart';
import '../../../../config/resources/app_strings.dart';
import '../../../../config/resources/app_values.dart';
import '../../../../utils/read_more_text.dart';
import '../../../db/app_preferences.dart';
import '../../../db/session_tracker.dart';
import '../../../navigation/route_arguments.dart';
import '../../custom_widget/common_button.dart';
import '../../custom_widget/common_row_bottons.dart';
import '../../custom_widget/file_picker_widget/cubit/file_picker_cubit.dart';
import '../../custom_widget/toggle_widget/toggle_cubit.dart';
import 'cubit/personal_information_cubit.dart';

class PersonalInformationScreen extends StatefulWidget with AppBarMixin {
  PersonalInformationScreen({
    super.key,
  });

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen>
    with AppBarMixin {
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<PersonalInformationCubit>().getData(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        requireLeading: true,
        title: appStrings(context).lblPersonalInformation,
      ),
      body: FutureBuilder(
        future: _initializeCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.colorPrimary,
            ));
          }
          return _buildBlocConsumer;
        },
      ),
    );
  }

  Future<void> _initializeCategories() async {
    await Future.delayed(const Duration(milliseconds: 00));
  }

  /// Build bloc consumer widget.
  ///

  Widget get _buildBlocConsumer {
    return BlocProvider(
        create: (context) {
          return ToggleCubit(AppConstants.propertyCategory);
        },
        child: BlocConsumer<PersonalInformationCubit, PersonalInformationState>(
          listener: buildBlocListener,
          builder: (context, state) {
            PersonalInformationCubit cubit =
                context.read<PersonalInformationCubit>();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    BlocProvider(
                      create: (BuildContext context) => FilePickerCubit(),
                      child: BlocConsumer<FilePickerCubit, FilePickerState>(
                          listener: (context, state) async {
                        if (state is FilePickerDataLoading) {}

                        if (state is OnlyImageFilesPickedState) {
                          final imageList =
                              state.files.map((e) => e.path).toList();
                          cubit.profilePictureList.clear();
                          cubit.profilePictureList.addAll(imageList);
                          await cubit.updateImageData(context);
                        }
                      }, builder: (context, state) {
                        return UIComponent
                            .buildUserProfileWidgetForPersonalInformation(
                          isGuest: false,
                          isVisitor: cubit.selectedRole == AppStrings.visitor
                              ? true
                              : false,
                          isUploadIconNeeded: true,
                          showUserName: false,
                          context: context,
                          userName:
                              "${cubit.userSavedData?.users?.firstName ?? ""} ${cubit.userSavedData?.users?.lastName ?? ""}"
                                  .trim(),
                          userRoleType: cubit.selectedRole,
                          imageStr: cubit.profilePictureList.first ?? "",
                          onAddImageTap: () async {
                            await Utils.getStorageReadPermission();

                            if (!context.mounted) return;
                            context.read<FilePickerCubit>().pickFiles(
                                cubit.profilePictureList,
                                true,
                                "",
                                "",
                                context);
                          },
                        );
                      }),
                    ),
                    12.verticalSpace,
                    Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left text showing found estates
                            Text(
                              appStrings(context).lblCertificates,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w700),
                            ),

                            UIComponent.customInkWellWidget(
                              onTap: () {
                                context.pushNamed(
                                    Routes.kAddEditCertificatesScreen,
                                    extra: [],
                                    pathParameters: {
                                      RouteArguments.isForPortfolio: "false",
                                      RouteArguments.isForEdit: "false",
                                    });
                              },
                              child: Row(
                                children: [
                                  SVGAssets.plusCircleIcon.toSvg(
                                      context: context,
                                      color: AppColors.colorPrimary,
                                      height: 20,
                                      width: 20),
                                  6.horizontalSpace,
                                  Text(
                                    appStrings(context).textAdd,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.colorPrimary),
                                  ),
                                ],
                              ),
                            ).showIf(cubit.httpCertificatesList.isEmpty),
                          ],
                        ),
                        20.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.greyE8.adaptiveColor(
                                context,
                                lightModeColor: AppColors.greyE8,
                                darkModeColor: AppColors.black2E,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: cubit.certificatesList.isEmpty
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  UIComponent.noData(context),
                                ],
                              ).showIf(cubit.certificatesList.isEmpty),
                              // Padding(
                              //   padding: EdgeInsetsDirectional.only(
                              //       start: 12.0,
                              //       end: 12.0,
                              //       bottom: cubit.certificatesList.length < 6
                              //           ? 5
                              //           : 12.0,
                              //       top: 12.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Expanded(
                              //         child: GridView.builder(
                              //           physics:
                              //               const NeverScrollableScrollPhysics(),
                              //           padding: EdgeInsets.zero,
                              //           gridDelegate: /*widget.isImageTypeOnly
                              //                 ? const SliverGridDelegateWithFixedCrossAxisCount(
                              //               crossAxisCount: 2,
                              //               crossAxisSpacing: 20,
                              //               mainAxisSpacing: 20,
                              //             )
                              //                 : */
                              //               const SliverGridDelegateWithFixedCrossAxisCount(
                              //                   crossAxisCount: 3,
                              //                   crossAxisSpacing: 12,
                              //                   mainAxisSpacing: 9,
                              //                   childAspectRatio: 1),
                              //           itemCount:
                              //               cubit.certificatesList.length > 6
                              //                   ? 6
                              //                   : cubit.certificatesList.length,
                              //           // Limit to 6 items
                              //           shrinkWrap: true,
                              //           itemBuilder: (context, index) {
                              //             var attachmentList =
                              //                 cubit.certificatesList[index];
                              //
                              //             final isLastItem = index == cubit.certificatesList.length - 1;
                              //
                              //             return Stack(
                              //               alignment: Alignment.center,
                              //               // Align children at the center
                              //               children: [
                              //                 ClipRRect(
                              //                   borderRadius:
                              //                       BorderRadius.circular(12),
                              //                   // Apply circular radius
                              //                   child: Stack(
                              //                     children: [
                              //                       buildImageOrDocumentWidget(
                              //                         fileItem: attachmentList,
                              //                         isImageAllow: false,
                              //                         itemIndex: index,
                              //                         fileName: (attachmentList
                              //                                     as String)
                              //                                 .isNotEmpty
                              //                             ? cubit
                              //                                 .certificatesList[
                              //                                     index]
                              //                                 .split('/')
                              //                                 .last
                              //                             : "",
                              //                         fileExtension:
                              //                             (attachmentList)
                              //                                     .isNotEmpty
                              //                                 ? cubit
                              //                                     .certificatesList[
                              //                                         index]
                              //                                     .split('.')
                              //                                     .last
                              //                                 : "",
                              //                       ),
                              //                       if (cubit.certificatesList
                              //                                   .length >
                              //                               5 &&
                              //                           isLastItem)
                              //                         Container(
                              //                           decoration:
                              //                               BoxDecoration(
                              //                             color: AppColors
                              //                                 .black14
                              //                                 .withOpacity(0.7),
                              //                             // Dark overlay
                              //                             borderRadius:
                              //                                 BorderRadius.circular(
                              //                                     12), // Match border radius
                              //                           ),
                              //                         ),
                              //                     ],
                              //                   ),
                              //                 ),
                              //
                              //                 if (cubit.certificatesList.length > 5 && isLastItem)
                              //                   Text(
                              //                     appStrings(context)
                              //                         .lblViewAll,
                              //                     style: Theme.of(context)
                              //                         .textTheme
                              //                         .labelSmall
                              //                         ?.copyWith(
                              //                             fontWeight:
                              //                                 FontWeight.w500,
                              //                             color:
                              //                                 AppColors.white),
                              //                   ),
                              //                 InkWell(
                              //                   onTap: () {
                              //                     if (isLastItem) {
                              //                       // Handle "View All" tap
                              //                       context.pushNamed(
                              //                           Routes
                              //                               .kViewAllCertificatesScreen,
                              //                           extra: cubit
                              //                               .certificatesList,
                              //                           pathParameters: {
                              //                             RouteArguments
                              //                                     .isForPortfolio:
                              //                                 "false",
                              //                           });
                              //                     } else {
                              //                       // OpenFilex.open(cubit.certificatesList[index]);
                              //                     }
                              //                   },
                              //                   child: const SizedBox(
                              //                     width: double.maxFinite,
                              //                     height: double.maxFinite,
                              //                   ),
                              //                 ).showIf(cubit
                              //                         .certificatesList.length >
                              //                     5),
                              //
                              //                 // if (cubit.certificatesList
                              //                 //             .length >
                              //                 //         5 &&
                              //                 //     isLastItem)
                              //                 //   Text(
                              //                 //     appStrings(context)
                              //                 //         .lblViewAll,
                              //                 //     style: Theme.of(context)
                              //                 //         .textTheme
                              //                 //         .labelSmall
                              //                 //         ?.copyWith(
                              //                 //             fontWeight:
                              //                 //                 FontWeight.w500,
                              //                 //             color:
                              //                 //                 AppColors.white),
                              //                 //   ),
                              //                 // InkWell(
                              //                 //   onTap: () {
                              //                 //     if (isLastItem) {
                              //                 //       // Handle "View All" tap
                              //                 //       context.pushNamed(
                              //                 //           Routes
                              //                 //               .kViewAllCertificatesScreen,
                              //                 //           extra: cubit
                              //                 //               .certificatesList,
                              //                 //           pathParameters: {
                              //                 //             RouteArguments
                              //                 //                     .isForPortfolio:
                              //                 //                 "false",
                              //                 //           });
                              //                 //     } else {
                              //                 //       // OpenFilex.open(cubit.certificatesList[index]);
                              //                 //     }
                              //                 //   },
                              //                 //   child: const SizedBox(
                              //                 //     width: double.maxFinite,
                              //                 //     height: double.maxFinite,
                              //                 //   ),
                              //                 // ).showIf(cubit
                              //                 //         .certificatesList.length >
                              //                 //     5),
                              //               ],
                              //             );
                              //           },
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ).showIf(cubit.certificatesList.isNotEmpty),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 12.0,
                                    end: 12.0,
                                    bottom: cubit.certificatesList.length < 6
                                        ? 5
                                        : 12.0,
                                    top: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 12,
                                                mainAxisSpacing: 9,
                                                childAspectRatio: 1),
                                        itemCount:
                                            cubit.certificatesList.length > 6
                                                ? 6
                                                : cubit.certificatesList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          var attachmentList =
                                              cubit.certificatesList[index];
                                          // final isLastItem = index == cubit.certificatesList.length - 1;
                                          final isLastItem = index ==
                                              (cubit.certificatesList.length > 6
                                                  ? 5
                                                  : cubit.certificatesList
                                                          .length -
                                                      1);

                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Stack(
                                                  children: [
                                                    buildImageOrDocumentWidget(
                                                      fileItem: attachmentList,
                                                      isImageAllow: false,
                                                      itemIndex: index,
                                                      fileName: (attachmentList
                                                                  as String)
                                                              .isNotEmpty
                                                          ? cubit
                                                              .certificatesList[
                                                                  index]
                                                              .split('/')
                                                              .last
                                                          : "",
                                                      fileExtension:
                                                          (attachmentList)
                                                                  .isNotEmpty
                                                              ? cubit
                                                                  .certificatesList[
                                                                      index]
                                                                  .split('.')
                                                                  .last
                                                              : "",
                                                    ),
                                                    if (cubit.certificatesList
                                                                .length >
                                                            6 &&
                                                        isLastItem)
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .black14
                                                              .withOpacity(0.7),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              if (cubit.certificatesList
                                                          .length >
                                                      6 &&
                                                  isLastItem)
                                                Text(
                                                  appStrings(context)
                                                      .lblViewAll,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.white,
                                                      ),
                                                ),
                                              InkWell(
                                                onTap: () {
                                                  if (isLastItem) {
                                                    context.pushNamed(
                                                      Routes
                                                          .kViewAllCertificatesScreen,
                                                      extra: cubit
                                                          .certificatesList,
                                                      pathParameters: {
                                                        RouteArguments
                                                                .isForPortfolio:
                                                            "false",
                                                        RouteArguments
                                                                .isForPropertyDetail:
                                                            "false",
                                                      },
                                                    );
                                                  } else {
                                                    // OpenFilex.open(cubit.certificatesList[index]);
                                                  }
                                                },
                                                child: const SizedBox(
                                                  width: double.maxFinite,
                                                  height: double.maxFinite,
                                                ),
                                              ).showIf(cubit
                                                      .certificatesList.length >
                                                  6),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ).showIf(cubit.certificatesList.isNotEmpty),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12.0, end: 12.0),
                                    child: Divider(
                                        color: AppColors.greyE9.adaptiveColor(
                                            context,
                                            lightModeColor: AppColors.greyE9,
                                            darkModeColor: AppColors.black2E)),
                                  ),
                                  1.verticalSpace,
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12.0, end: 12.0, bottom: 12.0),
                                    child: CommonButton(
                                      onTap: () async {
                                        context.pushNamed(
                                            Routes.kAddEditCertificatesScreen,
                                            extra: cubit.certificatesList,
                                            pathParameters: {
                                              RouteArguments.isForPortfolio:
                                                  "false",
                                              RouteArguments.isForEdit: "true",
                                            });
                                      },
                                      buttonBgColor: AppColors.black3D,
                                      buttonTextColor: AppColors.white,
                                      isGradientColor: false,
                                      width: AppValues.screenWidth / 3.4,
                                      title: appStrings(context).lblEdit,
                                    ),
                                  ),
                                ],
                              ).showIf(cubit.certificatesList.isNotEmpty &&
                                  cubit.certificatesList.length <= 6),
                            ],
                          ),
                        ),
                        20.verticalSpace,
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left text showing found estates
                                Text(
                                  appStrings(context).lblPortfolio,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700),
                                ),

                                UIComponent.customInkWellWidget(
                                  onTap: () {
                                    context.pushNamed(
                                        Routes.kAddEditCertificatesScreen,
                                        extra: [],
                                        pathParameters: {
                                          RouteArguments.isForPortfolio: "true",
                                          RouteArguments.isForEdit: "false",
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      SVGAssets.plusCircleIcon.toSvg(
                                          context: context,
                                          color: AppColors.colorPrimary,
                                          height: 20,
                                          width: 20),
                                      6.horizontalSpace,
                                      Text(
                                        appStrings(context).textAdd,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.colorPrimary),
                                      ),
                                    ],
                                  ),
                                ).showIf(cubit.httpPortfolioList.isEmpty),
                              ],
                            ),
                            20.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.greyE8.adaptiveColor(
                                    context,
                                    lightModeColor: AppColors.greyE8,
                                    darkModeColor: AppColors.black2E,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: cubit.portfolioList.isEmpty
                                    ? CrossAxisAlignment.center
                                    : CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      UIComponent.noData(context),
                                    ],
                                  ).showIf(cubit.portfolioList.isEmpty),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 12.0,
                                        end: 12.0,
                                        bottom: cubit.portfolioList.length < 6
                                            ? 5
                                            : 12.0,
                                        top: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            gridDelegate: /*widget.isImageTypeOnly
                                              ? const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20,
                                          )
                                              : */
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 12,
                                                    mainAxisSpacing: 9,
                                                    childAspectRatio: 1),
                                            itemCount:
                                                cubit.portfolioList.length > 6
                                                    ? 6
                                                    : cubit
                                                        .portfolioList.length,
                                            // Limit to 6 items
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              var attachmentList =
                                                  cubit.portfolioList[index];

                                              // final isLastItem = index ==
                                              //     cubit.portfolioList.length -
                                              //         1;
                                              final isLastItem = index ==
                                                  (cubit.portfolioList.length >
                                                          6
                                                      ? 5
                                                      : cubit.portfolioList
                                                              .length -
                                                          1);

                                              return Stack(
                                                alignment: Alignment.center,
                                                // Align children at the center
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    // Apply circular radius
                                                    child: Stack(
                                                      children: [
                                                        buildImageOrDocumentWidget(
                                                          fileItem:
                                                              attachmentList,
                                                          isImageAllow: false,
                                                          itemIndex: index,
                                                          fileName: (attachmentList
                                                                      as String)
                                                                  .isNotEmpty
                                                              ? cubit
                                                                  .portfolioList[
                                                                      index]
                                                                  .split('/')
                                                                  .last
                                                              : "",
                                                          fileExtension:
                                                              (attachmentList)
                                                                      .isNotEmpty
                                                                  ? cubit
                                                                      .portfolioList[
                                                                          index]
                                                                      .split(
                                                                          '.')
                                                                      .last
                                                                  : "",
                                                        ),
                                                        if (cubit.portfolioList
                                                                    .length >
                                                                5 &&
                                                            isLastItem)
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .black14
                                                                  .withOpacity(
                                                                      0.7),
                                                              // Dark overlay
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12), // Match border radius
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (cubit.portfolioList
                                                              .length >
                                                          5 &&
                                                      isLastItem)
                                                    Text(
                                                      appStrings(context)
                                                          .lblViewAll,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .white),
                                                    ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (isLastItem) {
                                                        // Handle "View All" tap
                                                        context.pushNamed(
                                                            Routes
                                                                .kViewAllCertificatesScreen,
                                                            extra: cubit
                                                                .portfolioList,
                                                            pathParameters: {
                                                              RouteArguments
                                                                      .isForPortfolio:
                                                                  "true",
                                                              RouteArguments
                                                                      .isForPropertyDetail:
                                                                  "false",
                                                            });
                                                      } else {
                                                        // OpenFilex.open(cubit.portfolioList[index]);
                                                      }
                                                    },
                                                    child: const SizedBox(
                                                      width: double.maxFinite,
                                                      height: double.maxFinite,
                                                    ),
                                                  ).showIf(cubit.portfolioList
                                                          .length >
                                                      5),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).showIf(cubit.portfolioList.isNotEmpty),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0, end: 12.0),
                                        child: Divider(
                                            color: AppColors.greyE9
                                                .adaptiveColor(context,
                                                    lightModeColor:
                                                        AppColors.greyE9,
                                                    darkModeColor:
                                                        AppColors.black2E)),
                                      ),
                                      1.verticalSpace,
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0,
                                                end: 12.0,
                                                bottom: 12.0),
                                        child: CommonButton(
                                          onTap: () async {
                                            context.pushNamed(
                                                Routes
                                                    .kAddEditCertificatesScreen,
                                                extra: cubit.portfolioList,
                                                pathParameters: {
                                                  RouteArguments.isForPortfolio:
                                                      "true",
                                                  RouteArguments.isForEdit:
                                                      "true",
                                                });
                                          },
                                          buttonBgColor: AppColors.black3D,
                                          buttonTextColor: AppColors.white,
                                          isGradientColor: false,
                                          width: AppValues.screenWidth / 3.4,
                                          title: appStrings(context).lblEdit,
                                        ),
                                      ),
                                    ],
                                  ).showIf(cubit.portfolioList.isNotEmpty &&
                                      cubit.portfolioList.length <= 6),
                                ],
                              ),
                            ),
                            20.verticalSpace,
                          ],
                        ).showIf(cubit.selectedRole == AppStrings.vendor),
                      ],
                    ).showIf(cubit.selectedRole != AppStrings.visitor),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left text showing found estates
                        Text(
                          appStrings(context).lblPersonalInformation,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700),
                        ),

                        UIComponent.customInkWellWidget(
                          onTap: () {
                            context.pushNamed(Routes.kEditProfileScreen);
                          },
                          child: Row(
                            children: [
                              SVGAssets.editIcon.toSvg(
                                  context: context,
                                  color: AppColors.colorPrimary,
                                  height: 20,
                                  width: 20),
                              6.horizontalSpace,
                              Text(
                                appStrings(context).lblEdit,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.colorPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
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
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              // Use Expanded to avoid overflow
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InfoRow(
                                    label: appStrings(context).lblFirstName,
                                    value:
                                        cubit.userSavedData?.users?.firstName ??
                                            "-",
                                  ).showIf(cubit.userSavedData?.users
                                              ?.firstName !=
                                          null &&
                                      cubit.userSavedData?.users?.firstName !=
                                          ""),
                                  InfoRow(
                                    label: appStrings(context).lblLastName,
                                    value:
                                        cubit.userSavedData?.users?.lastName ??
                                            "-",
                                  ).showIf(cubit
                                              .userSavedData?.users?.lastName !=
                                          null &&
                                      cubit.userSavedData?.users?.lastName !=
                                          ""),
                                  InfoRow(
                                    label: appStrings(context).lblMobileNumber,
                                    value:
                                        "${cubit.userSavedData?.users?.contactNumber != null ? (cubit.userSavedData?.users?.phoneCode?.startsWith("+") ?? false ? cubit.userSavedData?.users?.phoneCode : "+${cubit.userSavedData?.users?.phoneCode} ") : ""}${cubit.userSavedData?.users?.contactNumber ?? "-"}" ??
                                            "-",
                                  ),
                                  InfoRow(
                                    label: appStrings(context)
                                        .lblAlternateMobileNumber,
                                    value:
                                        "${cubit.userSavedData?.users?.alternativeContactNumbers?.phoneCode != null ? (cubit.userSavedData?.users?.alternativeContactNumbers?.phoneCode?.startsWith("+") ?? false ? cubit.userSavedData?.users?.alternativeContactNumbers?.phoneCode : "+${cubit.userSavedData?.users?.alternativeContactNumbers?.phoneCode} ") : "-"}${cubit.userSavedData?.users?.alternativeContactNumbers?.contactNumber ?? "-"}" ??
                                            "-",
                                  ).showIf(cubit
                                              .userSavedData
                                              ?.users
                                              ?.alternativeContactNumbers
                                              ?.contactNumber !=
                                          null &&
                                      cubit
                                              .userSavedData
                                              ?.users
                                              ?.alternativeContactNumbers
                                              ?.contactNumber !=
                                          ""),
                                  InfoRow(
                                    label: appStrings(context).lblEmailID,
                                    value: cubit.userSavedData?.users?.email ??
                                        "-",
                                  ).showIf(cubit.userSavedData?.users?.email !=
                                          null &&
                                      cubit.userSavedData?.users?.email != ""),
                                  InfoRow(
                                    label: appStrings(context).lblCountry,
                                    value: cubit.userSavedData?.users
                                            ?.countryData?.name ??
                                        "-",
                                  ).showIf(cubit.userSavedData?.users
                                              ?.countryData !=
                                          null &&
                                      cubit.userSavedData?.users?.countryData
                                              ?.name !=
                                          null &&
                                      cubit.userSavedData?.users?.countryData
                                              ?.name !=
                                          ""),
                                  InfoRow(
                                    label: appStrings(context).lblCity,
                                    value: cubit
                                            .userSavedData?.users?.city?.name ??
                                        "-",
                                  ).showIf(cubit.userSavedData?.users?.city !=
                                          null &&
                                      cubit.userSavedData?.users?.city?.name !=
                                          null &&
                                      cubit.userSavedData?.users?.city?.name !=
                                          ""),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InfoRow(
                                        label:
                                            appStrings(context).lblCompanyName,
                                        value: cubit.userSavedData?.users
                                                ?.companyName ??
                                            "-",
                                      ).showIf(cubit.userSavedData?.users
                                                  ?.companyName !=
                                              null &&
                                          cubit.userSavedData?.users
                                                  ?.companyName !=
                                              ""),
                                      InfoRow(
                                        label: appStrings(context).lblWebsite,
                                        value: cubit
                                                    .userSavedData
                                                    ?.users
                                                    ?.socialMediaLinks
                                                    ?.website
                                                    ?.isNotEmpty ==
                                                true
                                            ? cubit
                                                    .userSavedData
                                                    ?.users
                                                    ?.socialMediaLinks
                                                    ?.website ??
                                                "-"
                                            : "-",
                                      ).showIf(cubit.userSavedData?.users
                                                  ?.socialMediaLinks?.website !=
                                              null &&
                                          cubit.userSavedData?.users
                                                  ?.socialMediaLinks?.website !=
                                              ""),
                                      InfoRow(
                                        label: appStrings(context).lblCatalog,
                                        value: cubit
                                                    .userSavedData
                                                    ?.users
                                                    ?.socialMediaLinks
                                                    ?.catalog
                                                    ?.isNotEmpty ==
                                                true
                                            ? cubit
                                                    .userSavedData
                                                    ?.users
                                                    ?.socialMediaLinks
                                                    ?.catalog ??
                                                "-"
                                            : "-",
                                      ).showIf(cubit.userSavedData?.users
                                                  ?.socialMediaLinks?.catalog !=
                                              null &&
                                          cubit.userSavedData?.users
                                                  ?.socialMediaLinks?.catalog !=
                                              ""),
                                      InfoRow(
                                        label: appStrings(context).virtualTour,
                                        value: cubit
                                                    .userSavedData
                                                    ?.users
                                                    ?.socialMediaLinks
                                                    ?.virtualTour
                                                    ?.isNotEmpty ==
                                                true
                                            ? cubit
                                                    .userSavedData
                                                    ?.users
                                                    ?.socialMediaLinks
                                                    ?.virtualTour ??
                                                "-"
                                            : "",
                                      ).showIf(cubit
                                                  .userSavedData
                                                  ?.users
                                                  ?.socialMediaLinks
                                                  ?.virtualTour !=
                                              null &&
                                          cubit
                                                  .userSavedData
                                                  ?.users
                                                  ?.socialMediaLinks
                                                  ?.virtualTour !=
                                              ""),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: cubit
                                                .userSavedData
                                                ?.users
                                                ?.socialMediaLinks
                                                ?.profileLink
                                                ?.length ??
                                            0,
                                        itemBuilder: (context, index) {
                                          final profileLink = cubit
                                              .userSavedData
                                              ?.users
                                              ?.socialMediaLinks
                                              ?.profileLink?[index];
                                          final isMultipleProfileLinks = (cubit
                                                      .userSavedData
                                                      ?.users
                                                      ?.socialMediaLinks
                                                      ?.profileLink
                                                      ?.length ??
                                                  0) >
                                              1;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${appStrings(context).lblProfileLink}${isMultipleProfileLinks ? ' ${index + 1}' : ''}:",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      color: AppColors.black5E
                                                          .forLightMode(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                              4.verticalSpace,
                                              UIComponent.customInkWellWidget(
                                                onTap: () async {
                                                  if (profileLink != null) {
                                                    await Utils.launchURL(
                                                        url: profileLink);
                                                  }
                                                },
                                                child: Text(
                                                  profileLink ?? "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .colorPrimary,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            16.verticalSpace,
                                      ).showIf(cubit
                                                  .userSavedData
                                                  ?.users
                                                  ?.socialMediaLinks
                                                  ?.profileLink !=
                                              null &&
                                          cubit
                                                  .userSavedData
                                                  ?.users
                                                  ?.socialMediaLinks
                                                  ?.profileLink !=
                                              []),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: cubit.userSavedData?.users
                                                ?.location?.length ??
                                            0,
                                        itemBuilder: (context, index) {
                                          final location = cubit.userSavedData
                                              ?.users?.location?[index];
                                          final isMultipleAddresses = (cubit
                                                      .userSavedData
                                                      ?.users
                                                      ?.location
                                                      ?.length ??
                                                  0) >
                                              1;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${appStrings(context).lblAddress}${isMultipleAddresses ? ' ${index + 1}' : ''}:",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      color: AppColors.black5E
                                                          .forLightMode(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                              4.verticalSpace,
                                              Text(
                                                location?.address ?? "-",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors.black14
                                                          .adaptiveColor(
                                                        context,
                                                        lightModeColor:
                                                            AppColors.black14,
                                                        darkModeColor:
                                                            AppColors.white,
                                                      ),
                                                    ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            16.verticalSpace,
                                      ).showIf(cubit.userSavedData?.users
                                                  ?.location !=
                                              null &&
                                          cubit.userSavedData?.users
                                                  ?.location !=
                                              []),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${appStrings(context).lblDescription} :",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: AppColors.black5E
                                                          .forLightMode(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                            4.verticalSpace,
                                            ReadMoreText(
                                              cubit.userSavedData?.users
                                                      ?.companyDescription ??
                                                  "-",
                                              trimMode: TrimMode.Line,
                                              trimLines: 3,
                                              locale: Locale(
                                                  "en" /*cubit.selectedLanguage*/),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.black14
                                                        .adaptiveColor(
                                                      context,
                                                      lightModeColor:
                                                          AppColors.black14,
                                                      darkModeColor:
                                                          AppColors.white,
                                                    ),
                                                  ),
                                              trimCollapsedText:
                                                  '\n${appStrings(context).readMore}...',
                                              trimExpandedText:
                                                  '\n${appStrings(context).readLess}',
                                              lessStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .colorPrimary
                                                          .adaptiveColor(
                                                              context,
                                                              lightModeColor:
                                                                  AppColors
                                                                      .colorPrimary,
                                                              darkModeColor:
                                                                  AppColors
                                                                      .colorPrimary)),
                                              moreStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .colorPrimary
                                                          .adaptiveColor(
                                                              context,
                                                              lightModeColor:
                                                                  AppColors
                                                                      .colorPrimary,
                                                              darkModeColor:
                                                                  AppColors
                                                                      .colorPrimary)),
                                            ),
                                            // Text(
                                            //   cubit.userSavedData?.users
                                            //           ?.companyDescription ??
                                            //       "-",
                                            //   maxLines: 5,
                                            //   overflow: TextOverflow.ellipsis,
                                            //   style: Theme.of(context)
                                            //       .textTheme
                                            //       .titleSmall
                                            //       ?.copyWith(
                                            //         fontWeight: FontWeight.w400,
                                            //         color: AppColors.black14
                                            //             .adaptiveColor(
                                            //           context,
                                            //           lightModeColor:
                                            //               AppColors.black14,
                                            //           darkModeColor:
                                            //               AppColors.white,
                                            //         ),
                                            //       ),
                                            // ),
                                          ],
                                        ),
                                      ).showIf(cubit.userSavedData?.users
                                                  ?.companyDescription !=
                                              null &&
                                          cubit.userSavedData?.users
                                                  ?.companyDescription !=
                                              ""),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${appStrings(context).lblSocialMedia} :",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: AppColors.black3D
                                                          .forLightMode(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w400),
                                            ),
                                            8.verticalSpace,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: cubit
                                                          .userSavedData
                                                          ?.users
                                                          ?.socialMediaLinks
                                                          ?.facebook
                                                          ?.isNotEmpty ??
                                                      true,
                                                  child: UIComponent
                                                      .customInkWellWidget(
                                                          onTap: () async {
                                                            await Utils.launchURL(
                                                                url: cubit
                                                                        .userSavedData
                                                                        ?.users
                                                                        ?.socialMediaLinks
                                                                        ?.facebook ??
                                                                    "-");
                                                          },
                                                          child: SVGAssets
                                                              .facebookVector
                                                              .toSvg(
                                                                  context:
                                                                      context,
                                                                  height: 32,
                                                                  width: 32)),
                                                ),
                                                12.horizontalSpace.showIf(cubit
                                                        .userSavedData
                                                        ?.users
                                                        ?.socialMediaLinks
                                                        ?.facebook
                                                        ?.isNotEmpty ??
                                                    true),
                                                UIComponent.customInkWellWidget(
                                                  onTap: () async {
                                                    await Utils.launchURL(
                                                        url: cubit
                                                                .userSavedData
                                                                ?.users
                                                                ?.socialMediaLinks
                                                                ?.linkedIn ??
                                                            "-");
                                                  },
                                                  child: SVGAssets
                                                      .linkedinVector
                                                      .toSvg(
                                                          context: context,
                                                          height: 32,
                                                          width: 32)
                                                      .showIf(
                                                          cubit.selectedRole ==
                                                              AppStrings.owner),
                                                ).showIf(cubit
                                                        .userSavedData
                                                        ?.users
                                                        ?.socialMediaLinks
                                                        ?.linkedIn
                                                        ?.isNotEmpty ??
                                                    true),
                                                12.horizontalSpace.showIf((cubit
                                                            .selectedRole ==
                                                        AppStrings.owner) &&
                                                    (cubit
                                                            .userSavedData
                                                            ?.users
                                                            ?.socialMediaLinks
                                                            ?.linkedIn
                                                            ?.isNotEmpty ??
                                                        true)),
                                                UIComponent.customInkWellWidget(
                                                  onTap: () async {
                                                    await Utils.launchURL(
                                                        url: cubit
                                                                .userSavedData
                                                                ?.users
                                                                ?.socialMediaLinks
                                                                ?.instagram ??
                                                            "-");
                                                  },
                                                  child: SVGAssets
                                                      .instagramVector
                                                      .toSvg(
                                                          context: context,
                                                          height: 32,
                                                          width: 32),
                                                ).showIf(cubit
                                                        .userSavedData
                                                        ?.users
                                                        ?.socialMediaLinks
                                                        ?.instagram
                                                        ?.isNotEmpty ??
                                                    true),
                                                12.horizontalSpace.showIf(cubit
                                                        .userSavedData
                                                        ?.users
                                                        ?.socialMediaLinks
                                                        ?.instagram
                                                        ?.isNotEmpty ??
                                                    true),
                                                UIComponent.customInkWellWidget(
                                                  onTap: () async {
                                                    await Utils.launchURL(
                                                        url: cubit
                                                                .userSavedData
                                                                ?.users
                                                                ?.socialMediaLinks
                                                                ?.twitter ??
                                                            "-");
                                                  },
                                                  child: SVGAssets.twitterVector
                                                      .toSvg(
                                                          context: context,
                                                          height: 32,
                                                          width: 32)
                                                      .showIf(cubit
                                                              .selectedRole ==
                                                          AppStrings.vendor),
                                                ).showIf(cubit
                                                        .userSavedData
                                                        ?.users
                                                        ?.socialMediaLinks
                                                        ?.twitter
                                                        ?.isNotEmpty ??
                                                    true),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ).hideIf(
                                        ((cubit.selectedRole ==
                                                    AppStrings.vendor
                                                ? cubit.userSavedData?.users
                                                    ?.socialMediaLinks
                                                    ?.isEmptyVendor()
                                                : cubit.userSavedData?.users
                                                    ?.socialMediaLinks
                                                    ?.isEmptyOwner()) ??
                                            false),
                                      )
                                    ],
                                  ).showIf(
                                      cubit.selectedRole != AppStrings.visitor)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    UIComponent.customInkWellWidget(
                      onTap: () {
                        UIComponent.showCustomBottomSheet(
                          context: context,
                          builder: _buildConfirmDeleteBottomSheet(),
                        );
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          appStrings(context).lblDeleteAccount,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.red00),
                        ),
                      ),
                    ),
                    32.verticalSpace,
                  ],
                ),
              ),
            );
          },
        ));
  }

  /// Build bloc listener widget.
  ///
  Future<void> buildBlocListener(
      BuildContext context, PersonalInformationState state) async {
    if (state is PersonalInformationLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is APISuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is PersonalInformationCountryFetchSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is UserDetailsLoadedForPersonalInformation) {
      OverlayLoadingProgress.stop();
    } else if (state is CompleteProfileSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is UpdatedUserDetailsLoading) {
      OverlayLoadingProgress.stop();
    } else if (state is UpdatedUserDetailsLoaded) {
      OverlayLoadingProgress.stop();
    } else if (state is ImageDataLoaded) {
      OverlayLoadingProgress.stop();
    } else if (state is DeleteProfileSuccess) {
      OverlayLoadingProgress.stop();
      _handleDelete(context, state.successMessage);
    } else if (state is PersonalInformationError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }

  Future<void> _handleDelete(BuildContext context, String message) async {
    await SessionTracker().onLogout();
    await GetIt.I<AppPreferences>().clearData();

    if (!context.mounted) return;
    context.goNamed(Routes.kLoginScreen);
    if (!context.mounted) return;
    Utils.snackBar(
      context: context,
      message: message,
    );
  }

  Widget buildImageOrDocumentWidget(
      {dynamic fileItem,
      required bool isImageAllow,
      required int itemIndex,
      String? fileName,
      String? fileExtension}) {
    if (isImageAllow || isImageFile(fileName!)) {
      if (fileItem is String && fileItem.contains("http")) {
        var isValidUrl = Uri.parse(fileItem).isAbsolute;
        if (isValidUrl) {
          return Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: UIComponent.cachedNetworkImageWidget(
                    imageUrl: fileItem,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
      if (isImageFile(fileItem)) {
        return Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(fileItem),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return Container(
        decoration: BoxDecoration(
            color: AppColors.greyF5F4, borderRadius: BorderRadius.circular(12)),
        child: UIComponent.customInkWellWidget(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 12.0, end: 12.0, top: 8, bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SVGAssets.fileIcon.toSvg(context: context),
                    6.verticalSpace,
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.black14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  bool isImageFile(String filePath) {
    final List<String> imageExtensions = ['.jpg', '.jpeg', '.png'];
    return imageExtensions
        .any((extension) => filePath.toLowerCase().endsWith(extension));
  }

  Widget _buildConfirmDeleteBottomSheet() {
    PersonalInformationCubit cubit = context.read<PersonalInformationCubit>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SVGAssets.deleteVector.toSvg(height: 50, width: 50, context: context),
        12.verticalSpace,
        Text(
          appStrings(context).lblConfirmAccountDeletion,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        8.verticalSpace,
        Text(
          appStrings(context).textDeletingYourAccountWill,
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        20.verticalSpace,
        ButtonRow(
          isRightButtonGradient: false,
          isRightButtonBorderRequired: true,
          isLeftButtonBorderRequired: true,
          leftButtonText: appStrings(context).no,
          rightButtonText: appStrings(context).yes,
          onLeftButtonTap: () {
            Navigator.pop(context);
          },
          onRightButtonTap: () async {
            Navigator.pop(context);
            await cubit.deleteProfile();
          },
          rightButtonBgColor: AppColors.white,
          rightButtonTextColor: AppColors.red00,
          rightButtonBorderColor: AppColors.red00,
          leftButtonBorderColor: AppColors.black3D,
        ),
      ],
    );
  }
}
