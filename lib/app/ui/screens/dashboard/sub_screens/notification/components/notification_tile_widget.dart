import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../../config/resources/app_colors.dart';
import '../../../../../../../config/utils.dart';
import '../../../../../../../utils/ui_components.dart';
import '../../../../../../model/notification/notification_response_model.dart';
import '../../../../../custom_widget/my_gif_widget.dart';

class NotificationTileWidget extends StatefulWidget {
  final NotificationList notificationList;
  final Function(String notificationId) onTapNotification;

  NotificationTileWidget(
      {required this.notificationList,
      required this.onTapNotification,
      super.key});

  @override
  State<NotificationTileWidget> createState() => _NotificationTileWidgetState();
}

class _NotificationTileWidgetState extends State<NotificationTileWidget> {
  final GlobalKey stickyKey = GlobalKey();
  final ValueNotifier<double> viewHeightNotifier =
      ValueNotifier(30); // Default height
  Size? redBoxSize;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      redBoxSize = getRedBoxSize(stickyKey.currentContext!);
      _calculateHeight();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => widget.onTapNotification(widget.notificationList.sId ?? ''),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.verticalSpace,
          _buildHeadingRow(context),
          if ((widget.notificationList.notificationData?.effectiveImageUrl ??
                  "")
              .isNotEmpty)
            _buildContentImage(),
          if ((widget.notificationList.notificationImage ?? "").isEmpty)
            12.verticalSpace,
          _buildNotificationContentRow(context),
          _buildThirdTimelineRow(context)
        ],
      ),
    );
  }

  /// Build heading title row.
  Widget _buildHeadingRow(BuildContext context) => SizedBox(
        height: 40,
        child: Row(
          children: [
            UIComponent.userProfileInitialImg(
              buildContext: context,
              name: (widget.notificationList.createdBy?.firstName == null)
                  ? (widget.notificationList.createdBy?.companyName ?? "")
                      .toUpperCase()
                  : (widget.notificationList.createdBy?.firstName ?? "")
                      .toUpperCase(),
              size: const Size(40, 40),
              radius: 14,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.colorLightPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (widget.notificationList.createdBy?.firstName == null &&
                            widget.notificationList.createdBy?.lastName == null)
                        ? widget.notificationList.createdBy?.companyName ?? ""
                        : "${widget.notificationList.createdBy?.firstName ?? ""} ${widget.notificationList.createdBy?.lastName ?? ""}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Flexible(
                    child: Text(
                      Utils.getNotificationLabelFromNotificationType(context,
                          widget.notificationList.notificationType ?? ""),
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            8.horizontalSpace,
            if (!(widget.notificationList.isRead ?? false))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  appStrings(context).lblNew,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.colorSecondary.adaptiveColor(context,
                            lightModeColor: AppColors.colorSecondary,
                            darkModeColor: AppColors.goldA1),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
          ],
        ),
      );

  /// Build content image for notification.
  Widget _buildContentImage() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: ((
            widget.notificationList.notificationData?.effectiveImageUrl ?? "",
          ).toString().contains('.gif'))
              ? MyGif(
                  gifUrl: widget.notificationList.notificationData
                          ?.effectiveImageUrl ??
                      "",
                  height: 150,
                )
              : CachedNetworkImage(
                  imageUrl: widget.notificationList.notificationData
                          ?.effectiveImageUrl ??
                      "",
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.maxFinite,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 50),
                ),
        ),
      );

  Size getRedBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  void _calculateHeight() {
    final context = stickyKey.currentContext;
    if (context != null) {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final newHeight = renderBox.size.height;
        viewHeightNotifier.value = newHeight;
      }
    }
  }

  /// Build notification content row.
  Widget _buildNotificationContentRow(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: viewHeightNotifier,
      builder: (context, viewHeight, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: viewHeight,
              width: 2,
              color: AppColors.colorSecondary,
            ),
            Expanded(
              child: Padding(
                key: stickyKey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
                child: Text(
                  widget.notificationList.message ?? " ",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.black3D.adaptiveColor(context,
                            lightModeColor: AppColors.black3D,
                            darkModeColor: AppColors.greyE9),
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThirdTimelineRow(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          Utils.getTimeDifferenceWithContext(
                  context,
                  widget.notificationList.createdAt != null
                      ? DateTime.tryParse(widget.notificationList.createdAt!) ??
                          DateTime.now()
                      : DateTime.now())
              .toString(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.black3D.adaptiveColor(context,
                    lightModeColor: AppColors.black3D,
                    darkModeColor: AppColors.greyE9),
                fontWeight: FontWeight.w400,
              ),
        ),
      );
}
