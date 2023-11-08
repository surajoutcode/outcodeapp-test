import 'package:flutter/material.dart';

import '../../../common_widgets/image_widgets/app_image_view.dart';
import '../../../common_widgets/in_app_notification_view/in_app_notification_constants.dart';

import '../../../utils/app_styles.dart';
import '../../../utils/colors.dart';
import '../in_app_notification.dart';
import '../in_app_notification_handler.dart';

class InAppNotificationContent extends StatefulWidget {
  final InAppNotificationOverlay overlay;
  final InAppNotification notification;
  final Function(InAppNotificationOverlay)? onCloseClicked;
  final Function(InAppNotificationOverlay, InAppNotification)?
      onNotificationClicked;
  const InAppNotificationContent(
      {required this.overlay,
      required this.notification,
      this.onCloseClicked,
      this.onNotificationClicked,
      super.key});

  @override
  State<InAppNotificationContent> createState() =>
      _InAppNotificationContentState();
}

class _InAppNotificationContentState extends State<InAppNotificationContent> {
  bool _showsNotification = false;
  bool _hasShownNotification = false;
  Future? overlayRemoveFuture;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10)).whenComplete(() {
      setState(() {
        _showsNotification = true;
      });

      overlayRemoveFuture = Future.delayed(const Duration(
              seconds: InAppNotificationConstants.inAppNotificationDuration,
              milliseconds: 510))
          .whenComplete(() {
        _closeNotification();
      });
    });
  }

  _closeNotification() {
    setState(() {
      _showsNotification = false;
    });
    _hasShownNotification = true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: 10,
      right: 10,
      top: _showsNotification ? 50 : -100,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: AppColors.transparent,
          child: _mainContent(),
        ),
      ),
      onEnd: () {
        if (_hasShownNotification) {
          widget.onCloseClicked?.call(widget.overlay);
        }
      },
    );
  }

  Widget _mainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: InkWell(
        onTap: () {
          overlayRemoveFuture?.ignore();
          _closeNotification();
          widget.onNotificationClicked
              ?.call(widget.overlay, widget.notification);
        },
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1), // changes position of shadow
            )
          ], color: AppColors.red, borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppImageView(
                  width: 40,
                  height: 40,
                  avatarUrl: null,
                  cornerRadius: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.notification.notificationTitle,
                                style:
                                    AppStyles.boldSmall(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.notification.notificationBody,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.regularSmall(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    overlayRemoveFuture?.ignore();
                    _closeNotification();
                  },
                  iconSize: 15,
                  icon: const Icon(
                    Icons.close,
                    size: 15,
                  ),
                  color: AppColors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
