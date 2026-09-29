import 'package:flutter/material.dart';
import 'package:peace/services/firestore_service.dart';
import 'package:peace/models/user.dart';
import 'package:intl/intl.dart';

class AnalyticsWidget extends StatefulWidget {
  const AnalyticsWidget({super.key});

  @override
  State<StatefulWidget> createState() => AnalyticsWidgetState();
}

class AnalyticsWidgetState extends State<AnalyticsWidget> {
  bool _isLoading = true;
  List<TestResultModel> _testResults = [];
  Map<String, dynamic>? _latestScores;
  Map<String, dynamic>? _previousScores;

  @override
  void initState() {
    super.initState();
    _loadTestData();
  }

  Future<void> _loadTestData() async {
    setState(() => _isLoading = true);
    try {
      final results = await FirestoreService().getTestResults(
        user.registerNumber,
      );

      setState(() {
        _testResults = results;
        if (results.isNotEmpty) {
          _latestScores = _extractScores(results[0]);
          if (results.length > 1) {
            _previousScores = _extractScores(results[1]);
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _extractScores(TestResultModel result) {
    return {
      'phq9': int.tryParse(result.phqNineScore) ?? 0,
      'gad7': int.tryParse(result.gadSevenScore) ?? 0,
      'phq15': int.tryParse(result.phqFifteenScore) ?? 0,
      'depression': int.tryParse(result.depressionDass) ?? 0,
      'anxiety': int.tryParse(result.anxietyDass) ?? 0,
      'stress': int.tryParse(result.stressDass) ?? 0,
      'date': result.date,
    };
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final screenThreshold = 330;

    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    if (_testResults.isEmpty) {
      return _buildEmptyState(context, height, theme);
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          SizedBox(height: 20),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = constraints.maxWidth < screenThreshold;
                  return Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latest Assessment',
                            style: TextStyle(
                              fontSize: isSmallScreen
                                  ? height * 0.02
                                  : height * 0.022,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _formatDate(_latestScores!['date']),
                            style: TextStyle(
                              fontSize: isSmallScreen
                                  ? height * 0.016
                                  : height * 0.018,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.assessment,
                              size: height * 0.02,
                              color: theme.colorScheme.primary,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '${_testResults.length} Test${_testResults.length > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: isSmallScreen
                                    ? height * 0.016
                                    : height * 0.018,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Scores Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = constraints.maxWidth < screenThreshold;

                  return Column(
                    children: [
                      // Primary Assessments
                      if (isSmallScreen) ...[
                        // Column layout for small screens
                        _buildScoreCard(
                          context,
                          'PHQ-9',
                          'Depression',
                          _latestScores!['phq9'],
                          27,
                          _previousScores?['phq9'],
                          Colors.blue,
                          Icons.psychology_outlined,
                          height,
                          theme,
                        ),
                        SizedBox(height: 12),
                        _buildScoreCard(
                          context,
                          'GAD-7',
                          'Anxiety',
                          _latestScores!['gad7'],
                          21,
                          _previousScores?['gad7'],
                          Colors.orange,
                          Icons.monitor_heart_outlined,
                          height,
                          theme,
                        ),
                        SizedBox(height: 12),
                        _buildScoreCard(
                          context,
                          'PHQ-15',
                          'Somatic',
                          _latestScores!['phq15'],
                          30,
                          _previousScores?['phq15'],
                          Colors.purple,
                          Icons.health_and_safety_outlined,
                          height,
                          theme,
                        ),
                      ] else ...[
                        // Row layout for larger screens
                        Row(
                          children: [
                            Expanded(
                              child: _buildScoreCard(
                                context,
                                'PHQ-9',
                                'Depression',
                                _latestScores!['phq9'],
                                27,
                                _previousScores?['phq9'],
                                Colors.blue,
                                Icons.psychology_outlined,
                                height,
                                theme,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildScoreCard(
                                context,
                                'GAD-7',
                                'Anxiety',
                                _latestScores!['gad7'],
                                21,
                                _previousScores?['gad7'],
                                Colors.orange,
                                Icons.monitor_heart_outlined,
                                height,
                                theme,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        _buildScoreCard(
                          context,
                          'PHQ-15',
                          'Somatic',
                          _latestScores!['phq15'],
                          30,
                          _previousScores?['phq15'],
                          Colors.purple,
                          Icons.health_and_safety_outlined,
                          height,
                          theme,
                        ),
                      ],
                      SizedBox(height: 12),

                      // DASS-42 Section
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isSmallScreen =
                                constraints.maxWidth < screenThreshold;
                            return Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.teal.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.teal.withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.assessment_outlined,
                                        color: Colors.teal,
                                        size: height * 0.024,
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'DASS-42 Subscales',
                                          style: TextStyle(
                                            fontSize: isSmallScreen
                                                ? height * 0.018
                                                : height * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Expanded(
                                    child: isSmallScreen
                                        ? SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                _buildDassSubscale(
                                                  'Depression',
                                                  _latestScores!['depression'],
                                                  42,
                                                  _previousScores?['depression'],
                                                  Colors.teal.shade700,
                                                  height,
                                                  theme,
                                                ),
                                                SizedBox(height: 8),
                                                _buildDassSubscale(
                                                  'Anxiety',
                                                  _latestScores!['anxiety'],
                                                  42,
                                                  _previousScores?['anxiety'],
                                                  Colors.teal.shade600,
                                                  height,
                                                  theme,
                                                ),
                                                SizedBox(height: 8),
                                                _buildDassSubscale(
                                                  'Stress',
                                                  _latestScores!['stress'],
                                                  42,
                                                  _previousScores?['stress'],
                                                  Colors.teal.shade500,
                                                  height,
                                                  theme,
                                                ),
                                              ],
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                child: _buildDassSubscale(
                                                  'Depression',
                                                  _latestScores!['depression'],
                                                  42,
                                                  _previousScores?['depression'],
                                                  Colors.teal.shade700,
                                                  height,
                                                  theme,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: _buildDassSubscale(
                                                  'Anxiety',
                                                  _latestScores!['anxiety'],
                                                  42,
                                                  _previousScores?['anxiety'],
                                                  Colors.teal.shade600,
                                                  height,
                                                  theme,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: _buildDassSubscale(
                                                  'Stress',
                                                  _latestScores!['stress'],
                                                  42,
                                                  _previousScores?['stress'],
                                                  Colors.teal.shade500,
                                                  height,
                                                  theme,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(
    BuildContext context,
    String title,
    String subtitle,
    int score,
    int maxScore,
    int? previousScore,
    Color color,
    IconData icon,
    double height,
    ThemeData theme,
  ) {
    final percentage = (score / maxScore * 100).clamp(0, 100);
    final hasImproved = previousScore != null && score < previousScore;
    final hasWorsened = previousScore != null && score > previousScore;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: height * 0.024),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: height * 0.015,
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
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score.toString(),
                style: TextStyle(
                  fontSize: height * 0.035,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                '/$maxScore',
                style: TextStyle(
                  fontSize: height * 0.02,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              Spacer(),
              if (previousScore != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: hasImproved
                        ? Colors.green.withValues(alpha: 0.1)
                        : hasWorsened
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasImproved
                            ? Icons.trending_down
                            : hasWorsened
                            ? Icons.trending_up
                            : Icons.trending_flat,
                        size: height * 0.018,
                        color: hasImproved
                            ? Colors.green
                            : hasWorsened
                            ? Colors.red
                            : Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${(score - previousScore).abs()}',
                        style: TextStyle(
                          fontSize: height * 0.015,
                          fontWeight: FontWeight.bold,
                          color: hasImproved
                              ? Colors.green
                              : hasWorsened
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDassSubscale(
    String label,
    int score,
    int maxScore,
    int? previousScore,
    Color color,
    double height,
    ThemeData theme,
  ) {
    final percentage = (score / maxScore * 100).clamp(0, 100);
    final hasImproved = previousScore != null && score < previousScore;
    final hasWorsened = previousScore != null && score > previousScore;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: height * 0.016,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: height * 0.028,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
          if (previousScore != null) ...[
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  hasImproved
                      ? Icons.arrow_downward
                      : hasWorsened
                      ? Icons.arrow_upward
                      : Icons.remove,
                  size: height * 0.016,
                  color: hasImproved
                      ? Colors.green
                      : hasWorsened
                      ? Colors.red
                      : Colors.grey,
                ),
                SizedBox(width: 2),
                Text(
                  '${(score - previousScore).abs()}',
                  style: TextStyle(
                    fontSize: height * 0.014,
                    fontWeight: FontWeight.bold,
                    color: hasImproved
                        ? Colors.green
                        : hasWorsened
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    double height,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timeline_outlined,
                size: height * 0.08,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'No Progress Data Yet',
              style: TextStyle(
                fontSize: height * 0.024,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Complete an assessment to see your mental health progress',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: height * 0.018,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      if (dateStr.isEmpty || dateStr == 'Not found') return 'Unknown Date';

      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr.split('T')[0];
    }
  }
}
