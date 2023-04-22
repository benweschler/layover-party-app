import 'package:flutter/material.dart';

enum ThemeType { light, dark }

class AppColors extends ThemeExtension<AppColors> {
  static const _primaryOrange = Color(0xFFE46565);
  static const _secondaryBlue = Color(0xFF083E64);

  final Color primary;
  final Color secondary;
  final Color largeSurface;
  final Color dividerColor;
  final Color tabHighlightColor;
  final Color responsiveOverlayColor;
  final bool isDark;

  const AppColors._({
    required this.primary,
    required this.secondary,
    required this.largeSurface,
    required this.dividerColor,
    required this.tabHighlightColor,
    required this.responsiveOverlayColor,
    required this.isDark,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppColors._(
          primary: _primaryOrange,
          secondary: _secondaryBlue,
          largeSurface: Colors.black.withOpacity(0.04),
          dividerColor: const Color(0xFFCAC4D0),
          tabHighlightColor: _primaryOrange.withOpacity(0.2),
          responsiveOverlayColor: Colors.white.withOpacity(0.5),
          isDark: false,
        );
      case ThemeType.dark:
        return AppColors._(
          primary: _primaryOrange,
          secondary: _secondaryBlue,
          largeSurface: Colors.white.withOpacity(0.04),
          dividerColor: const Color(0xFF49454F),
          tabHighlightColor: _primaryOrange.withOpacity(0.4),
          responsiveOverlayColor: Colors.black.withOpacity(0.5),
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
    Color? largeSurface,
    Color? scaffoldBackgroundColor,
    Color? dividerColor,
    Color? tabHighlightColor,
    Color? responsiveOverlayColor,
    bool? isDark,
  }) {
    return AppColors._(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      largeSurface: largeSurface ?? this.largeSurface,
      dividerColor: dividerColor ?? this.dividerColor,
      tabHighlightColor: tabHighlightColor ?? this.tabHighlightColor,
      responsiveOverlayColor: responsiveOverlayColor ?? this.responsiveOverlayColor,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      largeSurface: Color.lerp(largeSurface, other.largeSurface, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      tabHighlightColor: Color.lerp(tabHighlightColor, other.tabHighlightColor, t)!,
      responsiveOverlayColor: Color.lerp(responsiveOverlayColor, other.responsiveOverlayColor, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
