import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:peace/models/quote.dart';
import 'package:peace/models/user.dart';
import 'package:peace/screens/tabs/analytics_tab.dart';
import 'package:peace/screens/profile/profile_screen.dart';
import 'package:peace/screens/tabs/settings_tab.dart';
import 'package:peace/screens/assessments/phq/phq_instructions_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:peace/services/mood_tracking_service.dart';
import 'package:intl/intl.dart';

import 'test_history_screen.dart';

class HomeScreen extends StatefulWidget {
  final int? phqNineScore;
  final int? gadSevenScore;
  final int? phqFifteenScore;
  final int? depressionDass;
  final int? anxietyDass;
  final int? stressDass;

  const HomeScreen({
    super.key,
    this.phqNineScore,
    this.gadSevenScore,
    this.phqFifteenScore,
    this.depressionDass,
    this.anxietyDass,
    this.stressDass,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Quote quote = Quote("Getting a Quote...", "");
  final MoodTrackingService _moodService = MoodTrackingService();

  // Mood tracking state
  String? selectedMood;
  String? selectedMoodEmoji;
  bool isMoodLogged = false;
  int moodStreak = 0;
  List<Map<String, dynamic>> last7DaysMoods = [];

  @override
  void initState() {
    super.initState();
    getQuote();
    _loadTodaysMood();
    _loadMoodStreak();
    _loadLast7DaysMoods();

    // Check test scores after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTestScoresForAbnormality();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    // Get time-based greeting
    String getGreeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Good Morning!';
      } else if (hour < 17) {
        return 'Good Afternoon!';
      } else {
        return 'Good Evening!';
      }
    }

    // Get time-based icon
    Widget getIcon() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return Icon(Icons.sunny_snowing, color: Colors.orangeAccent, size: 35);
      } else if (hour < 17) {
        return Icon(Icons.sunny, color: Colors.yellowAccent, size: 35);
      } else {
        return Icon(Icons.dark_mode, color: Colors.orangeAccent, size: 35);
      }
    }

    // Get user's first name or default
    String getUserName() {
      if (user.name.isNotEmpty) {
        return user.name.split(' ').first;
      }
      return 'there';
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 25.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade300,
                    Colors.blue.shade500,
                    Colors.blue.shade700,
                    Colors.blue.shade900,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 30.0),
                  child: Column(
                    children: [
                      // Top row with icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // App logo or icon
                          getIcon(),
                          // Action buttons
                          Row(
                            children: [
                              _headerIconButton(
                                Icons.person_outline_rounded,
                                () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: false,
                                  ).push(
                                    CupertinoPageRoute<bool>(
                                      fullscreenDialog: false,
                                      builder: (BuildContext context) =>
                                          ProfilePage(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 10),
                              _headerIconButton(Icons.settings_outlined, () {
                                Navigator.of(
                                  context,
                                  rootNavigator: false,
                                ).push(
                                  CupertinoPageRoute<bool>(
                                    fullscreenDialog: false,
                                    builder: (BuildContext context) =>
                                        SettingsPage(),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      // Greeting section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getGreeting(),
                              style: TextStyle(
                                fontSize: height * 0.028,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              getUserName(),
                              style: TextStyle(
                                fontSize: height * 0.040,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Your mental wellness matters",
                                    style: TextStyle(
                                      fontSize: height * 0.018,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // How do you feel today card
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 20.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isMoodLogged
                      ? _getMoodConfig(selectedMood ?? '')['color']
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 15.0,
                  ),
                  child: !isMoodLogged
                      ? _buildMoodSelectionView(height)
                      : _buildMoodLoggedView(height),
                ),
              ),
            ),
            // Quote of the day
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange.shade50, Colors.amber.shade50],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15),
                      Text(
                        quote.quote,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: height * 0.025,
                          fontWeight: FontWeight.w600,
                          color: Colors.brown.shade800,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '- ${quote.author}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: height * 0.022,
                          color: Colors.brown.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Divider(color: Colors.grey.shade300, thickness: 1),
            ),
            SizedBox(height: 10),
            // Mental Health Assessment Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mental Health Assessment",
                    style: TextStyle(
                      fontSize: height * 0.032,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Take a quick self-assessment to understand your mental well-being",
                    style: TextStyle(
                      fontSize: height * 0.020,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 15),
                  // Assessment Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue.shade700, Colors.indigo.shade700],
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: false).push(
                            CupertinoPageRoute<bool>(
                              fullscreenDialog: false,
                              builder: (BuildContext context) =>
                                  InstructionScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20.0),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      Icons.psychology_outlined,
                                      size: height * 0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start Assessment",
                                          style: TextStyle(
                                            fontSize: height * 0.028,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "10-15 minutes",
                                          style: TextStyle(
                                            fontSize: height * 0.020,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: height * 0.035,
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      size: height * 0.022,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Confidential and secure self-assessment",
                                        style: TextStyle(
                                          fontSize: height * 0.018,
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Talk to Counselor Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.indigo.shade100,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showTeleManasDialog,
                        borderRadius: BorderRadius.circular(20.0),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.chat_bubble_outline,
                                  size: height * 0.035,
                                  color: Colors.indigo.shade700,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Talk with a Counselor",
                                      style: TextStyle(
                                        fontSize: height * 0.024,
                                        color: Colors.indigo.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Get professional support",
                                      style: TextStyle(
                                        fontSize: height * 0.018,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.indigo.shade300,
                                size: height * 0.025,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Divider(color: Colors.grey.shade300, thickness: 1),
            ),
            SizedBox(height: 20),
            // Analytics Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepOrange.shade300,
                                  Colors.deepOrange.shade500,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.analytics_outlined,
                              color: Colors.white,
                              size: height * 0.03,
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Progress",
                                style: TextStyle(
                                  fontSize: height * 0.028,
                                  color: Colors.deepOrange.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Mental well-being insights",
                                style: TextStyle(
                                  fontSize: height * 0.018,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.deepOrange.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: height * 0.018,
                              color: Colors.deepOrange.shade700,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Live",
                              style: TextStyle(
                                fontSize: height * 0.016,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 330;
                return SizedBox(
                  height: isSmallScreen ? height * 1.17 : height * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: AnalyticsWidget(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Test History Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: false).push(
                    CupertinoPageRoute<bool>(
                      fullscreenDialog: false,
                      builder: (BuildContext context) => HistoryPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_rounded, size: height * 0.028),
                    SizedBox(width: 12),
                    Text(
                      "View Test History",
                      style: TextStyle(
                        fontSize: height * 0.024,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: height * 0.024),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // Footer Section
            Column(
              children: [
                InkWell(
                  onTap: _launchURL,
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: height * 0.15,
                          width: height * 0.15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/ptu_logo.png"),
                            ),
                          ),
                        ),

                        Container(
                          height: height * 0.15,
                          width: height * 0.25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage(
                                "assets/images/telemanas_logo.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '©Copyright-${DateTime.now().year}\nPuducherry Technological University',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: height * 0.018,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getQuote() async {
    final bool isConnected =
        await InternetConnectionChecker.instance.hasConnection;

    if (isConnected) {
      var url = Uri.parse("https://zenquotes.io/api/random");
      http.Response quoteResponse = await http.get(url);
      var jsonFeedback = convert.jsonDecode(quoteResponse.body);
      setState(() {
        quote = Quote.fromJson(jsonFeedback[0]);
      });
    } else {
      quote = Quote("No Internet Connection", "");
      setState(() {});
    }
  }

  Future<void> _launchURL() async {
    const url = 'https://ptuniv.edu.in/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _checkTestScoresForAbnormality() {
    // Check if any test scores indicate moderate or higher severity
    // PHQ-9: ≥10 is moderate or higher
    // GAD-7: ≥10 is moderate or higher
    // PHQ-15: ≥10 is medium or higher
    // DASS: ≥10 is moderate or higher for any subscale

    bool hasAbnormalScore = false;

    if (widget.phqNineScore != null && widget.phqNineScore! >= 10) {
      hasAbnormalScore = true;
    }
    if (widget.gadSevenScore != null && widget.gadSevenScore! >= 10) {
      hasAbnormalScore = true;
    }
    if (widget.phqFifteenScore != null && widget.phqFifteenScore! >= 10) {
      hasAbnormalScore = true;
    }
    if (widget.depressionDass != null && widget.depressionDass! >= 10) {
      hasAbnormalScore = true;
    }
    if (widget.anxietyDass != null && widget.anxietyDass! >= 10) {
      hasAbnormalScore = true;
    }
    if (widget.stressDass != null && widget.stressDass! >= 10) {
      hasAbnormalScore = true;
    }

    if (hasAbnormalScore && mounted) {
      _showTeleManasPrompt();
    }
  }

  void _showTeleManasPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    size: 48,
                    color: Colors.orange.shade700,
                  ),
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  'We\'re Here for You',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),

                // Message
                Text(
                  'We noticed you\'re feeling down. Would you like to talk to a professional counselor?',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Not Now',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showTeleManasDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.indigo.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Get Help',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTeleManasDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.support_agent,
                    size: 48,
                    color: Colors.indigo.shade700,
                  ),
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  'Contact Tele MANAS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                // Description
                Text(
                  'Tele MANAS is a comprehensive mental health care service',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Dial the Toll-Free numbers below to get in touch with our Counsellor',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),

                // Phone numbers
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200, width: 1),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.indigo.shade700,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '14416',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.indigo.shade700,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '1-800 891 4416',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Full name
                Text(
                  'Tele Mental Health Assistance and Networking Across States (Tele MANAS)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _makePhoneCall('14416');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.indigo.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.phone, color: Colors.white),
                        label: Text(
                          'Call Now',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unable to make phone call'),
              backgroundColor: Colors.red.shade400,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Could not launch phone dialer'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  // Mood tracking methods
  Future<void> _loadTodaysMood() async {
    final moodData = await _moodService.getTodaysMood();

    if (moodData != null) {
      setState(() {
        isMoodLogged = true;
        selectedMood = moodData['label'];
        selectedMoodEmoji = moodData['emoji'];
      });
    }
  }

  Future<void> _loadMoodStreak() async {
    final streak = await _moodService.getMoodStreak();
    setState(() {
      moodStreak = streak;
    });
  }

  Future<void> _loadLast7DaysMoods() async {
    final moods = await _moodService.getLast7DaysMoods();
    setState(() {
      last7DaysMoods = moods;
    });
  }

  Future<void> _saveMood(String emoji, String label) async {
    // Show loading state
    setState(() {
      isMoodLogged = true;
      selectedMood = label;
      selectedMoodEmoji = emoji;
    });

    // Save to Firestore
    final success = await _moodService.saveMood(emoji: emoji, label: label);

    if (success) {
      // Reload streak and 7-day history
      await _loadMoodStreak();
      await _loadLast7DaysMoods();

      // Show TeleManas dialog if mood is Sad
      if (mounted && label == 'Sad') {
        _showTeleManasPrompt();
      }
    } else {
      // Revert state if save failed
      setState(() {
        isMoodLogged = false;
        selectedMood = null;
        selectedMoodEmoji = null;
      });

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save mood. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Map<String, dynamic> _getMoodConfig(String label) {
    switch (label) {
      case 'Sad':
        return {
          'color': Colors.blue.shade100,
          'darkColor': Colors.blue.shade700,
          'message': 'It\'s okay to not be okay',
          'tip': 'Take a moment to breathe and be kind to yourself',
          'action': 'Take Assessment',
          'icon': Icons.psychology_outlined,
        };
      case 'Fine':
        return {
          'color': Colors.teal.shade100,
          'darkColor': Colors.teal.shade700,
          'message': 'You\'re doing great!',
          'tip': 'Keep up the positive momentum',
          'action': 'View Insights',
          'icon': Icons.trending_up,
        };
      case 'Well':
        return {
          'color': Colors.green.shade100,
          'darkColor': Colors.green.shade700,
          'message': 'Wonderful to hear!',
          'tip': 'Share your positivity with others today',
          'action': 'View Progress',
          'icon': Icons.celebration_outlined,
        };
      case 'Excellent':
        return {
          'color': Colors.amber.shade100,
          'darkColor': Colors.amber.shade700,
          'message': 'You\'re shining bright! ✨',
          'tip': 'You\'re an inspiration to others',
          'action': 'View Achievements',
          'icon': Icons.auto_awesome,
        };
      default:
        return {
          'color': Colors.grey.shade100,
          'darkColor': Colors.grey.shade700,
          'message': 'Thanks for checking in',
          'tip': 'Your mental wellness journey matters',
          'action': 'Continue',
          'icon': Icons.favorite_outline,
        };
    }
  }

  Widget _headerIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget circleAvatar(double height, IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        margin: const EdgeInsets.only(left: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: height * 0.028,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            size: height * 0.035,
            color: Colors.indigo.shade700,
          ),
        ),
      ),
    );
  }

  Widget emojiButton(String emojiText, String labelText, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.indigo.shade50],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emojiText,
              style: TextStyle(
                fontSize: (MediaQuery.of(context).size.height) * 0.045,
              ),
            ),
            SizedBox(height: 5),
            Text(
              labelText,
              style: TextStyle(
                fontSize: (MediaQuery.of(context).size.height) * 0.020,
                color: Colors.indigo.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build mood selection view (before mood is logged)
  Widget _buildMoodSelectionView(double height) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Icon(
              Icons.sentiment_satisfied_alt,
              color: Colors.indigo.shade700,
              size: height * 0.03,
            ),
            SizedBox(width: 10),
            Text(
              "How do you feel today?",
              style: TextStyle(
                fontSize: height * 0.030,
                color: Colors.indigo.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildMoodButton("😔", "Sad", height),
            _buildMoodButton("😊", "Fine", height),
            _buildMoodButton("😃", "Well", height),
            _buildMoodButton("😁", "Excellent", height),
          ],
        ),
        if (moodStreak > 0) ...[
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🔥', style: TextStyle(fontSize: height * 0.02)),
                SizedBox(width: 6),
                Text(
                  '$moodStreak day streak!',
                  style: TextStyle(
                    fontSize: height * 0.018,
                    color: Colors.orange.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // Build mood logged view (after mood is logged)
  Widget _buildMoodLoggedView(double height) {
    final config = _getMoodConfig(selectedMood ?? '');

    return Column(
      children: [
        // Header with checkmark
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: config['darkColor'],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: height * 0.025,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mood Logged",
                  style: TextStyle(
                    fontSize: height * 0.022,
                    color: config['darkColor'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMMM d, yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: height * 0.016,
                    color: config['darkColor'].withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 20),

        // Selected mood display
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                selectedMoodEmoji ?? '',
                style: TextStyle(fontSize: height * 0.06),
              ),
              SizedBox(height: 10),
              Text(
                'Feeling $selectedMood',
                style: TextStyle(
                  fontSize: height * 0.024,
                  color: config['darkColor'],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    config['icon'],
                    color: config['darkColor'],
                    size: height * 0.022,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      config['message'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: height * 0.020,
                        color: config['darkColor'],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                config['tip'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: height * 0.018,
                  color: Colors.grey.shade700,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 15),

        // Action button (only for Sad mood - take assessment)
        if (selectedMood == 'Sad')
          ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: false).push(
                CupertinoPageRoute<bool>(
                  fullscreenDialog: false,
                  builder: (BuildContext context) => InstructionScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: config['darkColor'],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.psychology_outlined, size: height * 0.022),
                SizedBox(width: 8),
                Text(
                  'Take Assessment',
                  style: TextStyle(
                    fontSize: height * 0.020,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        // 7-day mood tracker
        if (last7DaysMoods.isNotEmpty) ...[
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: height * 0.018,
                      color: config['darkColor'],
                    ),
                    SizedBox(width: 6),
                    Text(
                      '7-Day Mood Tracker',
                      style: TextStyle(
                        fontSize: height * 0.018,
                        color: config['darkColor'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: last7DaysMoods.map((dayData) {
                    return Column(
                      children: [
                        Text(
                          dayData['day'],
                          style: TextStyle(
                            fontSize: height * 0.014,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: dayData['mood'] != null
                                ? config['darkColor'].withValues(alpha: 0.2)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              dayData['mood'] ?? '·',
                              style: TextStyle(fontSize: height * 0.024),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],

        // Streak badge
        if (moodStreak > 0) ...[
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.orange.shade600],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🔥', style: TextStyle(fontSize: height * 0.024)),
                SizedBox(width: 8),
                Text(
                  '$moodStreak Day Streak!',
                  style: TextStyle(
                    fontSize: height * 0.020,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Keep it up!',
                  style: TextStyle(
                    fontSize: height * 0.016,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // Build individual mood button
  Widget _buildMoodButton(String emoji, String label, double height) {
    return InkWell(
      onTap: () => _saveMood(emoji, label),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.indigo.shade50],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: height * 0.045)),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: height * 0.020,
                color: Colors.indigo.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
