import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:peace/core/theme/theme_manager.dart';
import 'package:peace/screens/tabs/about_tab.dart';
import 'package:peace/screens/tabs/questionnaires_info_tab.dart';
import 'package:peace/services/firestore_service.dart';
import 'package:peace/services/user_profile_service.dart';
import 'package:peace/screens/auth/phone_login_screen.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          // Header
          Container(
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: height * 0.04,
                  ),
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 10),

                  // General Section
                  _buildSectionHeader('General', height, context),
                  _buildSettingsCard(context, height, [
                    _buildSettingTile(
                      context,
                      height,
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'App information and version',
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.of(context, rootNavigator: false).push(
                          CupertinoPageRoute<bool>(
                            fullscreenDialog: false,
                            builder: (BuildContext context) => AboutPage(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      context,
                      height,
                      icon: Icons.assessment_outlined,
                      title: 'Assessment Tools',
                      subtitle: 'Learn about our questionnaires',
                      iconColor: Colors.teal,
                      onTap: () {
                        Navigator.of(context, rootNavigator: false).push(
                          CupertinoPageRoute<bool>(
                            fullscreenDialog: false,
                            builder: (BuildContext context) =>
                                QuestionnairesInfoPage(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      context,
                      height,
                      icon: Icons.help_outline,
                      title: 'Help & FAQ',
                      subtitle: 'Get help and answers',
                      iconColor: Colors.green,
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      context,
                      height,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'How we handle your data',
                      iconColor: Colors.brown,
                      onTap: () async {
                        final uri = Uri.parse(
                          'https://gowthamaanp.github.io/peace/privacy-policy.html',
                        );
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ]),

                  SizedBox(height: 20),

                  // Appearance Section
                  _buildSectionHeader('Appearance', height, context),
                  _buildSettingsCard(context, height, [
                    _buildSettingTile(
                      context,
                      height,
                      icon: Icons.palette_outlined,
                      title: 'Theme',
                      subtitle: 'Choose your preferred theme',
                      iconColor: Colors.indigo,
                      onTap: () {
                        _showThemeDialog(context, height);
                      },
                    ),
                  ]),

                  SizedBox(height: 20),

                  // Account Section
                  _buildSectionHeader('Account', height, context),
                  _buildSettingsCard(context, height, [
                    _buildSettingTile(
                      context,
                      height,
                      icon: Icons.logout,
                      title: 'Logout',
                      subtitle: 'Sign out of your account',
                      iconColor: Colors.purple,
                      onTap: () {
                        _showLogoutDialog(context, height);
                      },
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      context,
                      height,
                      icon: Icons.delete_forever_outlined,
                      title: 'Delete Account',
                      subtitle: 'Permanently delete your account',
                      iconColor: Colors.red,
                      onTap: () {
                        _showDeleteAccountDialog(context, height);
                      },
                    ),
                  ]),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    double height,
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: height * 0.022,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    double height,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    double height, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: height * 0.03),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: height * 0.018,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Divider(height: 1, color: theme.dividerColor),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, double height) {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.palette_outlined,
                color: Colors.indigo,
                size: height * 0.035,
              ),
              SizedBox(width: 10),
              Text('Choose Theme', style: TextStyle(fontSize: height * 0.03)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(
                dialogContext,
                height,
                icon: Icons.light_mode,
                title: 'Light',
                subtitle: 'Bright and clear',
                iconColor: Colors.orange,
                isSelected: themeManager.isLightMode,
                onTap: () async {
                  await themeManager.setThemeMode(ThemeMode.light);
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Light theme selected'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              _buildThemeOption(
                dialogContext,
                height,
                icon: Icons.dark_mode,
                title: 'Dark',
                subtitle: 'Easy on the eyes',
                iconColor: Colors.indigo,
                isSelected: themeManager.isDarkMode,
                onTap: () async {
                  await themeManager.setThemeMode(ThemeMode.dark);
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dark theme selected'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              _buildThemeOption(
                dialogContext,
                height,
                icon: Icons.brightness_auto,
                title: 'System Default',
                subtitle: 'Follow device settings',
                iconColor: Colors.blue,
                isSelected: themeManager.isSystemMode,
                onTap: () async {
                  await themeManager.setThemeMode(ThemeMode.system);
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('System theme selected'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: height * 0.024,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    double height, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? iconColor : theme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? iconColor.withValues(alpha: 0.05) : null,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: height * 0.03),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: height * 0.024,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: height * 0.018,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: iconColor, size: height * 0.03)
              else
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: height * 0.025,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, double height) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.purple, size: height * 0.035),
              SizedBox(width: 10),
              Text('Logout', style: TextStyle(fontSize: height * 0.03)),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: height * 0.022),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: height * 0.02,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Sign out from Firebase
                await auth.FirebaseAuth.instance.signOut();

                if (!context.mounted) return;

                // Close dialog
                Navigator.pop(context);

                // Navigate to login screen
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: false,
                    builder: (BuildContext context) => PhoneLoginScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showReauthRequiredDialog(
    BuildContext context,
    double height,
    String message,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Sign in again',
            style: TextStyle(fontSize: height * 0.028),
          ),
          content: Text(message, style: TextStyle(fontSize: height * 0.02)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(fontSize: height * 0.02)),
            ),
            ElevatedButton(
              onPressed: () async {
                await auth.FirebaseAuth.instance.signOut();
                UserProfileService().clearUserProfile();
                if (!dialogContext.mounted) return;
                Navigator.of(
                  dialogContext,
                  rootNavigator: true,
                ).pushAndRemoveUntil(
                  CupertinoPageRoute<bool>(
                    builder: (BuildContext context) => PhoneLoginScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                'Sign in again',
                style: TextStyle(fontSize: height * 0.02),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context, double height) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: height * 0.035,
              ),
              SizedBox(width: 10),
              Text(
                'Delete Account',
                style: TextStyle(fontSize: height * 0.03, color: Colors.red),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'This action cannot be undone. All your data including:',
                style: TextStyle(
                  fontSize: height * 0.02,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 10),
              _buildDeleteItem('Mood entries and streaks', height, context),
              _buildDeleteItem('Test results and history', height, context),
              _buildDeleteItem(
                'Profile and emergency contact details',
                height,
                context,
              ),
              _buildDeleteItem('Appointments and records', height, context),
              _buildDeleteItem('Your phone number sign-in', height, context),
              SizedBox(height: 10),
              Text(
                'will be permanently deleted.',
                style: TextStyle(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: height * 0.02,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final currentUser = auth.FirebaseAuth.instance.currentUser;
                  if (currentUser == null) {
                    throw Exception('No user logged in');
                  }

                  // Firebase only deletes the sign-in record after a recent
                  // sign-in, so confirm identity before deleting any data.
                  final lastSignIn = currentUser.metadata.lastSignInTime;
                  if (lastSignIn == null ||
                      DateTime.now().difference(lastSignIn) >
                          const Duration(minutes: 4)) {
                    _showReauthRequiredDialog(
                      context,
                      height,
                      'For your security, please sign in again to confirm it\'s you, then delete your account from Settings.',
                    );
                    return;
                  }

                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text(
                              'Deleting your account...',
                              style: TextStyle(fontSize: height * 0.02),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  // Delete user data from Firestore
                  final firestoreService = FirestoreService();
                  final deleteResult = await firestoreService.deleteUserData(
                    uid: currentUser.uid,
                  );

                  if (deleteResult != 'SUCCESS') {
                    throw Exception(
                      'Failed to delete user data: $deleteResult',
                    );
                  }

                  // Clear local user data
                  final profileService = UserProfileService();
                  profileService.clearUserProfile();

                  // Delete Firebase Auth account
                  await currentUser.delete();

                  if (!context.mounted) return;

                  // Close loading dialog
                  Navigator.pop(context);

                  // Close delete confirmation dialog
                  Navigator.pop(context);

                  // Navigate to login screen
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    CupertinoPageRoute<bool>(
                      fullscreenDialog: false,
                      builder: (BuildContext context) => PhoneLoginScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );

                  // Show success message on login screen
                  Future.delayed(Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text('Account deleted successfully'),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.red.shade700,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  });
                } on auth.FirebaseAuthException catch (e) {
                  if (!context.mounted) return;

                  // Close loading dialog if open
                  Navigator.pop(context);

                  if (e.code == 'requires-recent-login') {
                    _showReauthRequiredDialog(
                      context,
                      height,
                      'Your data has been deleted. To finish removing your phone number, sign in again and tap Delete Account once more.',
                    );
                    return;
                  }

                  const errorMessage =
                      'Error deleting account. Please try again later.';

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'OK',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  // Close loading dialog if open
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting account: ${e.toString()}'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'OK',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeleteItem(String text, double height, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(Icons.cancel, color: Colors.red, size: height * 0.022),
          SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: height * 0.02)),
          ),
        ],
      ),
    );
  }
}
