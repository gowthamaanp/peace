import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                  'About Peace',
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
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(height: 10),

                  // App Logo & Name Card
                  _buildAppInfoCard(context, height),

                  SizedBox(height: 15),

                  // Description Card
                  _buildDescriptionCard(context, height),

                  SizedBox(height: 15),

                  // Features Card
                  _buildFeaturesCard(context, height),

                  SizedBox(height: 15),

                  // Developer Card
                  _buildDeveloperCard(context, height),

                  SizedBox(height: 15),

                  // Contact Card
                  _buildContactCard(context, height),

                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard(BuildContext context, double height) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // App Icon
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.favorite,
              size: height * 0.05,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),

          // App Name
          Text(
            'Peace',
            style: TextStyle(
              fontSize: height * 0.04,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 5),

          // Tagline
          Text(
            'Mental Health Companion',
            style: TextStyle(
              fontSize: height * 0.022,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 10),

          // Version Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Version 1.1.0',
              style: TextStyle(
                fontSize: height * 0.02,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context, double height) {
    final theme = Theme.of(context);

    return _buildCard(
      context,
      height,
      icon: Icons.info_outline,
      iconColor: Colors.blue,
      title: 'About the App',
      child: Text(
        'Peace is a comprehensive mental health and well-being application designed to support individuals in their journey toward better mental health. '
        'Originally developed at Puducherry Technological University, Peace has evolved to serve the general public, providing accessible mental health resources and tracking tools for everyone.\n\n'
        'Our mission is to make mental health support accessible, convenient, and stigma-free. Whether you\'re dealing with stress, anxiety, or simply want to maintain good mental health, Peace is here to help.\n\n'
        'This preliminary screening tool is designed based on established medical standards to help track mental health patterns. '
        'Please note that Peace is not intended for clinical diagnosis and should not replace professional mental health services.',
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: height * 0.02,
          height: 1.5,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildFeaturesCard(BuildContext context, double height) {
    return _buildCard(
      context,
      height,
      icon: Icons.stars_rounded,
      iconColor: Colors.amber,
      title: 'Key Features',
      child: Column(
        children: [
          _buildFeatureItem(
            context,
            height,
            '🧠',
            'Mental Health Assessments',
            'Evidence-based screening tools',
          ),
          SizedBox(height: 12),
          _buildFeatureItem(
            context,
            height,
            '📊',
            'Progress Tracking',
            'Monitor your well-being over time',
          ),
          SizedBox(height: 12),
          _buildFeatureItem(
            context,
            height,
            '👨‍⚕️',
            'Counselor Support',
            'Connect with professional help',
          ),
          SizedBox(height: 12),
          _buildFeatureItem(
            context,
            height,
            '🔒',
            'Privacy First',
            'Your data is secure and confidential',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    double height,
    String emoji,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: TextStyle(fontSize: height * 0.028)),
        SizedBox(width: 12),
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
              SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: height * 0.018,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperCard(BuildContext context, double height) {
    final theme = Theme.of(context);

    return _buildCard(
      context,
      height,
      icon: Icons.code,
      iconColor: Colors.purple,
      title: 'Development Team',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _launchGowthamaanPortfolio(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.purple.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.purple,
                      size: height * 0.03,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gowthamaan Palani',
                          style: TextStyle(
                            fontSize: height * 0.022,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.open_in_new_rounded,
                    color: Colors.purple,
                    size: height * 0.022,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: () => _launchSwaminathanPortfolio(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.purple.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.purple,
                      size: height * 0.03,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Swaminathan',
                          style: TextStyle(
                            fontSize: height * 0.022,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.open_in_new_rounded,
                    color: Colors.purple,
                    size: height * 0.022,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Icon(
                Icons.account_balance_rounded,
                color: theme.colorScheme.primary,
                size: height * 0.025,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department of Electronics and Communication Engineering',
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Puducherry Technological University',
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, double height) {
    final theme = Theme.of(context);

    return _buildCard(
      context,
      height,
      icon: Icons.contact_mail_outlined,
      iconColor: Colors.green,
      title: 'Get in Touch',
      child: Column(
        children: [
          InkWell(
            onTap: () => _launchMailClient(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.email_rounded,
                    color: Colors.green,
                    size: height * 0.028,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'info.ptupeace@gmail.com',
                          style: TextStyle(
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                        Text(
                          'Tap to send email',
                          style: TextStyle(
                            fontSize: height * 0.016,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.green,
                    size: height * 0.02,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'For support, feedback, or inquiries, feel free to reach out to us.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: height * 0.018,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    double height, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: height * 0.028),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: height * 0.024,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  void _launchMailClient(BuildContext context) async {
    const kEmail = "info.ptupeace@gmail.com";
    final Uri mailUri = Uri(
      scheme: 'mailto',
      path: kEmail,
      query: 'subject=Peace App Inquiry',
    );

    try {
      if (await canLaunchUrl(mailUri)) {
        await launchUrl(mailUri);
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      // Copy email to clipboard as fallback
      await Clipboard.setData(ClipboardData(text: kEmail));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Email copied to clipboard!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _launchGowthamaanPortfolio(BuildContext context) async {
    const kPortfolio = "https://gowthamaanp.vercel.app/";
    final Uri portfolioUri = Uri.parse(kPortfolio);

    try {
      if (await canLaunchUrl(portfolioUri)) {
        await launchUrl(portfolioUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch portfolio';
      }
    } catch (e) {
      // Copy URL to clipboard as fallback
      await Clipboard.setData(ClipboardData(text: kPortfolio));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Expanded(child: Text('Portfolio URL copied to clipboard!')),
              ],
            ),
            backgroundColor: Colors.purple,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _launchSwaminathanPortfolio(BuildContext context) async {
    // TODO: Add Swaminathan's portfolio URL
    const kPortfolio = "https://placeholder-portfolio-url.com/";
    final Uri portfolioUri = Uri.parse(kPortfolio);

    try {
      if (await canLaunchUrl(portfolioUri)) {
        await launchUrl(portfolioUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch portfolio';
      }
    } catch (e) {
      // Copy URL to clipboard as fallback
      await Clipboard.setData(ClipboardData(text: kPortfolio));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Expanded(child: Text('Portfolio URL copied to clipboard!')),
              ],
            ),
            backgroundColor: Colors.purple,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
