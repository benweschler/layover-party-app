// ignore_for_file: type=lint
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppUser _$$_AppUserFromJson(Map<String, dynamic> json) => _$_AppUser(
      email: json['email'] as String,
      id: json['id'] as String,
      profilePicURL: json['profilePicURL'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$_AppUserToJson(_$_AppUser instance) =>
    <String, dynamic>{
      'email': instance.email,
      'id': instance.id,
      'profilePicURL': instance.profilePicURL,
      'name': instance.name,
    };
