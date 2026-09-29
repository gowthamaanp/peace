import 'package:flutter/material.dart';

/// Theme provider for managing theme state across the app
///
/// Usage:
///
/// 1. Wrap your MaterialApp with ThemeProvider:
/// ```dart
/// void main() {
///   runApp(
///     ThemeProvider(
///       child: Peace(),
///     ),
///   );
/// }
/// ```
///
/// 2. Access theme in MaterialApp:
/// ```dart
/// MaterialApp(
///   themeMode: ThemeProvider.of(context).themeMode,
///   // ... rest of config
/// )
/// ```
///
/// 3. Toggle theme anywhere in app:
/// ```dart
/// IconButton(
///   icon: Icon(Icons.brightness_6),
///   onPressed: () => ThemeProvider.of(context).toggleTheme(),
/// )
/// ```
class ThemeProvider extends StatefulWidget {
  final Widget child;
  final ThemeMode initialThemeMode;

  const ThemeProvider({
    super.key,
    required this.child,
    this.initialThemeMode = ThemeMode.system,
  });

  static ThemeProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<ThemeProviderState>()!;
  }

  @override
  ThemeProviderState createState() => ThemeProviderState();
}

class ThemeProviderState extends State<ThemeProvider> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  ThemeMode get themeMode => _themeMode;

  /// Toggle between light and dark theme
  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        // If system mode, switch to light
        _themeMode = ThemeMode.light;
      }
    });
  }

  /// Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  /// Set light theme
  void setLightTheme() {
    setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  void setDarkTheme() {
    setThemeMode(ThemeMode.dark);
  }

  /// Set system theme (follows device settings)
  void setSystemTheme() {
    setThemeMode(ThemeMode.system);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// A simple theme toggle button widget
///
/// Usage:
/// ```dart
/// AppBar(
///   actions: [
///     ThemeToggleButton(),
///   ],
/// )
/// ```
class ThemeToggleButton extends StatelessWidget {
  final IconData? lightIcon;
  final IconData? darkIcon;
  final IconData? systemIcon;

  const ThemeToggleButton({
    super.key,
    this.lightIcon,
    this.darkIcon,
    this.systemIcon,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final themeMode = themeProvider.themeMode;

    IconData icon;
    String tooltip;

    switch (themeMode) {
      case ThemeMode.light:
        icon = darkIcon ?? Icons.dark_mode;
        tooltip = 'Switch to Dark Mode';
        break;
      case ThemeMode.dark:
        icon = systemIcon ?? Icons.brightness_auto;
        tooltip = 'Switch to System Mode';
        break;
      case ThemeMode.system:
        icon = lightIcon ?? Icons.light_mode;
        tooltip = 'Switch to Light Mode';
        break;
    }

    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: () {
        themeProvider.toggleTheme();
      },
    );
  }
}

/// A list tile for theme selection in settings
///
/// Usage:
/// ```dart
/// ListView(
///   children: [
///     ThemeModeTile(),
///   ],
/// )
/// ```
class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final themeMode = themeProvider.themeMode;

    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: const Text('Theme'),
      subtitle: Text(_getThemeModeText(themeMode)),
      trailing: DropdownButton<ThemeMode>(
        value: themeMode,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
          DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
          DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
        ],
        onChanged: (ThemeMode? mode) {
          if (mode != null) {
            themeProvider.setThemeMode(mode);
          }
        },
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Follow system settings';
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
    }
  }
}
