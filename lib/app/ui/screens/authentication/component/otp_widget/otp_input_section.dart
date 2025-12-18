import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/resources/text_styles.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/input_formatters.dart';
import 'bloc/otp_input_section_cubit.dart';

class OTPInput extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const OTPInput({super.key, required this.formKey});

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  @override
  void initState() {
    context.read<OtpInputSectionCubit>().getData(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 72,
      height: 60,
      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
            color: AppColors.greyE9.adaptiveColor(context,
                lightModeColor: AppColors.greyE9,
                darkModeColor: AppColors.black2E),
            width: 1),
        // Border color
        borderRadius: BorderRadius.circular(25),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.red00, width: 1),
      ),
    );

    final focusPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.colorPrimary, width: 1),
      ),
    );
    OtpInputSectionCubit cubit = context.read<OtpInputSectionCubit>();
    return BlocConsumer<OtpInputSectionCubit, OtpInputSectionState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Column(
            children: [
              Center(
                  child: Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 4,
                  controller: cubit.controller,
                  focusNode: cubit.focusNode,
                  defaultPinTheme: defaultPinTheme,
                  inputFormatters: [
                    InputFormatters().numberInputFormatterWithoutDot,
                  ],
                  obscureText: false,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return appStrings(context).emptyOTPError ??
                          ""; // Show this message if the OTP field is empty
                    }
                    if (val.length != 4) {
                      return appStrings(context).otpLengthError ??
                          ""; // Show this message if the OTP length is not 4
                    }
                    return null;
                  },
                  separatorBuilder: (index) => const SizedBox(width: 16),
                  onCompleted: (pin) {
                    printf(pin);
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  focusedPinTheme: focusPinTheme,
                  errorPinTheme: errorPinTheme,
                  showCursor: true,
                  // cursor: cursor,
                ),
              )),
              14.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: cubit.start.toString() != "0",
                    child: Text(
                      "${appStrings(context).textResendIn ?? ""} 00:${cubit.start}",
                      style: h14(
                          fontWeight: FontWeight.w400, color: AppColors.grey8A),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  /// Build bloc listener widget.
  void buildBlocListener(BuildContext context, OtpInputSectionState state) {
    if (state is OtpInputSectionLoading) {
      // OverlayLoadingProgress.start(context);
    } else if (state is OtpInputSectionSuccess) {
    } else if (state is OtpInputSectionError) {
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
