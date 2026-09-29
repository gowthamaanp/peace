import 'package:flutter/material.dart';

/// Helper class to manage theme switching in the app
///
/// Usage examples:
///
/// 1. Get current theme colors:
/// ```dart
/// final colors = ThemeHelper.getColors(context);
/// Container(color: colors.primary)
/// ```
///
/// 2. Check if dark mode is active:
/// ```dart
/// if (ThemeHelper.isDarkMode(context)) {
///   // Do something for dark mode
/// }
/// ```
///
/// 3. Get theme-aware colors:
/// ```dart
/// Text('Hello', style: TextStyle(color: ThemeHelper.getTextColor(context)))
/// ```
class ThemeHelper {
  /// Get the current ColorScheme from context
  static ColorScheme getColors(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  /// Check if dark mode is currently active
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get primary color for current theme
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  /// Get secondary color for current theme
  static Color getSecondaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  /// Get background color for current theme
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// Get surface color for current theme
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  /// Get text color for current theme
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  /// Get card color for current theme
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).cardTheme.color ??
        Theme.of(context).colorScheme.surface;
  }

  /// Get appropriate text style from theme
  static TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  /// Get a color that adapts to theme (light/dark variants)
  static Color getAdaptiveColor(
    BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) {
    return isDarkMode(context) ? darkColor : lightColor;
  }

  /// Get icon color for current theme
  static Color getIconColor(BuildContext context) {
    return Theme.of(context).iconTheme.color ??
        Theme.of(context).colorScheme.primary;
  }

  /// Get divider color for current theme
  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).dividerTheme.color ??
        Theme.of(context).dividerColor;
  }
}
