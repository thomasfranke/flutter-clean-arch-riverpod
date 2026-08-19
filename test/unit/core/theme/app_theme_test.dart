import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/theme/app_colors.dart';
import 'package:flutter_clean_arch_riverpod/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('dark is a dark theme built on the terminal palette', () {
      final ThemeData theme = AppTheme().dark;

      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.primaryColor, AppColors.primary);
      expect(theme.colorScheme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.onPrimary, AppColors.background);
      expect(theme.colorScheme.secondary, AppColors.primary);
      expect(theme.colorScheme.onSecondary, AppColors.background);
      expect(theme.colorScheme.surface, AppColors.surface);
      expect(theme.colorScheme.onSurface, AppColors.textPrimary);
      expect(theme.colorScheme.error, AppColors.negative);
      expect(theme.colorScheme.onError, AppColors.textPrimary);
    });

    test('light is a light theme keeping the same accent colors', () {
      final ThemeData theme = AppTheme().light;

      expect(theme.brightness, Brightness.light);
      expect(theme.primaryColor, AppColors.primary);
      expect(theme.colorScheme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.primary);
      expect(theme.colorScheme.surface, Colors.grey.shade50);
      expect(theme.colorScheme.onSurface, const Color(0xFF1A1A2E));
      expect(theme.colorScheme.error, AppColors.negative);
    });

    test('dark and light are distinct themes', () {
      final AppTheme appTheme = AppTheme();

      expect(appTheme.dark.brightness, isNot(appTheme.light.brightness));
      expect(
        appTheme.dark.colorScheme.surface,
        isNot(appTheme.light.colorScheme.surface),
      );
    });
  });

  group('AppColors', () {
    test('positive and negative are distinguishable price-movement colors', () {
      expect(AppColors.positive, isNot(AppColors.negative));
      expect(AppColors.positive, AppColors.primary);
    });

    test('muted variants are transparent versions of their base color', () {
      expect(AppColors.primaryMuted.a, lessThan(AppColors.primary.a));
      expect(AppColors.positiveMuted.a, lessThan(AppColors.positive.a));
      expect(AppColors.negativeMuted.a, lessThan(AppColors.negative.a));
    });

    test('the text ramp goes from brightest to dimmest', () {
      expect(
        AppColors.textPrimary.computeLuminance(),
        greaterThan(AppColors.textSecondary.computeLuminance()),
      );
      expect(
        AppColors.textSecondary.computeLuminance(),
        greaterThan(AppColors.textDisabled.computeLuminance()),
      );
    });
  });
}
