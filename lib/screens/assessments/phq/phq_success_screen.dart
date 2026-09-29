import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peace/services/firestore_service.dart';
import 'package:peace/widgets/loading_widget.dart';
import 'package:peace/models/test_results.dart';
import 'package:peace/models/user.dart';
import 'package:peace/screens/assessments/dass/dass_instructions_screen.dart';

import '../../home_screen.dart';

class PhqSuccessScreen extends StatelessWidget {
  const PhqSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.primary.withValues(alpha: 0.05),
                colorScheme.surface,
                colorScheme.surface,
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Success Animation/Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.shade50,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: height * 0.12,
                      color: Colors.green.shade600,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Success Title
                  Text(
                    "Assessment Complete!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height * 0.035,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    "PHQ-Test Successfully Submitted",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height * 0.02,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          size: height * 0.045,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Want to learn more about your mental well-being?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: height * 0.024,
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "You can proceed to the DASS Test for a more comprehensive analysis of your current mental state, including depression, anxiety, and stress levels.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: height * 0.019,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Proceed Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute<bool>(
                            fullscreenDialog: false,
                            builder: (BuildContext context) =>
                                DassInstructionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continue to DASS Test",
                            style: TextStyle(
                              fontSize: height * 0.022,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: height * 0.024,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Skip Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        OverlayLoader.show(context);
                        TestResultModel testResultModel = TestResultModel(
                          date: DateTime.now().toIso8601String().substring(
                            0,
                            10,
                          ),
                          registerNumber: user.uid,
                          phqFifteen: studentTestResults.phqFifteen,
                          gadSeven: studentTestResults.gadSeven,
                          phqNine: studentTestResults.phqNine,
                          dass: 'Not Opted',
                          phqFifteenScore: studentTestResults.phqFifteenScore
                              .toString(),
                          gadSevenScore: studentTestResults.gadSevenScore
                              .toString(),
                          phqNineScore: studentTestResults.phqNineScore
                              .toString(),
                          depressionDass: 'Not Opted',
                          anxietyDass: 'Not Opted',
                          stressDass: 'Not Opted',
                        );

                        final response = await FirestoreService().addTestResult(
                          testResultModel,
                        );

                        resetTestResults();
                        if (!context.mounted) return;
                        OverlayLoader.hide(context);

                        debugPrint(
                          'Response from saving test result: $response',
                        );

                        Navigator.of(context, rootNavigator: false).push(
                          CupertinoPageRoute<bool>(
                            fullscreenDialog: false,
                            builder: (BuildContext context) => HomeScreen(
                              phqNineScore: studentTestResults.phqNineScore,
                              gadSevenScore: studentTestResults.gadSevenScore,
                              phqFifteenScore:
                                  studentTestResults.phqFifteenScore,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Skip and Return to Home",
                        style: TextStyle(
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Footer Text
                  Text(
                    'Puducherry Technological University',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: height * 0.016,
                      fontWeight: FontWeight.w500,
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
}
