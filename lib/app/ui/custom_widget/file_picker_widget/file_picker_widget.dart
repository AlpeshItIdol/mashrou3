import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/model/file_details_data.dart';
import 'package:mashrou3/app/ui/custom_widget/common_button.dart';
import 'package:mashrou3/app/ui/custom_widget/file_picker_widget/cubit/file_picker_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/cubit/add_edit_property_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_values.dart';
import 'package:mashrou3/config/resources/text_styles.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../utils/ui_components.dart';
import '../../screens/authentication/register/complete_profile/cubit/complete_profile_cubit.dart';
import '../../screens/personal_information/sub_screens/add_edit_certificates/cubit/add_edit_certificates_cubit.dart';

class FilePickerWidget extends StatefulWidget {
  List<dynamic> fileList;
  final bool isEdit;
  final bool isImageTypeOnly;
  final bool isDocument;
  final bool requireLocalDelete;
  final bool isProfilePicture;
  final bool isNoDataPlaceHolderNeeded;
  final int maxUploadVal;
  final int maxFileSizeMb;
  String? fileName;
  String? fileExtension;
  final bool? isProfileImageSelection;
  List<FileDetailsData>? fileDetails;
  final List<String>? allowedFileExtensions;
  final String? allowedExtensionDocumentString;

  FilePickerWidget(
      {super.key,
      required this.fileList,
      required this.isEdit,
      required this.isImageTypeOnly,
      required this.isDocument,
      this.isProfilePicture = false,
      this.requireLocalDelete = true,
      this.isNoDataPlaceHolderNeeded = true,
      this.fileName,
      this.fileExtension,
      this.isProfileImageSelection,
      this.allowedFileExtensions,
      this.fileDetails,
      this.maxUploadVal = 4,
      this.maxFileSizeMb = 2,
      this.allowedExtensionDocumentString =
          "('pdf','doc','docx','jpg','jpeg','png','xls','xlsx')"});

  @override
  State<FilePickerWidget> createState() => _AttachmentWidget();
}

class _AttachmentWidget extends State<FilePickerWidget> {
  @override
  Widget build(BuildContext context) {
    context.read<FilePickerCubit>().setAttachments(
          widget.fileList,
          widget.maxUploadVal,
          widget.allowedFileExtensions,
        );
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.greyE9.adaptiveColor(context,
                        lightModeColor: AppColors.greyE9,
                        darkModeColor: AppColors.black2E))),
            child: BlocListener<AddEditPropertyCubit, AddEditPropertyState>(
              listener: (context, state) {},
              child: BlocListener<AddEditCertificatesCubit,
                  AddEditCertificatesState>(
                listener: (context, state) {},
                child: BlocListener<CompleteProfileCubit, CompleteProfileState>(
                  listener: (context, state) {},
                  child: BlocConsumer<FilePickerCubit, FilePickerState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                gridDelegate: widget.isImageTypeOnly
                                    ? const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                      )
                                    : const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 9,
                                        childAspectRatio: 1),
                                itemCount: context
                                    .read<FilePickerCubit>()
                                    .attachmentList
                                    .length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var attachmentList = context
                                      .read<FilePickerCubit>()
                                      .attachmentList[index];
                                  return Stack(
                                    children: [
                                      BlocBuilder<FilePickerCubit,
                                          FilePickerState>(
                                        bloc: context.read<FilePickerCubit>(),
                                        builder: (context, state) {
                                          return buildImageOrDocumentWidget(
                                              fileItem: attachmentList,
                                              isImageAllow:
                                                  widget.isImageTypeOnly,
                                              itemIndex: index,
                                              fileName:
                                                  (attachmentList as String)
                                                          .isNotEmpty
                                                      ? widget.fileList[index]
                                                          .split('/')
                                                          .last
                                                      : "",
                                              fileExtension:
                                                  (attachmentList).isNotEmpty
                                                      ? widget.fileList[index]
                                                          .split('.')
                                                          .last
                                                      : "");
                                        },
                                      ),
                                      widget.isEdit && widget.isImageTypeOnly
                                          ? PositionedDirectional(
                                              top: 4,
                                              end: 4,
                                              child: UIComponent
                                                  .customInkWellWidget(
                                                onTap: () {
                                                  context
                                                      .read<FilePickerCubit>()
                                                      .removeAttachment(
                                                          index: index,
                                                          localDelete: widget
                                                              .requireLocalDelete);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: SVGAssets.deleteBgIcon
                                                      .toSvg(context: context),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      if (!widget.isEdit)
                                        InkWell(
                                          onTap: () {
                                            OpenFilex.open(context
                                                .read<FilePickerCubit>()
                                                .attachmentList[index]);
                                          },
                                          child: const SizedBox(
                                            width: double.maxFinite,
                                            height: double.maxFinite,
                                          ),
                                        )
                                    ],
                                  );
                                }),
                            if (widget.fileList.isNotEmpty)
                              BlocBuilder<FilePickerCubit, FilePickerState>(
                                builder: (context, state) {
                                  if (state is DisableSelection) {
                                    return const SizedBox.shrink();
                                  }
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      8.verticalSpace,
                                      Divider(
                                          color: AppColors.greyE9.adaptiveColor(
                                              context,
                                              lightModeColor: AppColors.greyE9,
                                              darkModeColor:
                                                  AppColors.black2E)),
                                      16.verticalSpace,
                                    ],
                                  );
                                },
                              ),
                            if (widget.fileList.isEmpty)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UIComponent.noDataRoundedCard(context),
                                  8.verticalSpace,
                                  Divider(
                                      color: AppColors.greyE9.adaptiveColor(
                                          context,
                                          lightModeColor: AppColors.greyE9,
                                          darkModeColor: AppColors.black2E)),
                                  16.verticalSpace,
                                ],
                              ),
                            BlocBuilder<FilePickerCubit, FilePickerState>(
                              builder: (context, state) {
                                if (state is DisableSelection) {
                                  return const SizedBox.shrink();
                                }
                                return CommonButton(
                                  onTap: () async {
                                    await Utils.getStorageReadPermission();
                                    var initialFileCount =
                                        widget.fileList.length;

                                    if (!context.mounted) return;

                                    // Check for iOS platform
                                    if (Theme.of(context).platform ==
                                        TargetPlatform.iOS) {
                                      // Show iOS-specific picker
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) {
                                          context
                                              .read<FilePickerCubit>()
                                              .setAttachments(
                                                widget.fileList,
                                                widget.maxUploadVal,
                                                widget.allowedFileExtensions,
                                              );
                                          return CupertinoActionSheet(
                                            actions: [
                                              CupertinoActionSheetAction(
                                                  onPressed: () async {
                                                    await handleFilePick(
                                                        isImageTypeOnly: true,
                                                        context: context,
                                                        state: state);
                                                  },
                                                  child: UIComponent
                                                      .buildCupertinoOptionRow(
                                                    iconData: CupertinoIcons
                                                        .photo_fill_on_rectangle_fill,
                                                    context: context,
                                                    text: appStrings(context)
                                                        .photoLibrary,
                                                  )),
                                              CupertinoActionSheetAction(
                                                  onPressed: () async {
                                                    await handleFilePick(
                                                        isImageTypeOnly: false,
                                                        context: context,
                                                        state: state);
                                                  },
                                                  child: UIComponent
                                                      .buildCupertinoOptionRow(
                                                    iconData: CupertinoIcons
                                                        .folder_fill,
                                                    text: appStrings(context)
                                                        .chooseFiles,
                                                    context: context,
                                                  )),
                                            ],
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              isDefaultAction: true,
                                              child: Text(
                                                appStrings(context).textCancel,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      // Default behavior for Android or other platforms
                                      if (widget.isImageTypeOnly == true) {
                                        await context
                                            .read<FilePickerCubit>()
                                            .pickFiles(
                                                widget.fileList,
                                                widget.isImageTypeOnly,
                                                widget.fileName ?? "",
                                                widget.fileExtension ?? "",
                                                context);
                                        if (widget.isProfileImageSelection ==
                                                true &&
                                            initialFileCount > 1) {
                                          if (!context.mounted) return;
                                          Utils.showErrorMessage(
                                            context: context,
                                            message: appStrings(context)
                                                .selectOnlyOneImage,
                                          );
                                        }
                                      } else {
                                        await context
                                            .read<FilePickerCubit>()
                                            .pickFiles(
                                                widget.fileList,
                                                widget.isImageTypeOnly,
                                                widget.fileName ?? "",
                                                widget.fileExtension ?? "",
                                                context);
                                      }
                                    }
                                  },
                                  buttonBgColor: AppColors.black3D,
                                  buttonTextColor: AppColors.white,
                                  isGradientColor: false,
                                  width: AppValues.screenWidth / 3.4,
                                  title: appStrings(context).browse,
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          8.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  widget.maxUploadVal == 1
                      ? appStrings(context).maxUpload(widget.maxUploadVal)
                      : appStrings(context).maxUploads(widget.maxUploadVal),
                ),
              )
            ],
          )
        ],
      ),
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
              PositionedDirectional(
                top: 4,
                end: 4,
                child: UIComponent.customInkWellWidget(
                  onTap: () {
                    context
                        .read<FilePickerCubit>()
                        .removeAttachment(index: itemIndex);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SVGAssets.deleteBgIcon.toSvg(context: context),
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
        return BlocConsumer<FilePickerCubit, FilePickerState>(
          listener: (context, state) {},
          builder: (context, state) {
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
                PositionedDirectional(
                  top: 4,
                  end: 4,
                  child: UIComponent.customInkWellWidget(
                    onTap: () {
                      context
                          .read<FilePickerCubit>()
                          .removeAttachment(index: itemIndex);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SVGAssets.deleteBgIcon.toSvg(context: context),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return BlocBuilder<FilePickerCubit, FilePickerState>(
          builder: (context, state) => Container(
                decoration: BoxDecoration(
                    color: AppColors.greyF5F4,
                    borderRadius: BorderRadius.circular(12)),
                child: UIComponent.customInkWellWidget(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 12.0, top: 8, bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: UIComponent.customInkWellWidget(
                            onTap: () {
                              context
                                  .read<FilePickerCubit>()
                                  .removeAttachment(index: itemIndex);
                            },
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(end: 8),
                              child: SVGAssets.deleteBgIcon
                                  .toSvg(context: context),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SVGAssets.fileIcon.toSvg(context: context),
                            6.verticalSpace,
                            Text(
                              Uri.decodeComponent(fileName),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: h14().copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black14),
                            ),
                          ],
                        ),
                        4.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ));
    }
  }

  bool isImageFile(String filePath) {
    final List<String> imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'heif',
      'heic',
    ];
    return imageExtensions
        .any((extension) => filePath.toLowerCase().endsWith(extension));
  }

  // Helper Method
  Future<void> handleFilePick(
      {required bool isImageTypeOnly,
      required BuildContext context,
      required FilePickerState state}) async {
    Navigator.pop(context);
    var cubit = context.read<FilePickerCubit>();
    await cubit.pickFiles(widget.fileList, isImageTypeOnly,
        widget.fileName ?? "", widget.fileExtension ?? "", context);
    // Restrict profile image selection to 1 file only
    if (widget.isProfileImageSelection == true && widget.fileList.length > 1) {
      // Remove extra files
      widget.fileList.removeRange(1, widget.fileList.length);

      if (!context.mounted) return;

      Utils.showErrorMessage(
          context: context, message: appStrings(context).selectOnlyOneImage);
    }
  }
}
