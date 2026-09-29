import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peace/services/firebase_auth_service.dart';
import 'package:peace/services/user_profile_service.dart';
import 'package:peace/screens/auth/phone_login_screen.dart';
import 'package:peace/screens/home_screen.dart';
import 'package:peace/screens/profile/profile_setup_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:peace/screens/common/no_internet_connection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final UserProfileService _userProfileService = UserProfileService();

  Future<Timer> startTime() async {
    // Note: Permissions are no longer requested on app start
    // Request specific permissions only when needed in the app
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() async {
    if (!mounted) return;

    // Check internet connection
    bool hasConnection = await InternetConnectionChecker.instance.hasConnection;

    if (!mounted) return; // Check if still mounted after async call

    if (!hasConnection) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NoInternetConnection()),
      );
      return;
    }

    // Check if user is already logged in
    if (!mounted) return; // Check if still mounted

    if (_authService.isUserSignedIn()) {
      // Load user profile before navigating to home
      debugPrint('User is already signed in, loading profile...');
      bool profileLoaded = await _userProfileService.loadUserProfile();

      if (profileLoaded) {
        debugPrint('User profile loaded successfully from splash screen');
      } else {
        debugPrint('Failed to load user profile or profile is empty');
      }

      // Check if profile is complete
      bool isProfileComplete = _userProfileService.isProfileComplete();
      debugPrint('Is profile complete: $isProfileComplete');

      if (!mounted) return; // Check if still mounted after async call

      if (isProfileComplete) {
        // Profile is complete, go to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Profile is incomplete, redirect to profile setup
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PhoneLoginScreen()),
      );
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: height * 0.28,
              width: (width / 1.8),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/logo.png"),
                ),
              ),
            ),
            Text(
              "Peace",
              style: TextStyle(
                fontSize: height * 0.05,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
