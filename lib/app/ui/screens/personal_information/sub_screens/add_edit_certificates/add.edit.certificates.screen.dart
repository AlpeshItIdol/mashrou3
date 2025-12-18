import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../custom_widget/app_bar_mixin.dart';
import '../../../../custom_widget/file_picker_widget/cubit/file_picker_cubit.dart';
import '../../../../custom_widget/file_picker_widget/file_picker_widget.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import 'cubit/add_edit_certificates_cubit.dart';

class AddEditCertificatesScreen extends StatefulWidget {
  final List<dynamic> certificatesList;
  final String? isForPortfolio;
  final String? isForEdit;

  const AddEditCertificatesScreen(
      {super.key,
      required this.certificatesList,
      this.isForPortfolio,
      this.isForEdit});

  @override
  State<AddEditCertificatesScreen> createState() =>
      _AddEditCertificatesScreenState();
}

class _AddEditCertificatesScreenState extends State<AddEditCertificatesScreen>
    with AppBarMixin {
  @override
  void initState() {
    super.initState();
    printf(widget.isForPortfolio.toString());
    printf("isEdit-----${widget.isForEdit.toString()}");
    context.read<AddEditCertificatesCubit>().isForPortfolio =
        widget.isForPortfolio?.toLowerCase() == 'true';
    context.read<AddEditCertificatesCubit>().isForEdit =
        widget.isForEdit?.toLowerCase() == 'true';
    context.read<AddEditCertificatesCubit>().certificatesList.clear();
    if (widget.certificatesList.isEmpty) {
      context.read<FilePickerCubit>().attachmentList.clear();
    }
    context
        .read<AddEditCertificatesCubit>()
        .getData(context, widget.certificatesList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddEditCertificatesCubit, AddEditCertificatesState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
              appBar: buildAppBar(
                  title: widget.isForPortfolio.toString() == "true"
                      ? appStrings(context).lblPortfolio
                      : appStrings(context).lblCertificates,
                  context: context,
                  onBackTap: () {
                    context.read<AddEditCertificatesCubit>().certificatesList =
                        [];
                    context.pop();
                  },
                  requireLeading: true),
              bottomNavigationBar: BlocBuilder<AddEditCertificatesCubit,
                      AddEditCertificatesState>(
                  builder: (context, state) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UIComponent.bottomSheetWithButtonWithGradient(
                              context: context,
                              onTap: () {
                                onSaveClick(context);
                              },
                              buttonTitle: appStrings(context).save),
                        ],
                      )),
              body: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Upload Documents widget
                            ///
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    widget.isForPortfolio.toString() == "true"
                                        ? appStrings(context).lblPortfolio
                                        : appStrings(context).lblCertificates,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            color: AppColors.black3D
                                                .forLightMode(context))),
                                8.verticalSpace,
                                BlocProvider(
                                  create: (BuildContext context) =>
                                      FilePickerCubit(),
                                  child: BlocConsumer<FilePickerCubit,
                                          FilePickerState>(
                                      bloc: context.read<FilePickerCubit>(),
                                      listener: (context, state) {
                                        if (state is FilesPickedState) {
                                          final imageList = state.files
                                              .map((e) => e.path)
                                              .toList();
                                          context
                                              .read<AddEditCertificatesCubit>()
                                              .updateAttachments(
                                                  imageList, context);
                                        }
                                        if (state is FilesRemovedState) {
                                          final imageList = context
                                              .read<AddEditCertificatesCubit>()
                                              .certificatesList;
                                          context
                                              .read<AddEditCertificatesCubit>()
                                              .updateAttachments(
                                                  imageList, context);
                                        }
                                      },
                                      builder: (_, state) {
                                        return FilePickerWidget(
                                          key: UniqueKey(),
                                          fileList: context
                                              .read<AddEditCertificatesCubit>()
                                              .certificatesList,
                                          isEdit: true,
                                          isImageTypeOnly: false,
                                          isProfileImageSelection: false,
                                          isNoDataPlaceHolderNeeded: true,
                                          maxUploadVal: 10,
                                          isDocument: false,
                                        );
                                      }),
                                ),
                              ],
                            ),
                            12.verticalSpace,
                          ],
                        ),
                      ),
                    ]),
              ));
        });
  }

  /// Build bloc listener widget.
  void buildBlocListener(BuildContext context, AddEditCertificatesState state) {
    if (state is AddEditCertificatesLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is AddEditCertificatesSuccess) {
      OverlayLoadingProgress.stop();
      context.pop();
    } else if (state is AddEditCertificatesFailure) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(context: context, message: state.message);
    }
  }

  Future<void> onSaveClick(BuildContext context) async {
    if (widget.isForEdit?.toLowerCase() != 'true') {
      if (/*context
          .read<AddEditCertificatesCubit>()
          .certificatesList
          .isNotEmpty && */
          validate(context)) {
        context.read<AddEditCertificatesCubit>().updateDocumentsAPI(context);
      }
    } else {
      context.read<AddEditCertificatesCubit>().updateDocumentsAPI(context);
    }
  }

  /// Method validation
  ///
  bool validate(BuildContext context) {
    AddEditCertificatesCubit cubit = context.read<AddEditCertificatesCubit>();

    if (cubit.certificatesList.isEmpty) {
      Utils.showErrorMessage(
          context: context,
          message: cubit.isForPortfolio
              ? appStrings(context).portfolioEmptyErrorMsg
              : appStrings(context).certificateEmptyErrorMsg);
      return false;
    }
    return true;
  }
}
