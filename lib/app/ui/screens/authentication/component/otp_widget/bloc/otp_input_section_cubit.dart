import 'dart:async';

import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pinput/pinput.dart';

part 'otp_input_section_state.dart';

class OtpInputSectionCubit extends Cubit<OtpInputSectionState> {
  OtpInputSectionCubit() : super(OtpInputSectionInitial());

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  PinTheme defaultPinTheme = const PinTheme();
  PinTheme errorPinTheme = const PinTheme();

  Timer? timer;
  bool isAlreadyExist = false;
  int start = 30;

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context) async {
    controller.clear();
    start =  30;
    emitTimerState();
  }

  Future<void> emitTimerState() async {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
          emit(ResetTimer());
        } else {
          start--;
          emit(TimerState(start));
        }
      },
    );
  }

  Future<void> timerReset() async {
    // emit(ResetTimer());
    start = 30;
    emitTimerState();
  }
}
