import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/resources/text_styles.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../navigation/route_arguments.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/app_bar_mixin.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import 'cubit/view_all_certificates_cubit.dart';

class ViewAllCertificatesScreen extends StatefulWidget {
  final List<dynamic> certificatesList;
  final String isForPortfolio;
  final String isForPropertyDetail;

  const ViewAllCertificatesScreen({
    super.key,
    required this.certificatesList,
    required this.isForPortfolio,
    required this.isForPropertyDetail,
  });

  @override
  State<ViewAllCertificatesScreen> createState() =>
      _ViewAllCertificatesScreenState();
}

class _ViewAllCertificatesScreenState extends State<ViewAllCertificatesScreen>
    with AppBarMixin {
  @override
  void initState() {
    context
        .read<ViewAllCertificatesCubit>()
        .getData(context, widget.certificatesList);
    printf("CertificatesList--------${widget.certificatesList.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ViewAllCertificatesCubit cubit = context.read<ViewAllCertificatesCubit>();
    return BlocConsumer<ViewAllCertificatesCubit, ViewAllCertificatesState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
              appBar: buildAppBar(
                  title: appStrings(context).lblCertificates,
                  context: context,
                  requireLeading: true),
              bottomNavigationBar: BlocBuilder<ViewAllCertificatesCubit,
                      ViewAllCertificatesState>(
                  builder: (context, state) =>
                      (cubit.selectedRole == AppStrings.visitor ||
                                  cubit.selectedRole == AppStrings.guest) ||
                              (widget.isForPropertyDetail == "true")
                          ? const SizedBox.shrink()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                UIComponent.bottomSheetWithButtonWithGradient(
                                    context: context,
                                    onTap: () {
                                      onEditClick(context);
                                    },
                                    buttonTitle: appStrings(context).lblEdit),
                              ],
                            )),
              body: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GridView.builder(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: /*widget.isImageTypeOnly
                                  ? const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              )
                                  : */
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 9,
                                childAspectRatio: 1),
                        itemCount: cubit.certificatesList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var attachmentList = cubit.certificatesList[index];

                          return Stack(
                            alignment: Alignment.center,
                            // Align children at the center
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                // Apply circular radius
                                child: Stack(
                                  children: [
                                    buildImageOrDocumentWidget(
                                      fileItem: attachmentList,
                                      isImageAllow: false,
                                      itemIndex: index,
                                      fileName:
                                          (attachmentList as String).isNotEmpty
                                              ? cubit.certificatesList[index]
                                                  .split('/')
                                                  .last
                                              : "",
                                      fileExtension: (attachmentList).isNotEmpty
                                          ? cubit.certificatesList[index]
                                              .split('.')
                                              .last
                                          : "",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  /// Build bloc listener widget.
  void buildBlocListener(BuildContext context, ViewAllCertificatesState state) {
    if (state is SubmitOfferLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is SubmitOfferSuccess) {
      OverlayLoadingProgress.stop();
      context.pop();
    } else if (state is SubmitOfferFailure) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(context: context, message: state.message);
    }
  }

  Future<void> onEditClick(BuildContext context) async {
    context.pushNamed(Routes.kAddEditCertificatesScreen,
        extra: widget.certificatesList,
        pathParameters: {
          RouteArguments.isForPortfolio: widget.isForPortfolio,
          RouteArguments.isForEdit: "true",
        }).then((value) {
      if (!context.mounted) return;
      context.pop();
    });
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
                  borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(16),
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
            color: AppColors.greyF5F4, borderRadius: BorderRadius.circular(16)),
        child: UIComponent.customInkWellWidget(
          onTap: () async {
            await Utils.launchURL(url: fileItem);
          },
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
                      style: h14().copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                4.verticalSpace,
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
}
