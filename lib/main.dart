import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/config/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_manager.dart';
import 'screens/common/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeManager(), child: const Peace()),
  );
}

class Peace extends StatelessWidget {
  const Peace({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return SafeArea(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Peace',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeManager.themeMode,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
