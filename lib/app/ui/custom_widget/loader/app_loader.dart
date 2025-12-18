import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AppLoader {
  void show(BuildContext context) {
    context.loaderOverlay.show();
  }

  void hide(BuildContext context) {
    context.loaderOverlay.hide();
  }

  bool isShowing(BuildContext context) => context.loaderOverlay.visible;
}
