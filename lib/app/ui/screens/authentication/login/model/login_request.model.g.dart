// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      contactNumber: json['contactNumber'] as String?,
      phoneCode: json['phoneCode'] as String?,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'contactNumber': instance.contactNumber,
      'phoneCode': instance.phoneCode,
    };
