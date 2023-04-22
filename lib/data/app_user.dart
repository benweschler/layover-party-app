import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'app_user.freezed.dart';

part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String email,
    required String id,
    required String profilePicURL,
    required String name,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, Object?> json)
    => _$AppUserFromJson(json);
}