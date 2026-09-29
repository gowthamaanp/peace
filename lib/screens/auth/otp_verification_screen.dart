import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:peace/services/firebase_auth_service.dart';
import 'package:peace/services/user_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peace/screens/home_screen.dart';
import 'package:peace/screens/profile/profile_setup_screen.dart';
import 'dart:async';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});

  @override
  OTPVerificationScreenState createState() => OTPVerificationScreenState();
}

class OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final UserProfileService _userProfileService = UserProfileService();
  final FocusNode _otpFocusNode = FocusNode();

  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto-focus on OTP field
    Future.delayed(const Duration(milliseconds: 500), () {
      _otpFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _verifyOTP() async {
    String otpCode = _otpController.text.trim();

    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    User? user = await _authService.verifyOTP(
      otpCode: otpCode,
      onError: (error) {
        setState(() {
          _isLoading = false;
        });
        debugPrint("OTP Verification Error: $error");
      },
    );

    debugPrint("Verified User: $user");

    if (user != null) {
      // Check if user profile exists
      bool userExists = await _authService.checkUserExists(user.uid);

      if (!userExists) {
        // Create user profile
        await _authService.createUserProfile(
          uid: user.uid,
          phoneNumber: widget.phoneNumber,
        );
      } else {
        // Update last login
        await _authService.updateLastLogin(user.uid);
      }
      setState(() {
        _isLoading = false;
      });

      _handleSuccessfulLogin(user);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
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

  void _resendOTP() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
    });

    await _authService.sendOTP(
      phoneNumber: widget.phoneNumber,
      onCodeSent: (message) {
        setState(() {
          _isLoading = false;
        });
        _startResendTimer();
        _otpController.clear();
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      },
      onAutoVerify: (credential) async {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // Pinput theme
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.08,
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.02),

              // Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sms_outlined,
                  size: 60,
                  color: theme.colorScheme.primary,
                ),
              ),

              SizedBox(height: height * 0.03),

              // Title
              Text(
                "Verification Code",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: height * 0.015),

              // Subtitle
              Text(
                "We've sent a 6-digit code to",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),

              SizedBox(height: height * 0.005),

              // Phone Number
              Text(
                widget.phoneNumber,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),

              SizedBox(height: height * 0.04),

              // OTP Input
              Pinput(
                controller: _otpController,
                focusNode: _otpFocusNode,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                // onCompleted: (pin) {
                //   // Auto-verify when all digits are entered
                //   _verifyOTP();
                // },
              ),

              SizedBox(height: height * 0.04),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: height * 0.065,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
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
                          'VERIFY OTP',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),

              SizedBox(height: height * 0.03),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  TextButton(
                    onPressed: _canResend ? _resendOTP : null,
                    child: Text(
                      _canResend ? 'Resend' : 'Resend in ${_resendTimer}s',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _canResend
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
