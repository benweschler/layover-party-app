import 'package:flutter/material.dart';

enum ThemeType { light, dark }

class AppColors extends ThemeExtension<AppColors> {
  static const _primaryOrange = Color(0xFFE46565);
  static const _secondaryBlue = Color(0xFF083E64);

  final Color primary;
  final Color secondary;
  final Color scaffoldBackgroundColor;
  final Color dividerColor;
  final bool isDark;

  const AppColors._({
    required this.primary,
    required this.secondary,
    required this.scaffoldBackgroundColor,
    required this.dividerColor,
    required this.isDark,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppColors._(
          primary: _primaryOrange,
          secondary: _secondaryBlue,
          scaffoldBackgroundColor: Colors.white,
          dividerColor: Colors.black.withOpacity(0.1),
          isDark: false,
        );
      case ThemeType.dark:
        return AppColors._(
          primary: _primaryOrange,
          secondary: _secondaryBlue,
          scaffoldBackgroundColor: Colors.black,
          dividerColor: Colors.white.withOpacity(0.5),
          isDark: true,
        );
    }
  }

  ThemeData toThemeData() {
    final themeData = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
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
    Color? scaffoldBackgroundColor,
    Color? dividerColor,
    bool? isDark,
  }) {
    return AppColors._(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
      dividerColor: dividerColor ?? this.dividerColor,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      scaffoldBackgroundColor: Color.lerp(scaffoldBackgroundColor, other.scaffoldBackgroundColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
