part of 'otp_input_section_cubit.dart';

abstract class OtpInputSectionState extends Equatable {
  const OtpInputSectionState();

  @override
  List<Object?> get props => [];
}

class OtpInputSectionInitial extends OtpInputSectionState {
  @override
  List<Object> get props => [];
}

class ResetTimer extends OtpInputSectionState {
  @override
  List<Object> get props => [];
}

class OtpInputSectionLoading extends OtpInputSectionState {
  @override
  List<Object> get props => [];
}

class TimerState extends OtpInputSectionState {
  final int valueStr;

  const TimerState(this.valueStr);

  @override
  List<Object> get props => [valueStr];
}

class OtpInputSectionSuccess extends OtpInputSectionState {
  @override
  List<Object> get props => [];
}

class OtpInputSectionError extends OtpInputSectionState {
  final String errorMessage;

  const OtpInputSectionError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
