import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

class SearchTextFormField extends StatefulWidget {
  const SearchTextFormField(
      {super.key,
      this.fieldName,
      this.fieldHint,
      required this.controller,
      this.focusNode,
      this.suffixIcon,
      this.prefixIcon,
      required this.keyboardType,
      this.textInputAction,
      this.onTap,
      this.onChanged,
      this.onSubmitted,
      this.onFieldSubmitted,
      this.functionSuffix,
      this.maxLines = 1,
      this.minLines = 1,
      this.isShowFieldName = true,
      this.showSuffixIcon = false,
      this.readOnly = false,
      this.isDense = false,
      this.inputFormatters});

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? fieldName;
  final String? fieldHint;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final bool? readOnly;
  final bool? isDense;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final Function()? functionSuffix;

  // final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final int? maxLines;
  final int minLines;
  final bool showSuffixIcon;
  final bool? isShowFieldName;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<SearchTextFormField> createState() => _SearchFormFieldState();
}

class _SearchFormFieldState extends State<SearchTextFormField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: AppColors.colorPrimary,
      style: Theme.of(context).textTheme.bodyMedium,
      textInputAction: widget.textInputAction ?? TextInputAction.search,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatters ?? [],
      keyboardType: widget.keyboardType,
      onTap: widget.onTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      readOnly: widget.readOnly ?? false,
      onChanged: (value) => widget.onChanged!(value),
      onFieldSubmitted: (value) => widget.onSubmitted!(value),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        isDense: widget.isDense,
        suffixIcon: widget.showSuffixIcon
            ? UIComponent.customInkWellWidget(
                onTap: widget.functionSuffix ?? () {},
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 13.0),
                  child: widget.suffixIcon,
                ),
              )
            : const SizedBox(),
        suffixIconConstraints: const BoxConstraints(
            minHeight: 16, minWidth: 16, maxHeight: 100, maxWidth: 100),
        prefixIconConstraints:
            const BoxConstraints(maxHeight: 100, maxWidth: 100),
        prefixIcon: UIComponent.customInkWellWidget(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8.0, end: 4),
            child: widget.prefixIcon,
          ),
        ),
        hintText: widget.fieldHint,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w400),
        contentPadding: const EdgeInsetsDirectional.symmetric(
            vertical: 18.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: AppColors.greyE8.adaptiveColor(context,
                  lightModeColor: AppColors.greyE8,
                  darkModeColor: AppColors.black2E),
              width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: AppColors.greyE8.adaptiveColor(context,
                  lightModeColor: AppColors.greyE8,
                  darkModeColor: AppColors.black2E),
              width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: AppColors.greyE8.adaptiveColor(context,
                  lightModeColor: AppColors.greyE8,
                  darkModeColor: AppColors.black2E),
              width: 1),
        ),
      ),
      // TextStyle(color: AppColors.labelColor,)),
    );
  }
}
