import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/model/property/property_list_response_model.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/home/components/property_list_item.dart';
import 'package:mashrou3/app/ui/screens/personal_information/component/info_row.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../config/resources/app_assets.dart';
import '../../../../utils/read_more_text.dart';
import '../../../db/app_preferences.dart';
import '../../../db/session_tracker.dart';
import '../../../navigation/route_arguments.dart';
import '../../custom_widget/file_picker_widget/cubit/file_picker_cubit.dart';
import '../../custom_widget/toggle_widget/toggle_cubit.dart';
import 'cubit/profile_detail_cubit.dart';

class ProfileDetailScreen extends StatefulWidget with AppBarMixin {
  final String userId;

  ProfileDetailScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> with AppBarMixin {
  String? selectedCategoryId;
  final PagingController<int, PropertyData> _pagingController = PagingController(firstPageKey: 1);
  bool isFetchingData = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileDetailCubit>().getData(context, userId: widget.userId);
    _pagingController.addPageRequestListener((pageKey) {
      context.read<ProfileDetailCubit>().getPropertyList(userId: widget.userId, pageKey: pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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
        title: appStrings(context).profile,
      ),
      body: FutureBuilder(
        future: _initializeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: UIComponent.getSkeletonProfileDetail(),
            );
          }
          return _buildBlocConsumer;
        },
      ),
    );
  }

  Future<void> _initializeData() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  /// Build bloc consumer widget.
  ///

  Widget get _buildBlocConsumer {
    return BlocProvider(
        create: (context) {
          return ToggleCubit(AppConstants.propertyCategory);
        },
        child: BlocConsumer<ProfileDetailCubit, ProfileDetailState>(
          listener: buildBlocListener,
          builder: (context, state) {
            ProfileDetailCubit cubit = context.read<ProfileDetailCubit>();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    BlocProvider(
                      create: (BuildContext context) => FilePickerCubit(),
                      child: BlocConsumer<FilePickerCubit, FilePickerState>(listener: (context, state) async {
                        if (state is FilePickerDataLoading) {}

                        if (state is OnlyImageFilesPickedState) {
                          final imageList = state.files.map((e) => e.path).toList();
                          cubit.profilePictureList.clear();
                          cubit.profilePictureList.addAll(imageList);
                        }
                      }, builder: (context, state) {
                        return UIComponent.buildUserProfileWidgetForProfileDetail(
                          isGuest: false,
                          isVisitor: false,
                          isUploadIconNeeded: false,
                          showUserName: true,
                          context: context,
                          userName: cubit.isBankRole
                              ? cubit.detailData.companyName ?? ""
                              : "${cubit.detailData.firstName ?? ""} ${cubit.detailData.lastName ?? ""}".trim(),
                          userCountryCity: !cubit.isBankRole
                              ? "${cubit.detailData.city?.name ?? ""}, ${cubit.detailData.country ?? ""}".trim()
                              : "${cubit.detailData.bankLocation?.city ?? ""}, ${cubit.detailData.bankLocation?.country ?? ""}".trim(),
                          userRoleType: cubit.selectedRole,
                          imageStr: cubit.profilePictureList != null && cubit.profilePictureList.isNotEmpty
                              ? cubit.profilePictureList.first ?? ""
                              : "",
                          onAddImageTap: () async {
                            await Utils.getStorageReadPermission();

                            if (!context.mounted) return;
                            context.read<FilePickerCubit>().pickFiles(cubit.profilePictureList, true, "", "", context);
                          },
                        );
                      }),
                    ),
                    12.verticalSpace,
                    // Column(
                    //   children: [
                    //     Row(
                    //       mainAxisSize: MainAxisSize.max,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         // Left text showing found estates
                    //         Text(
                    //           appStrings(context).lblCertificates,
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .titleLarge
                    //               ?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
                    //         ),
                    //       ],
                    //     ),
                    //     10.verticalSpace,
                    //     Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(16),
                    //         border: Border.all(
                    //           color: AppColors.greyE8.adaptiveColor(
                    //             context,
                    //             lightModeColor: AppColors.greyE8,
                    //             darkModeColor: AppColors.black2E,
                    //           ),
                    //           width: 1,
                    //         ),
                    //       ),
                    //       child: Column(
                    //         crossAxisAlignment: cubit.certificatesList.isEmpty ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    //         children: [
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               UIComponent.noData(context),
                    //             ],
                    //           ).showIf(cubit.certificatesList.isEmpty),
                    //           Padding(
                    //             padding: const EdgeInsetsDirectional.all(12.0),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Expanded(
                    //                   child: GridView.builder(
                    //                     physics: const NeverScrollableScrollPhysics(),
                    //                     padding: EdgeInsets.zero,
                    //                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //                         crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 9, childAspectRatio: 1),
                    //                     itemCount: cubit.certificatesList.length > 6 ? 6 : cubit.certificatesList.length,
                    //                     shrinkWrap: true,
                    //                     itemBuilder: (context, index) {
                    //                       var attachmentList = cubit.certificatesList[index];
                    //                       // final isLastItem = index == cubit.certificatesList.length - 1;
                    //                       final isLastItem =
                    //                           index == (cubit.certificatesList.length > 6 ? 5 : cubit.certificatesList.length - 1);
                    //
                    //                       return Stack(
                    //                         alignment: Alignment.center,
                    //                         children: [
                    //                           ClipRRect(
                    //                             borderRadius: BorderRadius.circular(12),
                    //                             child: Stack(
                    //                               children: [
                    //                                 buildImageOrDocumentWidget(
                    //                                   fileItem: attachmentList,
                    //                                   isImageAllow: false,
                    //                                   itemIndex: index,
                    //                                   fileName: (attachmentList as String).isNotEmpty
                    //                                       ? cubit.certificatesList[index].split('/').last
                    //                                       : "",
                    //                                   fileExtension:
                    //                                       (attachmentList).isNotEmpty ? cubit.certificatesList[index].split('.').last : "",
                    //                                 ),
                    //                                 if (cubit.certificatesList.length > 6 && isLastItem)
                    //                                   Container(
                    //                                     decoration: BoxDecoration(
                    //                                       color: AppColors.black14.withOpacity(0.7),
                    //                                       borderRadius: BorderRadius.circular(12),
                    //                                     ),
                    //                                   ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           if (cubit.certificatesList.length > 6 && isLastItem)
                    //                             Text(
                    //                               appStrings(context).lblViewAll,
                    //                               style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    //                                     fontWeight: FontWeight.w500,
                    //                                     color: AppColors.white,
                    //                                   ),
                    //                             ),
                    //                           InkWell(
                    //                             onTap: () {
                    //                               if (isLastItem) {
                    //                                 context.pushNamed(
                    //                                   Routes.kViewAllCertificatesScreen,
                    //                                   extra: cubit.certificatesList,
                    //                                   pathParameters: {
                    //                                     RouteArguments.isForPortfolio: "false",
                    //                                     RouteArguments.isForPropertyDetail: "true",
                    //                                   },
                    //                                 );
                    //                               } else {
                    //                                 // OpenFilex.open(cubit.certificatesList[index]);
                    //                               }
                    //                             },
                    //                             child: const SizedBox(
                    //                               width: double.maxFinite,
                    //                               height: double.maxFinite,
                    //                             ),
                    //                           ).showIf(cubit.certificatesList.length > 6),
                    //                         ],
                    //                       );
                    //                     },
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ).showIf(cubit.certificatesList.isNotEmpty),
                    //         ],
                    //       ),
                    //     ),
                    //     20.verticalSpace,
                    //   ],
                    // ).hideIf(cubit.isBankRole),
                    12.verticalSpace.showIf(cubit.isBankRole),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Left text showing found estates
                        Text(
                          appStrings(context).lblPersonalInformation,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    10.verticalSpace,
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
                                  UIComponent.customInkWellWidget(
                                    onTap: () {
                                      final phoneNumber = "${cubit.detailData.contactNumber != null ? (cubit.detailData.phoneCode?.startsWith("+") ?? false ? cubit.detailData.phoneCode : "+${cubit.detailData.phoneCode}") : ""}${cubit.detailData.contactNumber ?? ""}";
                                      if (phoneNumber.isNotEmpty && phoneNumber != "-") {
                                        Utils.makePhoneCall(
                                          context: context,
                                          phoneNumber: phoneNumber.replaceAll(" ", ""),
                                        );
                                      }
                                    },
                                    child: InfoRow(
                                      label: appStrings(context).lblMobileNo,
                                      value:
                                      "${cubit.detailData.contactNumber != null ? (cubit.detailData.phoneCode?.startsWith("+") ?? false ? cubit.detailData.phoneCode : "+${cubit.detailData.phoneCode} ") : ""}${cubit.detailData.contactNumber ?? ""}",
                                    ),
                                  ).showIf(!cubit.isBankRole),
                                  InfoRow(
                                    label: appStrings(context).lblBankName,
                                    value: cubit.detailData.companyName ?? "",
                                  ).showIf(cubit.detailData.companyName != null && cubit.detailData.companyName != "" && cubit.isBankRole),
                                  UIComponent.customInkWellWidget(
                                    onTap: () {
                                      final phoneCode = cubit.detailData.alternativeContactNumbers?.phoneCode != null 
                                          ? (cubit.detailData.alternativeContactNumbers?.phoneCode?.startsWith("+") ?? false 
                                              ? cubit.detailData.alternativeContactNumbers?.phoneCode 
                                              : "+${cubit.detailData.alternativeContactNumbers?.phoneCode}")
                                          : "";
                                      final contactNumber = cubit.detailData.alternativeContactNumbers?.contactNumber ?? "";
                                      final phoneNumber = "$phoneCode$contactNumber";
                                      if (phoneNumber.isNotEmpty && phoneNumber != "-" && contactNumber.isNotEmpty && contactNumber != "-") {
                                        Utils.makePhoneCall(
                                          context: context,
                                          phoneNumber: phoneNumber.replaceAll(" ", ""),
                                        );
                                      }
                                    },
                                    child: InfoRow(
                                      label: appStrings(context).lblAlternateMobileNo,
                                      value:
                                      "${cubit.detailData.alternativeContactNumbers?.phoneCode != null ? (cubit.detailData.alternativeContactNumbers?.phoneCode?.startsWith("+") ?? false ? cubit.detailData.alternativeContactNumbers?.phoneCode : "+${cubit.detailData.alternativeContactNumbers?.phoneCode}") : "-"}${cubit.detailData.alternativeContactNumbers?.contactNumber ?? "-"}" ??
                                          "-",
                                    ),
                                  ).showIf(cubit.detailData.alternativeContactNumbers?.contactNumber != null &&
                                      cubit.detailData.alternativeContactNumbers?.contactNumber != ""),
                                  UIComponent.customInkWellWidget(
                                    onTap: () {
                                      final email = cubit.detailData.email ?? "";
                                      if (email.isNotEmpty && email != "-") {
                                        Utils.composeMail(
                                          context: context,
                                          email: email,
                                        );
                                      }
                                    },
                                    child: InfoRow(
                                      label: appStrings(context).lblEmailID,
                                      value: cubit.detailData.email ?? "-",
                                    ),
                                  ).showIf(cubit.detailData.email != null && cubit.detailData.email != ""),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InfoRow(
                                        label: appStrings(context).lblCompanyName,
                                        value: cubit.detailData.companyName ?? "-",
                                      ).showIf(cubit.detailData.companyName != null && cubit.detailData.companyName != ""),
                                      InfoRow(
                                        label: appStrings(context).lblWebsite,
                                        value: cubit.detailData.socialMediaLinks?.website?.isNotEmpty == true
                                            ? cubit.detailData.socialMediaLinks?.website ?? "-"
                                            : "-",
                                      ).showIf(cubit.detailData?.socialMediaLinks?.website != null &&
                                          cubit.detailData?.socialMediaLinks?.website != ""),
                                      InfoRow(
                                        label: appStrings(context).lblCatalog,
                                        value: cubit.detailData.socialMediaLinks?.catalog?.isNotEmpty == true
                                            ? cubit.detailData.socialMediaLinks?.catalog ?? "-"
                                            : "-",
                                      ).showIf(cubit.detailData?.socialMediaLinks?.catalog != null &&
                                          cubit.detailData?.socialMediaLinks?.catalog != ""),
                                      InfoRow(
                                        label: appStrings(context).virtualTour,
                                        value: cubit.detailData.socialMediaLinks?.virtualTour?.isNotEmpty == true
                                            ? cubit.detailData.socialMediaLinks?.virtualTour ?? "-"
                                            : "-",
                                      ).showIf(cubit.detailData.socialMediaLinks?.virtualTour != null &&
                                          cubit.detailData.socialMediaLinks?.virtualTour != ""),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: cubit.detailData.socialMediaLinks?.profileLink?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          final profileLink = cubit.detailData.socialMediaLinks?.profileLink?[index];
                                          final isMultipleProfileLinks = (cubit.detailData.socialMediaLinks?.profileLink?.length ?? 0) > 1;

                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${appStrings(context).lblProfileLink}${isMultipleProfileLinks ? ' ${index + 1}' : ''}:",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  color: AppColors.black5E.forLightMode(context),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              4.verticalSpace,
                                              UIComponent.customInkWellWidget(
                                                onTap: () async {
                                                  if (profileLink != null) {
                                                    await Utils.launchURL(url: profileLink);
                                                  }
                                                },
                                                child: Text(
                                                  profileLink ?? "",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.colorPrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) => 16.verticalSpace,
                                      ).showIf(cubit.detailData.socialMediaLinks?.profileLink != null &&
                                          cubit.detailData.socialMediaLinks?.profileLink != []),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: cubit.detailData?.location?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          final location = cubit.detailData.location?[index];
                                          final isMultipleAddresses = (cubit.detailData.location?.length ?? 0) > 1;

                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${appStrings(context).lblAddress}${isMultipleAddresses ? ' ${index + 1}' : ''}:",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  color: AppColors.black5E.forLightMode(context),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              4.verticalSpace,
                                              Text(
                                                location?.address ?? "-",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.black14.adaptiveColor(
                                                    context,
                                                    lightModeColor: AppColors.black14,
                                                    darkModeColor: AppColors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) => 16.verticalSpace,
                                      ).showIf(cubit.detailData?.location != null && cubit.detailData?.location != []),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${appStrings(context).lblDescription} :",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(color: AppColors.black5E.forLightMode(context), fontWeight: FontWeight.w500),
                                            ),
                                            4.verticalSpace,
                                            ReadMoreText(
                                              cubit.detailData?.companyDescription ?? "-",
                                              trimMode: TrimMode.Line,
                                              trimLines: 3,
                                              locale: const Locale("en" /*cubit.selectedLanguage*/),
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.black14.adaptiveColor(
                                                  context,
                                                  lightModeColor: AppColors.black14,
                                                  darkModeColor: AppColors.white,
                                                ),
                                              ),
                                              trimCollapsedText: '\n${appStrings(context).readMore}...',
                                              trimExpandedText: '\n${appStrings(context).readLess}',
                                              lessStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.colorPrimary.adaptiveColor(context,
                                                      lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.colorPrimary)),
                                              moreStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.colorPrimary.adaptiveColor(context,
                                                      lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.colorPrimary)),
                                            ),
                                          ],
                                        ),
                                      ).showIf(cubit.detailData?.companyDescription != null && cubit.detailData?.companyDescription != ""),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${appStrings(context).lblSocialMedia} :",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(color: AppColors.black3D.forLightMode(context), fontWeight: FontWeight.w400),
                                            ),
                                            8.verticalSpace,
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: cubit.detailData.socialMediaLinks?.facebook?.isNotEmpty ?? true,
                                                  child: UIComponent.customInkWellWidget(
                                                      onTap: () async {
                                                        await Utils.launchURL(url: cubit.detailData.socialMediaLinks?.facebook ?? "-");
                                                      },
                                                      child: SVGAssets.facebookVector.toSvg(context: context, height: 32, width: 32)),
                                                ),
                                                12.horizontalSpace.showIf(cubit.detailData.socialMediaLinks?.facebook?.isNotEmpty ?? true),
                                                UIComponent.customInkWellWidget(
                                                    onTap: () async {
                                                      await Utils.launchURL(url: cubit.detailData?.socialMediaLinks?.linkedIn ?? "-");
                                                    },
                                                    child: SVGAssets.linkedinVector.toSvg(context: context, height: 32, width: 32))
                                                    .showIf(cubit.detailData.socialMediaLinks?.linkedIn?.isNotEmpty ?? true),
                                                12
                                                    .horizontalSpace
                                                    .showIf((cubit.detailData.socialMediaLinks?.linkedIn?.isNotEmpty ?? true)),
                                                UIComponent.customInkWellWidget(
                                                  onTap: () async {
                                                    await Utils.launchURL(url: cubit.detailData.socialMediaLinks?.instagram ?? "-");
                                                  },
                                                  child: SVGAssets.instagramVector.toSvg(context: context, height: 32, width: 32),
                                                ).showIf(cubit.detailData.socialMediaLinks?.instagram?.isNotEmpty ?? true),
                                                12.horizontalSpace.showIf(cubit.detailData.socialMediaLinks?.instagram?.isNotEmpty ?? true),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ).hideIf(
                                        ((cubit.userSavedData?.users?.socialMediaLinks?.isEmptyOwner()) ?? false),
                                      )
                                    ],
                                  ).hideIf(cubit.isBankRole),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      UIComponent.customInkWellWidget(
                                        onTap: () {
                                          final phoneNumber = "${cubit.detailData.bankContactNumbers?.contactNumber != null ? (cubit.detailData.bankContactNumbers?.phoneCode?.startsWith("+") ?? false ? cubit.detailData.bankContactNumbers?.phoneCode : "+${cubit.detailData.bankContactNumbers?.phoneCode}") : ""}${cubit.detailData.bankContactNumbers?.contactNumber ?? ""}";
                                          if (phoneNumber.isNotEmpty && phoneNumber != "-") {
                                            Utils.makePhoneCall(
                                              context: context,
                                              phoneNumber: phoneNumber.replaceAll(" ", ""),
                                            );
                                          }
                                        },
                                        child: InfoRow(
                                          label: appStrings(context).lblMobileNumber,
                                          value:
                                          "${cubit.detailData.bankContactNumbers?.contactNumber != null ? (cubit.detailData.bankContactNumbers?.phoneCode?.startsWith("+") ?? false ? cubit.detailData.bankContactNumbers?.phoneCode : "+${cubit.detailData.bankContactNumbers?.phoneCode} ") : ""}${cubit.detailData.bankContactNumbers?.contactNumber ?? ""}",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          "${appStrings(context).lblAlternateMobileNumber}:",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            color: AppColors.black5E.forLightMode(context),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ).showIf(cubit.detailData.banksAlternativeContact != null &&
                                          cubit.detailData.banksAlternativeContact != []),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: cubit.detailData.banksAlternativeContact?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          final contactData = cubit.detailData.banksAlternativeContact?[index];
                                          return Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.start,
                                            spacing: 6,
                                            runSpacing: 2,
                                            children: [
                                              Text(
                                                "${contactData?.name}:",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.black14.adaptiveColor(
                                                    context,
                                                    lightModeColor: AppColors.black14,
                                                    darkModeColor: AppColors.white,
                                                  ),
                                                ),
                                              ),
                                              UIComponent.customInkWellWidget(
                                                onTap: () {
                                                  final phoneNumber = "${"+${contactData?.phoneCode}"}${contactData?.contactNumber ?? ""}";
                                                  if (phoneNumber.isNotEmpty && contactData?.contactNumber != null && contactData!.contactNumber!.isNotEmpty) {
                                                    Utils.makePhoneCall(
                                                      context: context,
                                                      phoneNumber: phoneNumber.replaceAll(" ", ""),
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  "${"+${contactData?.phoneCode}"} ${contactData?.contactNumber ?? ""}",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.colorPrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) => 8.verticalSpace,
                                      ).showIf(cubit.detailData.banksAlternativeContact != null &&
                                          cubit.detailData.banksAlternativeContact != []),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${appStrings(context).lblAddress}:",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              color: AppColors.black5E.forLightMode(context),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          4.verticalSpace,
                                          Text(
                                            cubit.detailData.bankLocation?.address ?? "-",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.black14.adaptiveColor(
                                                context,
                                                lightModeColor: AppColors.black14,
                                                darkModeColor: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ).showIf(cubit.isBankRole &&
                                          cubit.detailData.bankLocation?.address != null &&
                                          cubit.detailData.bankLocation?.address != []),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${appStrings(context).lblDescription} :",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(color: AppColors.black5E.forLightMode(context), fontWeight: FontWeight.w500),
                                            ),
                                            4.verticalSpace,
                                            ReadMoreText(
                                              cubit.detailData?.companyDescription ?? "-",
                                              trimMode: TrimMode.Line,
                                              trimLines: 3,
                                              locale: const Locale("en" /*cubit.selectedLanguage*/),
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.black14.adaptiveColor(
                                                  context,
                                                  lightModeColor: AppColors.black14,
                                                  darkModeColor: AppColors.white,
                                                ),
                                              ),
                                              trimCollapsedText: '\n${appStrings(context).readMore}...',
                                              trimExpandedText: '\n${appStrings(context).readLess}',
                                              lessStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.colorPrimary.adaptiveColor(context,
                                                      lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.colorPrimary)),
                                              moreStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.colorPrimary.adaptiveColor(context,
                                                      lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.colorPrimary)),
                                            ),
                                          ],
                                        ),
                                      ).showIf(cubit.detailData?.companyDescription != null && cubit.detailData?.companyDescription != ""),
                                    ],
                                  ).showIf(cubit.isBankRole)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    32.verticalSpace,
                    // Property List Section
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          appStrings(context).lblPropertyListing,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    16.verticalSpace,
                    _buildPropertyList(context, cubit),
                    32.verticalSpace,
                  ],
                ),
              ),
            );
          },
        ));
  }

  /// Build property list widget
  Widget _buildPropertyList(BuildContext context, ProfileDetailCubit cubit) {
    return SizedBox(
      height: 430,
      child: PagedListView<int, PropertyData>.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return 12.horizontalSpace;
        },
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<PropertyData>(
        firstPageProgressIndicatorBuilder: (context) {
          return SizedBox(
            width: 400,
            child: Padding(
              padding: EdgeInsets.zero,
              child: UIComponent.getSkeletonProperty(isHorizontal: true),
            ),
          );
        },
        itemBuilder: (context, item, index) {
          return SizedBox(
            width: 350,
            child: PropertyListItem(
              propertyName: item.title ?? '',
              propertyImg: Utils.getLatestPropertyImage(item.propertyFiles ?? [], item.thumbnail ?? "") ?? "",
              propertyImgCount:
              (Utils.getAllImageFiles(item.propertyFiles ?? []).length + ((item.thumbnail != null && item.thumbnail!.isNotEmpty) ? 1 : 0))
                  .toString(),
              propertyPrice: item.price?.amount?.toString(),
              propertyLocation: '${item.city?.isNotEmpty == true ? item.city : ''}'
                  '${(item.city?.isNotEmpty == true && item.country?.isNotEmpty == true) ? ', ' : ''}'
                  '${item.country?.isNotEmpty == true ? item.country : ''}',
              propertyArea: Utils.formatArea('${item.area?.amount ?? ''}', item.area?.unit ?? ''),
              propertyRating: item.rating.toString(),
              isVendor: false,
              isVisitor: true,
              isSoldOut: item.isSoldOut ?? false,
              onPropertyTap: () {
                context.pushNamed(Routes.kPropertyDetailScreen, pathParameters: {
                  RouteArguments.propertyId: item.sId ?? "0",
                  RouteArguments.propertyLat: (item.propertyLocation?.latitude ?? 0.00).toString(),
                  RouteArguments.propertyLng: (item.propertyLocation?.longitude ?? 0.00).toString(),
                }).then((value) {
                  if (value != null && value == true) {
                    _pagingController.refresh();
                  }
                });
              },
              requiredFavorite: true,
              requiredCheckBox: false,
              isFavorite: item.favorite ?? false,
              isSelected: false,
              isBankProperty: item.createdByBank ?? false,
              isLocked: item.isLocked,
              isLockedByMe: item.isLockedByMe,
              offerData: item.offerData,
              onFavouriteToggle: (isFavourite) async {
                if (isFetchingData) return;
                isFetchingData = true;
                try {
                  await cubit.addRemoveFavorite(
                    propertyId: item.sId ?? "",
                    isFav: isFavourite,
                  ).then((value) {
                    Future.delayed(Duration.zero, () async {
                      _pagingController.refresh();
                    });
                  });
                } catch (error) {
                  printf("Error toggling favorite: $error");
                } finally {
                  isFetchingData = false;
                }
              },
              propertyPriceCurrency: item.price?.currencySymbol ?? '',
            ),
          );
        },
        noItemsFoundIndicatorBuilder: (context) {
          return SizedBox(
            height: 200,
            child: Center(
              child: UIComponent.noDataWidgetWithInfo(
                title: appStrings(context).emptyPropertyList,
                info: appStrings(context).emptyPropertyListInfo,
                context: context,
              ),
            ),
          );
        },
      ),
      ),
    );
  }

  /// Build bloc listener widget.
  ///
  Future<void> buildBlocListener(BuildContext context, ProfileDetailState state) async {
    if (state is ProfileDetailLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is APISuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is ProfileDetailCountryFetchSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is UserDetailsLoadedForProfileDetail) {
      OverlayLoadingProgress.stop();
    } else if (state is CompleteProfileSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is UpdatedUserDetailsLoading) {
      OverlayLoadingProgress.stop();
    } else if (state is UpdatedUserDetailsLoaded) {
      OverlayLoadingProgress.stop();
    } else if (state is ProfileDetailSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is ImageDataLoaded) {
      OverlayLoadingProgress.stop();
    } else if (state is DeleteProfileSuccess) {
      OverlayLoadingProgress.stop();
      _handleDelete(context, state.successMessage);
    } else if (state is ProfileDetailError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    } else if (state is PropertyListSuccess) {
      if (state.isLastPage) {
        _pagingController.appendLastPage(state.propertyList);
      } else {
        _pagingController.appendPage(state.propertyList, state.currentKey + 1);
      }
    } else if (state is PropertyListError) {
      _pagingController.appendLastPage([]);
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    } else if (state is NoPropertyFoundState) {
      _pagingController.appendLastPage([]);
    } else if (state is AddedToFavorite) {
      OverlayLoadingProgress.stop();
      Utils.snackBar(
        context: context,
        message: state.successMessage,
      );
    } else if (state is PropertyAddFavError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
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
      {dynamic fileItem, required bool isImageAllow, required int itemIndex, String? fileName, String? fileExtension}) {
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
        decoration: BoxDecoration(color: AppColors.greyF5F4, borderRadius: BorderRadius.circular(12)),
        child: UIComponent.customInkWellWidget(
          onTap: () async {
            await Utils.launchURL(url: fileItem);
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12.0, end: 12.0, top: 8, bottom: 6),
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, color: AppColors.black14),
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
    return imageExtensions.any((extension) => filePath.toLowerCase().endsWith(extension));
  }
}

// locationKeys

