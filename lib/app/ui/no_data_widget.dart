import 'package:flutter/material.dart';

import '../../../config/resources/text_styles.dart';

class NoDataWidget extends StatelessWidget {
  String title;

  NoDataWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: h16().copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
