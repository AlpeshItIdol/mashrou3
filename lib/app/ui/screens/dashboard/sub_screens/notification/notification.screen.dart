import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/notification/components/notification_tile_widget.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import 'cubit/notification_cubit.dart';

class NotificationScreen extends StatefulWidget with AppBarMixin {
  NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AppBarMixin {
  @override
  void initState() {
    super.initState();

    if (mounted) {
      if (context.mounted) {
        context.read<NotificationCubit>().propertyList?.clear();
        context.read<NotificationCubit>().filteredPropertyList?.clear();
        context.read<NotificationCubit>().isFirstPageLoading = true;
        Future.delayed(
          const Duration(milliseconds: 100),
          () => context.read<NotificationCubit>().getNotificationList(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBlocConsumer,
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: buildBlocListener,
      builder: (context, state) {
        printf("state ${state.toString()}");

        if (state is NotificationLoading) {
          return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16.0),
              child: UIComponent.getSkeletonNotification());
        }
        if (state is NotificationInitial) {
          return Container();
        }

        if (context.read<NotificationCubit>().filteredPropertyList?.isEmpty ?? true) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: UIComponent.noDataWidgetWithInfo(
                title: appStrings(context).lblNoNotification,
                info: appStrings(context).lblNoNotificationContent,
                context: context,
              ),
            ),
          );
        }

        if (state is NoNotificationAvailable) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: UIComponent.noDataWidgetWithInfo(
                title: appStrings(context).lblNoNotification,
                info: appStrings(context).lblNoNotificationContent,
                context: context,
              ),
            ),
          );
        }

        bool isLoading = state is NotificationLoading;
        return _buildNotificationScrollListener(isLoading, state);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Build bloc listener widget.
  ///
  void buildBlocListener(BuildContext context, NotificationState state) {
    if (state is ReadNotificationLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is NotificationError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    } else if (state is NotificationReadSuccessFully) {
      OverlayLoadingProgress.stop();
    }
  }

  Widget _buildNotificationScrollListener(
      bool isLoading, NotificationState state) {
    final cubit = context.read<NotificationCubit>();
    return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          print(scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 20);
          if (!cubit.isLoadingMore &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 20) {
            cubit.loadMoreNotification(context);
          }
          return false;
        },
        child: Skeletonizer(
            enabled: !cubit.hasShownSkeleton &&
                (state is NotificationLoading ||
                    cubit.isLoadingMore ||
                    isLoading),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: _buildNotificationList(),
            )));
  }

  /// Build notification title.
  Widget _buildNotificationList() => ListView.separated(
        separatorBuilder: (_, index) => const Divider(
          color: AppColors.greyE8,
          height: 16,
        ),
        itemBuilder: (_, index) {
          if (context.read<NotificationCubit>().propertyList?.isEmpty ?? true) {
            return Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16, top: 0.0),
                child: UIComponent.getSkeletonNotification());
          }

          if (index ==
              context.read<NotificationCubit>().filteredPropertyList!.length) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.colorPrimary,
            ));
          }
          return NotificationTileWidget(
            notificationList:
                context.read<NotificationCubit>().propertyList![index],
            onTapNotification: (notificationId) {
              context.read<NotificationCubit>().notificationTap(
                  indexToBeUpdate: index,
                  notification: notificationId,
                  context: context);
            },
          );
        },
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        itemCount:
            (context.read<NotificationCubit>().propertyList ?? []).length,
      );
}
