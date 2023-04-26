import 'package:flutter/material.dart';

enum ThemeType { light, dark }

class AppColors extends ThemeExtension<AppColors> {
  static const _primaryPurple = Color(0xFF5100B8);
  static const _secondaryPink = Color(0xFFBA26D1);

  final Color primary;
  final Color secondary;
  final errorContent = const Color(0xFFE55C45);
  //TODO: actually use in default text style
  final Color textColor;
  final Color largeSurface;
  final Color neutralContent;
  final Color dividerColor;
  final Color responsiveOverlayColor;
  final neutralOnContainer = const Color(0x99FFFFFF);
  final dividerOnContainer = const Color(0x4DFFFFFF);
  final Color cardColor;
  final bool isDark;

  const AppColors._({
    required this.primary,
    required this.secondary,
    required this.largeSurface,
    required this.textColor,
    required this.neutralContent,
    required this.dividerColor,
    required this.responsiveOverlayColor,
    required this.cardColor,
    required this.isDark,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppColors._(
          primary: _primaryPurple,
          secondary: _secondaryPink,
          textColor: Colors.black,
          largeSurface: Colors.black.withOpacity(0.04),
          neutralContent: Colors.black.withOpacity(0.5),
          dividerColor: const Color(0xFFCAC4D0),
          responsiveOverlayColor: Colors.white.withOpacity(0.5),
          cardColor: Colors.white,
          isDark: false,
        );
      case ThemeType.dark:
        return AppColors._(
          primary: _primaryPurple,
          secondary: _secondaryPink,
          textColor: Colors.white,
          largeSurface: Colors.white.withOpacity(0.04),
          neutralContent: Colors.white.withOpacity(0.5),
          dividerColor: const Color(0xFF49454F),
          responsiveOverlayColor: Colors.black.withOpacity(0.5),
          cardColor: Colors.white,
          isDark: true,
        );
    }
  }

  ThemeData toThemeData() {
    final themeData = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      dividerColor: dividerColor,
      checkboxTheme: const CheckboxThemeData(
        splashRadius: 0,
        visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity),
      ),
    ).copyWith(extensions: <ThemeExtension<dynamic>>[this]);

    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(
        primary: primary,
        secondary: secondary,
      ),
    );
  }

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? errorContent,
    Color? textColor,
    Color? largeSurface,
    Color? neutralContent,
    Color? scaffoldBackgroundColor,
    Color? dividerColor,
    Color? responsiveOverlayColor,
    Color? cardColor,
    bool? isDark,
  }) {
    return AppColors._(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      textColor: textColor ?? this.textColor,
      largeSurface: largeSurface ?? this.largeSurface,
      neutralContent: neutralContent ?? this.neutralContent,
      dividerColor: dividerColor ?? this.dividerColor,
      responsiveOverlayColor: responsiveOverlayColor ?? this.responsiveOverlayColor,
      cardColor: cardColor ?? this.cardColor,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      textColor: Color.lerp(textColor, textColor, t)!,
      largeSurface: Color.lerp(largeSurface, other.largeSurface, t)!,
      neutralContent: Color.lerp(neutralContent, other.neutralContent, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      responsiveOverlayColor: Color.lerp(responsiveOverlayColor, other.responsiveOverlayColor, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
