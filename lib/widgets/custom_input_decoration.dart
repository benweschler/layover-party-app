import 'package:flutter/material.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';

class CustomInputDecoration extends InputDecoration {
  final AppColors colors;

  CustomInputDecoration(
    this.colors, {
    bool showEmptyErrorText = false,
    super.suffix,
    super.hintText,
  }) : super(
          filled: true,
          fillColor: colors.largeSurface,
          errorStyle: TextStyles.caption.copyWith(
            color: colors.errorContent,
            fontWeight: FontWeight.w500,
            height: showEmptyErrorText ? null : 0,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: Insets.sm,
            horizontal: Insets.med,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: colors.neutralContent.withOpacity(0.2),
            ),
            borderRadius: Corners.medBorderRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: colors.textColor,
            ),
            borderRadius: Corners.medBorderRadius,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: colors.errorContent),
            borderRadius: Corners.medBorderRadius,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: colors.errorContent),
            borderRadius: Corners.medBorderRadius,
          ),
        );
}
