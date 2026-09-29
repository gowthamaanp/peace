import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peace/screens/assessments/dass/dass_depression_screen.dart';

class DassInstructionScreen extends StatelessWidget {
  const DassInstructionScreen({super.key});

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
                        Icons.assignment_outlined,
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
                            'DASS-42',
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
                            'How to Complete',
                            style: TextStyle(
                              fontSize: height * 0.025,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      Text(
                        'Please read each statement carefully and select the response that best describes how much the statement applied to you over the past week.',
                        style: TextStyle(
                          fontSize: height * 0.02,
                          height: 1.5,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '⏱️ Important Notes',
                              style: TextStyle(
                                fontSize: height * 0.022,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 12),
                            _buildBulletPoint(
                              context,
                              height,
                              'There are no right or wrong answers',
                            ),
                            SizedBox(height: 8),
                            _buildBulletPoint(
                              context,
                              height,
                              'Take your time with each question',
                            ),
                            SizedBox(height: 8),
                            _buildBulletPoint(
                              context,
                              height,
                              'Be honest with your responses',
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25),

                      // Rating scale header
                      Row(
                        children: [
                          Icon(
                            Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: height * 0.028,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Rating Scale',
                            style: TextStyle(
                              fontSize: height * 0.025,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      // Rating options
                      _buildRatingOption(
                        context,
                        height,
                        '0',
                        'Did not apply to me at all',
                        Colors.green,
                      ),
                      SizedBox(height: 12),
                      _buildRatingOption(
                        context,
                        height,
                        '1',
                        'Applies to me to some degree, or some of the time',
                        Colors.lightGreen,
                      ),
                      SizedBox(height: 12),
                      _buildRatingOption(
                        context,
                        height,
                        '2',
                        'Applies to me to a considerable degree, or a good part of time',
                        Colors.orange,
                      ),
                      SizedBox(height: 12),
                      _buildRatingOption(
                        context,
                        height,
                        '3',
                        'Applies to me very much, or most of the time',
                        Colors.red,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Info banner
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.blue,
                        size: height * 0.025,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your responses are confidential and will help us provide better support.',
                          style: TextStyle(
                            fontSize: height * 0.018,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
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
                          builder: (BuildContext context) =>
                              DassDepressionSection(),
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

  Widget _buildBulletPoint(BuildContext context, double height, String text) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: height * 0.019,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingOption(
    BuildContext context,
    double height,
    String value,
    String description,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: height * 0.024,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: height * 0.019,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
