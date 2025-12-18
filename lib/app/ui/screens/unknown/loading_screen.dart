import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/navigation/app_router.dart';

import '../../../../config/resources/app_colors.dart';
import '../../../../config/resources/app_values.dart';

class LoadingScreen extends StatefulWidget {
  String matchedPath;
  Uri fullURI;

  LoadingScreen({required this.matchedPath, required this.fullURI, super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  static const delay800Millis = 800;

  @override
  void initState() {
    print("initState");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      var isLoggedIn = await GetIt.I<AppPreferences>().getIsLoggedIn();
      if (isLoggedIn) {
        if (!mounted) {
          return;
        }
        AppRouter.navigateToScreen(
          context: context,
          redirectURL: widget.matchedPath,
        );
      } else {
        Future.delayed(const Duration(milliseconds: delay800Millis), () {
          AppRouter.goToSignIn();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppValues.screenWidth = MediaQuery.of(context).size.width;
    AppValues.screenHeight = MediaQuery.of(context).size.height;
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: AppColors.colorPrimary,
        ),
      ),
    );
  }
}
