import 'package:flutter/material.dart';
import 'package:peace/services/firestore_service.dart';
import 'package:peace/models/user.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  bool _isLoading = true;
  List<TestResultModel> _testResults = [];

  @override
  void initState() {
    super.initState();
    _loadTestResults();
  }

  Future<void> _loadTestResults() async {
    setState(() => _isLoading = true);
    try {
      final results = await FirestoreService().getTestResults(
        user.registerNumber,
      );
      setState(() {
        _testResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading test history: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                  'Test History',
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
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  )
                : _testResults.isEmpty
                ? _buildEmptyState(context, height)
                : RefreshIndicator(
                    onRefresh: _loadTestResults,
                    color: theme.colorScheme.primary,
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(15),
                      itemCount: _testResults.length,
                      itemBuilder: (context, index) {
                        return _buildTestResultCard(
                          context,
                          _testResults[index],
                          index + 1,
                          height,
                          width,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, double height) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: height * 0.12,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          SizedBox(height: 20),
          Text(
            'No Test History',
            style: TextStyle(
              fontSize: height * 0.028,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Your completed assessments will appear here',
            style: TextStyle(
              fontSize: height * 0.02,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestResultCard(
    BuildContext context,
    TestResultModel result,
    int serialNumber,
    double height,
    double width,
  ) {
    final theme = Theme.of(context);
    final dateStr = _formatDate(result.date);

    return Card(
      margin: EdgeInsets.only(bottom: 15),
      elevation: 2,
      shadowColor: theme.shadowColor.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showTestDetailsDialog(context, result, dateStr),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Serial Number Badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primaryContainer,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '#$serialNumber',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),

                  // Date and Time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: height * 0.022,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: height * 0.018,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              _formatTime(
                                result.timestamp?.toDate().toString() ?? "",
                              ),
                              style: TextStyle(
                                fontSize: height * 0.018,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // View Details Icon
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.primary,
                    size: height * 0.03,
                  ),
                ],
              ),

              SizedBox(height: 15),
              Divider(height: 1),
              SizedBox(height: 15),

              // Test Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickScoreBadge(
                    context,
                    'PHQ-9',
                    result.phqNineScore,
                    result.phqNine,
                    Colors.blue,
                    height,
                  ),
                  _buildQuickScoreBadge(
                    context,
                    'GAD-7',
                    result.gadSevenScore,
                    result.gadSeven,
                    Colors.orange,
                    height,
                  ),
                  _buildQuickScoreBadge(
                    context,
                    'PHQ-15',
                    result.phqFifteenScore,
                    result.phqFifteen,
                    Colors.purple,
                    height,
                  ),
                ],
              ),

              SizedBox(height: 10),

              // DASS Summary
              if (result.dass.isNotEmpty && result.dass != 'Not found')
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.teal.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDassQuickScore(
                        'D',
                        result.depressionDass,
                        'Depression',
                        height,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.teal.withValues(alpha: 0.3),
                      ),
                      _buildDassQuickScore(
                        'A',
                        result.anxietyDass,
                        'Anxiety',
                        height,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.teal.withValues(alpha: 0.3),
                      ),
                      _buildDassQuickScore(
                        'S',
                        result.stressDass,
                        'Stress',
                        height,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickScoreBadge(
    BuildContext context,
    String testName,
    String score,
    String severity,
    Color color,
    double height,
  ) {
    return Column(
      children: [
        Text(
          testName,
          style: TextStyle(
            fontSize: height * 0.016,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            score,
            style: TextStyle(
              fontSize: height * 0.018,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDassQuickScore(
    String label,
    String score,
    String fullName,
    double height,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: height * 0.016,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        SizedBox(height: 5),
        Text(
          score,
          style: TextStyle(
            fontSize: height * 0.02,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      if (dateStr.isEmpty || dateStr == 'Not found') return 'Unknown Date';

      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr.split('T')[0];
    }
  }

  String _formatTime(String dateStr) {
    try {
      if (dateStr.isEmpty || dateStr == 'Not found') return '';

      final date = DateTime.parse(dateStr);
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return '';
    }
  }

  void _showTestDetailsDialog(
    BuildContext context,
    TestResultModel result,
    String dateStr,
  ) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(maxHeight: height * 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.assessment,
                        color: theme.colorScheme.onPrimary,
                        size: height * 0.03,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Test Results',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: height * 0.024,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              dateStr,
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.9,
                                ),
                                fontSize: height * 0.018,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PHQ-9 Section
                        _buildDetailSection(
                          context,
                          'PHQ-9',
                          'Patient Health Questionnaire-9',
                          Icons.psychology_outlined,
                          Colors.blue,
                          result.phqNineScore,
                          result.phqNine,
                          _getPhq9Interpretation(result.phqNineScore),
                          height,
                        ),

                        SizedBox(height: 20),

                        // GAD-7 Section
                        _buildDetailSection(
                          context,
                          'GAD-7',
                          'Generalized Anxiety Disorder-7',
                          Icons.monitor_heart_outlined,
                          Colors.orange,
                          result.gadSevenScore,
                          result.gadSeven,
                          _getGad7Interpretation(result.gadSevenScore),
                          height,
                        ),

                        SizedBox(height: 20),

                        // PHQ-15 Section
                        _buildDetailSection(
                          context,
                          'PHQ-15',
                          'Patient Health Questionnaire-15',
                          Icons.health_and_safety_outlined,
                          Colors.purple,
                          result.phqFifteenScore,
                          result.phqFifteen,
                          _getPhq15Interpretation(result.phqFifteenScore),
                          height,
                        ),

                        SizedBox(height: 20),

                        // DASS-42 Section
                        if (result.dass.isNotEmpty &&
                            result.dass != 'Not found')
                          _buildDassDetailSection(context, result, height),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    String fullName,
    IconData icon,
    Color color,
    String score,
    String severity,
    String interpretation,
    double height,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: height * 0.028),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: height * 0.022,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      fullName,
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
            ],
          ),

          SizedBox(height: 15),
          Divider(),
          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score',
                    style: TextStyle(
                      fontSize: height * 0.018,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    score,
                    style: TextStyle(
                      fontSize: height * 0.028,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 15),

          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: color, size: height * 0.022),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    interpretation,
                    style: TextStyle(
                      fontSize: height * 0.018,
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

  Widget _buildDassDetailSection(
    BuildContext context,
    TestResultModel result,
    double height,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.assessment_outlined,
                  color: Colors.teal,
                  size: height * 0.028,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DASS-42',
                      style: TextStyle(
                        fontSize: height * 0.022,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    Text(
                      'Depression, Anxiety and Stress Scale',
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
            ],
          ),

          SizedBox(height: 15),
          Divider(),
          SizedBox(height: 15),

          // Depression
          _buildDassSubscale(
            'Depression',
            result.depressionDass,
            _getDassDepressionInterpretation(result.depressionDass),
            Colors.teal.shade700,
            height,
            theme,
          ),

          SizedBox(height: 12),

          // Anxiety
          _buildDassSubscale(
            'Anxiety',
            result.anxietyDass,
            _getDassAnxietyInterpretation(result.anxietyDass),
            Colors.teal.shade600,
            height,
            theme,
          ),

          SizedBox(height: 12),

          // Stress
          _buildDassSubscale(
            'Stress',
            result.stressDass,
            _getDassStressInterpretation(result.stressDass),
            Colors.teal.shade500,
            height,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildDassSubscale(
    String label,
    String score,
    String interpretation,
    Color color,
    double height,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  score,
                  style: TextStyle(
                    fontSize: height * 0.018,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            interpretation,
            style: TextStyle(
              fontSize: height * 0.017,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // Interpretation Methods
  String _getPhq9Interpretation(String score) {
    try {
      final int scoreValue = int.parse(score);
      if (scoreValue <= 4) {
        return 'Minimal depression. Scores in this range suggest very few or no depressive symptoms.';
      } else if (scoreValue <= 9) {
        return 'Mild depression. You may be experiencing some depressive symptoms that could benefit from monitoring or lifestyle changes.';
      } else if (scoreValue <= 14) {
        return 'Moderate depression. Symptoms are significant and may warrant professional evaluation and treatment consideration.';
      } else if (scoreValue <= 19) {
        return 'Moderately severe depression. Symptoms are impacting daily functioning and professional help is recommended.';
      } else {
        return 'Severe depression. Immediate professional evaluation and treatment are strongly recommended.';
      }
    } catch (e) {
      return 'Score interpretation unavailable.';
    }
  }

  String _getGad7Interpretation(String score) {
    try {
      final int scoreValue = int.parse(score);
      if (scoreValue <= 4) {
        return 'Minimal anxiety. Scores in this range suggest very few or no anxiety symptoms.';
      } else if (scoreValue <= 9) {
        return 'Mild anxiety. You may be experiencing some anxiety symptoms that could benefit from stress management techniques.';
      } else if (scoreValue <= 14) {
        return 'Moderate anxiety. Symptoms are significant and may warrant professional evaluation and treatment consideration.';
      } else {
        return 'Severe anxiety. Professional evaluation and treatment are strongly recommended to address these symptoms.';
      }
    } catch (e) {
      return 'Score interpretation unavailable.';
    }
  }

  String _getPhq15Interpretation(String score) {
    try {
      final int scoreValue = int.parse(score);
      if (scoreValue <= 4) {
        return 'Minimal somatic symptoms. Very few physical symptoms are present.';
      } else if (scoreValue <= 9) {
        return 'Low somatic symptoms. Some physical symptoms are present but generally manageable.';
      } else if (scoreValue <= 14) {
        return 'Medium somatic symptoms. Multiple physical symptoms that may be affecting daily functioning.';
      } else {
        return 'High somatic symptoms. Significant physical symptoms that may require medical evaluation and could be related to psychological distress.';
      }
    } catch (e) {
      return 'Score interpretation unavailable.';
    }
  }

  String _getDassDepressionInterpretation(String score) {
    try {
      final int scoreValue = int.parse(score);
      if (scoreValue <= 9) {
        return 'Normal - No significant symptoms of depression detected.';
      } else if (scoreValue <= 13) {
        return 'Mild - Some depressive symptoms present but manageable.';
      } else if (scoreValue <= 20) {
        return 'Moderate - Notable depressive symptoms that may benefit from intervention.';
      } else if (scoreValue <= 27) {
        return 'Severe - Significant depressive symptoms requiring professional attention.';
      } else {
        return 'Extremely Severe - Very high levels of depression; immediate professional help recommended.';
      }
    } catch (e) {
      return 'Score interpretation unavailable.';
    }
  }

  String _getDassAnxietyInterpretation(String score) {
    try {
      final int scoreValue = int.parse(score);
      if (scoreValue <= 7) {
        return 'Normal - No significant symptoms of anxiety detected.';
      } else if (scoreValue <= 9) {
        return 'Mild - Some anxiety symptoms present but manageable.';
      } else if (scoreValue <= 14) {
        return 'Moderate - Notable anxiety symptoms that may benefit from intervention.';
      } else if (scoreValue <= 19) {
        return 'Severe - Significant anxiety symptoms requiring professional attention.';
      } else {
        return 'Extremely Severe - Very high levels of anxiety; immediate professional help recommended.';
      }
    } catch (e) {
      return 'Score interpretation unavailable.';
    }
  }

  String _getDassStressInterpretation(String score) {
    try {
      final int scoreValue = int.parse(score);
      if (scoreValue <= 14) {
        return 'Normal - No significant symptoms of stress detected.';
      } else if (scoreValue <= 18) {
        return 'Mild - Some stress symptoms present but manageable.';
      } else if (scoreValue <= 25) {
        return 'Moderate - Notable stress symptoms that may benefit from intervention.';
      } else if (scoreValue <= 33) {
        return 'Severe - Significant stress symptoms requiring professional attention.';
      } else {
        return 'Extremely Severe - Very high levels of stress; immediate professional help recommended.';
      }
    } catch (e) {
      return 'Score interpretation unavailable.';
    }
  }
}
