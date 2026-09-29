import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peace/services/firebase_auth_service.dart';
import 'package:peace/services/user_profile_service.dart';
import 'package:peace/screens/auth/otp_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peace/screens/home_screen.dart';
import 'package:peace/screens/profile/profile_setup_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  PhoneLoginScreenState createState() => PhoneLoginScreenState();
}

class PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final UserProfileService _userProfileService = UserProfileService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate phone number
    String phoneNumber = _phoneController.text.trim();
    if (!_authService.isValidPhoneNumber(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 10-digit phone number')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String formattedPhone = _authService.formatPhoneNumber(phoneNumber);

    await _authService.sendOTP(
      phoneNumber: formattedPhone,
      onCodeSent: (message) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OTPVerificationScreen(phoneNumber: formattedPhone),
          ),
        );
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
        });
      },
      onAutoVerify: (credential) async {
        // Auto-verification successful
        User? user = await _authService.signInWithCredential(credential);
        setState(() {
          _isLoading = false;
        });

        if (user != null) {
          _handleSuccessfulLogin(user);
        }
      },
    );
  }

  void _handleSuccessfulLogin(User user) async {
    // Load user profile from Firestore
    debugPrint('Loading user profile for UID: ${user.uid}');
    bool profileLoaded = await _userProfileService.loadUserProfile();

    if (profileLoaded) {
      debugPrint('User profile loaded successfully');
    } else {
      debugPrint('Failed to load user profile or profile is empty');
    }

    // Check if profile is complete
    bool isProfileComplete = _userProfileService.isProfileComplete();
    debugPrint('Is profile complete: $isProfileComplete');

    // Navigate based on profile completeness
    if (mounted) {
      if (isProfileComplete) {
        // Profile is complete, go to home screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        // Profile is incomplete, redirect to profile setup
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.secondary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.08,
              vertical: height * 0.05,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.05),

                  // Logo
                  Container(
                    height: height * 0.25,
                    width: width * 0.55,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  // App Name
                  Text(
                    "Peace",
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  // Welcome Text
                  Text(
                    "Welcome Back",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  Text(
                    "Sign in with your phone number",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: height * 0.05),

                  // Phone Number Input
                  _buildPhoneNumberField(theme, height),

                  SizedBox(height: height * 0.04),

                  // Send OTP Button
                  _buildSendOTPButton(theme, height, width),

                  SizedBox(height: height * 0.03),

                  // Info Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Text(
                      "We'll send you a verification code to verify your phone number",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField(ThemeData theme, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Enter your 10-digit phone number',
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 12),
                Text(
                  '+91  ',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: theme.dividerColor,
                  margin: const EdgeInsets.only(right: 8),
                ),
              ],
            ),
            suffixIcon: Icon(
              Icons.phone_android,
              color: theme.colorScheme.primary,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length != 10) {
              return 'Please enter a valid 10-digit phone number';
            }
            if (!value.startsWith(RegExp(r'[6-9]'))) {
              return 'Please enter a valid Indian phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSendOTPButton(ThemeData theme, double height, double width) {
    return SizedBox(
      width: double.infinity,
      height: height * 0.065,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _sendOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                'SEND OTP',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }
}
