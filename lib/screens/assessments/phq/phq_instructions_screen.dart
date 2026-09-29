import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peace/screens/assessments/phq/phq_section_a_screen.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Back button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: height * 0.035,
                    color: theme.colorScheme.onSurface,
                  ),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),

                SizedBox(height: 20),

                // Title with icon
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primaryContainer,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.psychology_outlined,
                        size: height * 0.045,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mental Health',
                            style: TextStyle(
                              fontSize: height * 0.035,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Assessment Instructions',
                            style: TextStyle(
                              fontSize: height * 0.02,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // Instructions card
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Instructions header
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: theme.colorScheme.primary,
                            size: height * 0.03,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Important Guidelines',
                            style: TextStyle(
                              fontSize: height * 0.025,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      _buildInstructionItem(
                        context,
                        height,
                        '1',
                        'Read Carefully',
                        'Take your time to read each question thoroughly before answering.',
                        Colors.blue,
                      ),

                      SizedBox(height: 15),

                      _buildInstructionItem(
                        context,
                        height,
                        '2',
                        'Be Honest',
                        'Answer truthfully. The questionnaire has built-in validation to ensure genuine responses.',
                        Colors.green,
                      ),

                      SizedBox(height: 15),

                      _buildInstructionItem(
                        context,
                        height,
                        '3',
                        'No Time Limit',
                        'There\'s no rush. Take your time to reflect on each question and provide accurate answers.',
                        Colors.orange,
                      ),

                      SizedBox(height: 20),

                      // Privacy note
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.05,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              color: theme.colorScheme.primary,
                              size: height * 0.028,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your responses are completely confidential and will only be used to provide you with appropriate support.',
                                style: TextStyle(
                                  fontSize: height * 0.019,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.8,
                                  ),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // Tips card
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.withValues(alpha: 0.1),
                        Colors.blue.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.purple.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Colors.purple,
                            size: height * 0.028,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Tips for Best Results',
                            style: TextStyle(
                              fontSize: height * 0.022,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      _buildTipItem(context, height, 'Find a quiet place'),
                      _buildTipItem(context, height, 'Be in a calm mindset'),
                      _buildTipItem(
                        context,
                        height,
                        'Answer based on recent experiences',
                      ),
                      _buildTipItem(
                        context,
                        height,
                        'Don\'t overthink your answers',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Start button
                SizedBox(
                  width: double.infinity,
                  height: height * 0.065,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<bool>(
                          fullscreenDialog: false,
                          builder: (BuildContext context) => PHQSectionA(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Begin Assessment',
                          style: TextStyle(
                            fontSize: height * 0.024,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_rounded, size: height * 0.028),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(
    BuildContext context,
    double height,
    String number,
    String title,
    String description,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: height * 0.022,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: height * 0.021,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: height * 0.019,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(BuildContext context, double height, String text) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.purple, size: height * 0.02),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: height * 0.019,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
