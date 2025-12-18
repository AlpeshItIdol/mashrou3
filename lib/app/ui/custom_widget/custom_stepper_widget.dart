import 'package:flutter/material.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/text_styles.dart';
import 'package:mashrou3/utils/extensions.dart';

class CustomStepperWidget extends StatelessWidget {
  final int currentStep;
  final bool isSixSteps;
  final bool isThreeSteps;

  const CustomStepperWidget(
      {super.key,
      required this.currentStep,
      this.isSixSteps = false,
      this.isThreeSteps = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 10.0),
      child: isSixSteps
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularContainer("1", isGold: currentStep >= 1),
                4.horizontalSpace,
                Expanded(
                  child: _buildDashedLine(isGold: currentStep > 1),
                ),
                6.horizontalSpace,
                _buildCircularContainer("2", isGold: currentStep >= 2),
                4.horizontalSpace,
                Expanded(
                  child: _buildDashedLine(isGold: currentStep > 2),
                ),
                6.horizontalSpace,
                _buildCircularContainer("3", isGold: currentStep >= 3),
                4.horizontalSpace,
                Expanded(
                  child: _buildDashedLine(isGold: currentStep > 3),
                ),
                6.horizontalSpace,
                _buildCircularContainer("4", isGold: currentStep >= 4),
                4.horizontalSpace,
                Expanded(
                  child: _buildDashedLine(isGold: currentStep > 4),
                ),
                6.horizontalSpace,
                _buildCircularContainer("5", isGold: currentStep >= 5),
              ],
            )
          : isThreeSteps
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircularContainer("1", isGold: currentStep >= 1),
                    8.horizontalSpace,
                    Expanded(
                      child: _buildDashedLine(isGold: currentStep > 1),
                    ),
                    8.horizontalSpace,
                    _buildCircularContainer("2", isGold: currentStep >= 2),
                    8.horizontalSpace,
                    Expanded(
                      child: _buildDashedLine(isGold: currentStep > 2),
                    ),
                    8.horizontalSpace,
                    _buildCircularContainer("3", isGold: currentStep >= 3),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircularContainer("1", isGold: currentStep >= 1),
                    8.horizontalSpace,
                    Expanded(
                      child: _buildDashedLine(isGold: currentStep > 1),
                    ),
                    8.horizontalSpace,
                    _buildCircularContainer("2", isGold: currentStep >= 2),
                    // 8.horizontalSpace,
                    // Expanded(
                    //   child: _buildDashedLine(isGold: currentStep > 2),
                    // ),
                    // 8.horizontalSpace,
                    // _buildCircularContainer("3", isGold: currentStep >= 3),
                  ],
                ),
    );
  }

  Widget _buildCircularContainer(String number, {required bool isGold}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isGold ? AppColors.goldA1 : AppColors.greyE8,
      ),
      child: Center(
        child: Text(
          number,
          style: h18(
            color: isGold ? AppColors.white : AppColors.grey8A,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildDashedLine({required bool isGold}) {
    return CustomPaint(
      painter: DashedLineHorizontalPainter(
          color: isGold ? AppColors.goldA1 : Colors.grey),
      child: const SizedBox(
        width: double.infinity,
        height: 1,
      ),
    );
  }
}

class DashedLineHorizontalPainter extends CustomPainter {
  final Color color;

  DashedLineHorizontalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 4, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedLineHorizontalPainter oldDelegate) =>
      oldDelegate.color != color;
}
