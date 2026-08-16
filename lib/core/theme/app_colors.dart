import 'package:flutter/material.dart';

/// Color palette for the application, inspired by financial terminals such as
/// Bloomberg and TradingView. Uses a dark base with green/red accents for
/// price movements.
abstract final class AppColors {
  /// --- Background ---
  /// Main background color.
  static const Color background = Color(0xFF0D1117);

  /// Surface color for cards and elevated elements.
  static const Color surface = Color(0xFF161B22);

  /// Slightly lighter surface for nested cards.
  static const Color surfaceVariant = Color(0xFF1C2128);

  /// --- Primary ---
  /// Primary brand color — financial green.
  static const Color primary = Color(0xFF00C896);

  /// Primary color with reduced opacity for backgrounds.
  static const Color primaryMuted = Color(0x1A00C896);

  /// --- Semantic ---
  /// Color for positive price movements.
  static const Color positive = Color(0xFF00C896);

  /// Muted background for positive indicators.
  static const Color positiveMuted = Color(0x1A00C896);

  /// Color for negative price movements.
  static const Color negative = Color(0xFFFF4560);

  /// Muted background for negative indicators.
  static const Color negativeMuted = Color(0x1AFF4560);

  /// --- Text ---
  /// Primary text color.
  static const Color textPrimary = Color(0xFFE6EDF3);

  /// Secondary/muted text color.
  static const Color textSecondary = Color(0xFF7D8590);

  /// Disabled text color.
  static const Color textDisabled = Color(0xFF484F58);

  /// --- Border ---
  /// Default border and divider color.
  static const Color border = Color(0xFF21262D);
}
