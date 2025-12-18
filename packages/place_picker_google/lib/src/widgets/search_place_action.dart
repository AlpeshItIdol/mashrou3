import 'package:flutter/material.dart';

class SelectPlaceWidget extends StatelessWidget {
  /// Name of the selected place
  final String? locationName;

  /// Formatted address of the selected place
  final String? formattedAddress;

  /// Text that has to be shown on the select action button
  final String? actionText;

  /// Optional void call back of the button
  final VoidCallback? onTap;

  final TextStyle? locationNameStyle;
  final TextStyle? formattedAddressStyle;
  final Widget? actionChild;

  const SelectPlaceWidget({
    super.key,
    this.locationName,
    required this.onTap,
    this.formattedAddress,
    this.actionText,
    this.locationNameStyle,
    this.formattedAddressStyle,
    this.actionChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (locationName != null)
            Text(
              locationName!,
              style: locationNameStyle ??
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
            ),
          if (formattedAddress != null)
            Text(
              formattedAddress!,
              style: formattedAddressStyle ??
                  Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor,
                      ),
            ),
          if (actionText != null)
            const SizedBox(
              height: 12.0,
            ),
          if (actionText != null)
            Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF347278),
                      Color(0xFF1D5055),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16)),
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  // Transparent for gradient effect
                  shadowColor: Colors.transparent,
                  // Remove button shadow
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16), // Match container radius
                  ),
                ),
                child: actionChild ??
                    Text(actionText!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            height: 1.2,
                            overflow: TextOverflow.visible,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Reddit Sans Condensed")),
                // Text(actionText!,),
              ),
            ),
        ],
      ),
    );
  }
}
