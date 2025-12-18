import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/text_styles.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    super.key,
    this.fieldName,
    this.fieldHint,
    required this.controller,
    this.focusNode,
    this.suffixIcon,
    this.prefixText,
    this.obscureText,
    required this.isMandatory,
    this.isDisable,
    required this.keyboardType,
    this.textInputAction,
    this.readOnly,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.maxLines = 1,
    this.minLines = 1,
    this.isShowFieldName = true,
    this.isShowFieldMetric = false,
    this.isShowPrefixText = false,
    this.fieldMetricValue = '',
    this.isRoundedBorderWithColor = false,
    this.fillColor,
    this.textColor,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.maxLength,
    this.isMaxLengthRequired = false,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? fieldName;
  final String? fieldHint;
  final Widget? suffixIcon;
  final String? prefixText;
  final bool? obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final bool isMandatory;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final bool? readOnly;
  final bool? isDisable;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int minLines;
  final int? maxLength;
  final bool isMaxLengthRequired;
  final bool? isShowFieldName;
  final bool? isShowFieldMetric;
  final bool? isShowPrefixText;
  final String? fieldMetricValue;
  final bool? isRoundedBorderWithColor;
  final Color? fillColor;
  final Color? textColor;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool _passwordVisible = false;

  // String prefixText = "+962 ";

  @override
  void initState() {
    _passwordVisible = widget.obscureText ?? false;
    // prefixText = widget.prefixText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isShowFieldName == true
            ? RichText(
                text: TextSpan(
                    text: widget.fieldName ?? "",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.black3D.adaptiveColor(context,
                            lightModeColor: AppColors.black3D,
                            darkModeColor: AppColors.greyB0)),
                    children: [
                    widget.isShowFieldMetric == true
                        ? TextSpan(
                            text: ' (${widget.fieldMetricValue})',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color:AppColors.black3D.adaptiveColor(context,
                                        lightModeColor: AppColors.black3D,
                                        darkModeColor: AppColors.greyB0)))
                        : const TextSpan(
                            text: '',
                          ),
                    widget.isMandatory == false
                        ? const TextSpan(
                            text: '',
                          )
                        : TextSpan(
                            text: ' *',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black3D.adaptiveColor(context,
                                        lightModeColor: AppColors.black3D,
                                        darkModeColor: AppColors.greyB0)))
                  ]))
            : Container(),
        5.verticalSpace,
        TextFormField(
            controller: widget.controller,
            cursorColor: AppColors.colorPrimary.forLightMode(context),
            style: widget.isRoundedBorderWithColor == true
                ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.textColor ?? Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500)
                : Theme.of(context).textTheme.bodyMedium,
            textInputAction: widget.textInputAction ?? null,
            onFieldSubmitted: widget.onFieldSubmitted,
            focusNode: widget.focusNode,
            inputFormatters: widget.inputFormatters ?? [],
            obscureText: widget.obscureText == true ? _passwordVisible : false,
            readOnly: widget.readOnly ?? false,
            enabled: widget.isDisable != null ? !widget.isDisable! : true,
            keyboardType: widget.keyboardType,
            onTap: widget.onTap,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: null, // Removed character limit
            textAlign: widget.textAlign!,
            validator: (String? value) {
              if (widget.isDisable ?? false) {
                return null;
              } else {
                return widget.validator!(value);
              }
            },
            onChanged: widget.onChanged,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              fillColor: widget.isRoundedBorderWithColor == true
                  ? widget.fillColor
                  : Colors.transparent,
              filled: widget.isRoundedBorderWithColor == true ? true : false,
              contentPadding: const EdgeInsetsDirectional.symmetric(
                  vertical: 18.0, horizontal: 16.0),
              floatingLabelBehavior:
                  widget.readOnly == true && widget.controller.text.isEmpty
                      ? FloatingLabelBehavior.never
                      : FloatingLabelBehavior.auto,
              hintText: widget.fieldHint ?? "",
              hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.grey77, fontWeight: FontWeight.w400),
              suffixIconConstraints:
                  const BoxConstraints(maxHeight: 100, maxWidth: 100),
              prefixIconConstraints:
                  const BoxConstraints(maxHeight: 100, maxWidth: 100),
              // prefixIcon: ,
              prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 14.0,
                  end: 8.0,
                ),
                child: Text(
                  widget.isShowPrefixText == true
                      ? (widget.prefixText?.startsWith('+') == true
                          ? widget.prefixText ?? ""
                          : "+${widget.prefixText ?? ""}")
                      : "",
                  style: h14().copyWith(
                    color: AppColors.grey77.adaptiveColor(context,
                        lightModeColor: AppColors.grey77,
                        darkModeColor: AppColors.greyB0),
                  ),
                ),
              ),
              suffixIcon: UIComponent.customInkWellWidget(
                onTap: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 13.0),
                  child: widget.obscureText == true
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: _passwordVisible
                              ? SVGAssets.visibilityOffIcon
                                  .toSvg(context: context)
                              : SVGAssets.visibilityOnIcon
                                  .toSvg(context: context))
                      : widget.suffixIcon,
                ),
              ),
              errorMaxLines: 3,
              border: OutlineInputBorder(
                borderRadius: widget.isRoundedBorderWithColor == true
                    ? BorderRadius.circular(54)
                    : BorderRadius.circular(16),
                borderSide: BorderSide(
                    color: widget.isRoundedBorderWithColor == true
                        ? Colors.transparent
                        : AppColors.greyE9.adaptiveColor(context,
                            lightModeColor: AppColors.greyE9,
                            darkModeColor: AppColors.black2E),
                    width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.isRoundedBorderWithColor == true
                    ? BorderRadius.circular(54)
                    : BorderRadius.circular(16),
                borderSide: BorderSide(
                    color: widget.isRoundedBorderWithColor == true
                        ? Colors.transparent
                        : AppColors.greyE9.adaptiveColor(context,
                            lightModeColor: AppColors.greyE9,
                            darkModeColor: AppColors.black2E),
                    width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.isRoundedBorderWithColor == true
                    ? BorderRadius.circular(54)
                    : BorderRadius.circular(16),
                borderSide: BorderSide(
                    color: widget.isRoundedBorderWithColor == true
                        ? Colors.transparent
                        : AppColors.greyE9.adaptiveColor(context,
                            lightModeColor: AppColors.greyE9,
                            darkModeColor: AppColors.black2E),
                    width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: widget.isRoundedBorderWithColor == true
                    ? BorderRadius.circular(54)
                    : BorderRadius.circular(16),
                borderSide: BorderSide(
                    color: widget.isRoundedBorderWithColor == true
                        ? Colors.transparent
                        : AppColors.errorColor,
                    width: 1),
              ),
            )),
      ],
    );
  }
}
