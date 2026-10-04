import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text.dart';

abstract final class AppTheme {
  /// Builds the theme for the active palette ([AppColors.dark]).
  static ThemeData build(Locale locale) {
    final isBn = locale.languageCode == 'bn';
    final family = isBn ? AppText.banglaDigits : AppText.latin;
    final fallback = isBn
        ? const [AppText.bangla, AppText.latin]
        : AppText.fallbackFor(family);

    final base = ThemeData(
      useMaterial3: true,
      brightness: AppColors.dark ? Brightness.dark : Brightness.light,
      fontFamily: family,
      fontFamilyFallback: fallback,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.gold,
        brightness: AppColors.dark ? Brightness.dark : Brightness.light,
        primary: AppColors.gold,
        onPrimary: AppColors.onGold,
        secondary: AppColors.ink,
        surface: AppColors.card,
        onSurface: AppColors.ink,
        error: AppColors.danger,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
        fontFamily: family,
      ),
      cardColor: AppColors.card,
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.card),
        ),
        titleTextStyle: AppText.subtitle.copyWith(fontFamily: family),
        contentTextStyle: AppText.body.copyWith(fontFamily: family),
      ),
      popupMenuTheme: PopupMenuThemeData(color: AppColors.card),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.header,
        foregroundColor: AppColors.onHeader,
        titleTextStyle: AppText.subtitle.copyWith(
          color: AppColors.onHeader,
          fontFamily: family,
        ),
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.field,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: AppText.label.copyWith(
          color: AppColors.muted,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.field),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.field),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.field),
          borderSide: BorderSide(color: AppColors.gold, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.field),
          borderSide: BorderSide(color: AppColors.danger),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.header,
        contentTextStyle: AppText.body.copyWith(
          color: AppColors.onHeader,
          fontFamily: family,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.button),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.card,
        dialHandColor: AppColors.gold,
        hourMinuteColor: AppColors.cream,
        dayPeriodColor: AppColors.goldLight.withValues(alpha: 0.4),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.card,
        headerBackgroundColor: AppColors.header,
        headerForegroundColor: AppColors.onHeader,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.gold),
    );
  }
}
