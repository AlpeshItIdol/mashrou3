import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/delayed_animation.dart';
import '../../../../config/resources/app_colors.dart';
import '../../../navigation/routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double? _scale;
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller!.value;
    return Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DelayedAnimation(
                delay: delayedAmount + 1000,
                child: Text(
                  "Hi There",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: color),
                ),
              ),
              DelayedAnimation(
                delay: delayedAmount + 2000,
                child: Text(
                  "I'm Reflectly",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: color),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              DelayedAnimation(
                delay: delayedAmount + 3000,
                child: Text(
                  "Your New Personal",
                  style: TextStyle(fontSize: 20.0, color: color),
                ),
              ),
              DelayedAnimation(
                delay: delayedAmount + 3000,
                child: Text(
                  "Journaling  companion",
                  style: TextStyle(fontSize: 20.0, color: color),
                ),
              ),
              const SizedBox(
                height: 100.0,
              ),
              DelayedAnimation(
                delay: delayedAmount + 4000,
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  child: Transform.scale(
                    scale: _scale,
                    child: _animatedButtonUI,
                  ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              GestureDetector(
                onTap: () {
                  context.goNamed(Routes.kAbout);
                },
                child: DelayedAnimation(
                  delay: delayedAmount + 5000,
                  child: Text(
                    "I Already have An Account",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget get _animatedButtonUI => GestureDetector(
        onTap: () {
          context.goNamed(Routes.kLoginScreen);
        },
        child: Container(
          height: 60,
          width: 270,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.white,
          ),
          child: const Center(
            child: Text(
              'Continue',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.pageBackground,
              ),
            ),
          ),
        ),
      );

  void _onTapDown(TapDownDetails details) {
    _controller?.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller?.reverse();
  }
}
