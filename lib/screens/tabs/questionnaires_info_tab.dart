import 'package:flutter/material.dart';

class QuestionnairesInfoPage extends StatelessWidget {
  const QuestionnairesInfoPage({super.key});

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
                  'Assessment Tools',
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

                  // Introduction Card
                  _buildIntroCard(context, height),

                  SizedBox(height: 15),

                  // PHQ-9 Card
                  _buildQuestionnaireCard(
                    context,
                    height,
                    title: 'PHQ-9',
                    fullName: 'Patient Health Questionnaire-9',
                    icon: Icons.psychology_outlined,
                    iconColor: Colors.blue,
                    description:
                        'The PHQ-9 is a widely used screening tool for depression. It consists of 9 questions that assess the frequency of depressive symptoms over the past two weeks.',
                    measures: 'Depression severity',
                    questions: '9 questions',
                    scoring: [
                      '0-4: Minimal depression',
                      '5-9: Mild depression',
                      '10-14: Moderate depression',
                      '15-19: Moderately severe depression',
                      '20-27: Severe depression',
                    ],
                    purpose:
                        'Helps identify the presence and severity of depression, guiding appropriate interventions and treatment decisions.',
                  ),

                  SizedBox(height: 15),

                  // GAD-7 Card
                  _buildQuestionnaireCard(
                    context,
                    height,
                    title: 'GAD-7',
                    fullName: 'Generalized Anxiety Disorder-7',
                    icon: Icons.monitor_heart_outlined,
                    iconColor: Colors.orange,
                    description:
                        'The GAD-7 is a validated screening tool for generalized anxiety disorder. It measures the severity of anxiety symptoms over the past two weeks.',
                    measures: 'Anxiety severity',
                    questions: '7 questions',
                    scoring: [
                      '0-4: Minimal anxiety',
                      '5-9: Mild anxiety',
                      '10-14: Moderate anxiety',
                      '15-21: Severe anxiety',
                    ],
                    purpose:
                        'Screens for generalized anxiety disorder and measures anxiety severity, helping to determine the need for further evaluation or treatment.',
                  ),

                  SizedBox(height: 15),

                  // PHQ-15 Card
                  _buildQuestionnaireCard(
                    context,
                    height,
                    title: 'PHQ-15',
                    fullName: 'Patient Health Questionnaire-15',
                    icon: Icons.health_and_safety_outlined,
                    iconColor: Colors.purple,
                    description:
                        'The PHQ-15 assesses the presence and severity of somatic symptoms. It evaluates 15 common physical symptoms that can be associated with psychological distress.',
                    measures: 'Somatic symptom severity',
                    questions: '15 questions',
                    scoring: [
                      '0-4: Minimal somatic symptoms',
                      '5-9: Low somatic symptoms',
                      '10-14: Medium somatic symptoms',
                      '15-30: High somatic symptoms',
                    ],
                    purpose:
                        'Identifies the presence and severity of physical symptoms that may be related to mental health conditions or require medical attention.',
                  ),

                  SizedBox(height: 15),

                  // DASS-42 Card
                  _buildQuestionnaireCard(
                    context,
                    height,
                    title: 'DASS-42',
                    fullName: 'Depression, Anxiety and Stress Scale-42',
                    icon: Icons.assessment_outlined,
                    iconColor: Colors.teal,
                    description:
                        'The DASS-42 is a comprehensive assessment tool that measures three related negative emotional states: depression, anxiety, and stress. It provides subscale scores for each dimension.',
                    measures: 'Depression, Anxiety, and Stress',
                    questions: '42 questions (14 per subscale)',
                    scoring: [
                      'Depression: 0-9 Normal, 10-13 Mild, 14-20 Moderate, 21-27 Severe, 28+ Extremely Severe',
                      'Anxiety: 0-7 Normal, 8-9 Mild, 10-14 Moderate, 15-19 Severe, 20+ Extremely Severe',
                      'Stress: 0-14 Normal, 15-18 Mild, 19-25 Moderate, 26-33 Severe, 34+ Extremely Severe',
                    ],
                    purpose:
                        'Provides a comprehensive evaluation of emotional distress across three dimensions, offering detailed insights into mental health status.',
                  ),

                  SizedBox(height: 15),

                  // Important Note Card
                  _buildImportantNoteCard(context, height),

                  SizedBox(height: 15),

                  // References Card
                  _buildReferencesCard(context, height),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context, double height) {
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
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.library_books_rounded,
                color: theme.colorScheme.primary,
                size: height * 0.035,
              ),
              SizedBox(width: 12),
              Text(
                'About Our Assessments',
                style: TextStyle(
                  fontSize: height * 0.026,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'Peace uses clinically validated, evidence-based assessment tools to help you understand and track your mental health. '
            'These questionnaires are standardized instruments used by healthcare professionals worldwide.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: height * 0.02,
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionnaireCard(
    BuildContext context,
    double height, {
    required String title,
    required String fullName,
    required IconData icon,
    required Color iconColor,
    required String description,
    required String measures,
    required String questions,
    required List<String> scoring,
    required String purpose,
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
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: height * 0.035),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: height * 0.028,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: height * 0.018,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 15),
          Divider(color: theme.dividerColor),
          SizedBox(height: 15),

          // Description
          Text(
            description,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: height * 0.02,
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),

          SizedBox(height: 15),

          // Info Tags
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildInfoChip(context, height, Icons.track_changes, measures),
              _buildInfoChip(context, height, Icons.quiz_outlined, questions),
            ],
          ),

          SizedBox(height: 15),

          // Scoring
          Text(
            'Scoring Range:',
            style: TextStyle(
              fontSize: height * 0.022,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8),
          ...scoring.map(
            (score) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 7),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      score,
                      style: TextStyle(
                        fontSize: height * 0.019,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 15),

          // Purpose
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: iconColor,
                  size: height * 0.024,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    purpose,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: height * 0.019,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    double height,
    IconData icon,
    String label,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: height * 0.02, color: theme.colorScheme.primary),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: height * 0.018,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNoteCard(BuildContext context, double height) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.amber.shade900,
                size: height * 0.03,
              ),
              SizedBox(width: 12),
              Text(
                'Important Notice',
                style: TextStyle(
                  fontSize: height * 0.024,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '• These assessments are screening tools, not diagnostic instruments.\n\n'
            '• Results should be interpreted by qualified mental health professionals.\n\n'
            '• This app does not replace professional medical advice, diagnosis, or treatment.\n\n'
            '• If you are experiencing severe symptoms or crisis, please seek immediate professional help.\n\n'
            '• Contact emergency services or a mental health crisis helpline if you have thoughts of self-harm.',
            style: TextStyle(
              fontSize: height * 0.019,
              height: 1.6,
              color: Colors.amber.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferencesCard(BuildContext context, double height) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: theme.colorScheme.primary,
                size: height * 0.028,
              ),
              SizedBox(width: 12),
              Text(
                'Scientific References',
                style: TextStyle(
                  fontSize: height * 0.024,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'All assessment tools used in Peace are based on peer-reviewed research and are widely accepted in clinical practice:',
            style: TextStyle(
              fontSize: height * 0.019,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: 12),
          _buildReference(
            context,
            height,
            'PHQ-9',
            'Kroenke, K., Spitzer, R. L., & Williams, J. B. (2001)',
          ),
          _buildReference(
            context,
            height,
            'GAD-7',
            'Spitzer, R. L., Kroenke, K., Williams, J. B., & Löwe, B. (2006)',
          ),
          _buildReference(
            context,
            height,
            'PHQ-15',
            'Kroenke, K., Spitzer, R. L., & Williams, J. B. (2002)',
          ),
          _buildReference(
            context,
            height,
            'DASS-42',
            'Lovibond, S. H., & Lovibond, P. F. (1995)',
          ),
        ],
      ),
    );
  }

  Widget _buildReference(
    BuildContext context,
    double height,
    String tool,
    String citation,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 7),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: height * 0.016,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: height * 0.018,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '$tool: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  TextSpan(text: citation),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
