import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_form_plus/flutter_bloc_form.dart';
import 'package:peace/widgets/loading_widget.dart';
import 'package:peace/models/test_results.dart';
import 'package:peace/screens/home_screen.dart';
import 'package:peace/screens/assessments/dass/dass_stress_screen.dart';

final questions = [
  "I was aware of dryness of my mouth",
  "I experienced breathing difficulty (eg, excessively rapid breathing,breathlessness in the absence of physical exertion)",
  "I had a feeling of shakiness (eg, legs going to give way)",
  "I found myself in situations that made me so anxious I was most relieved when they ended",
  "I had a feeling of faintness",
  "I perspired noticeably (eg, hands sweaty) in the absence of high temperatures or physical exertion",
  "I felt scared without any good reason",
  "I had difficulty in swallowing",
  "I was aware of the action of my heart in the absence of physical exertion (eg, sense of heart rate increase, heart missing a beat)",
  "I felt I was close to panic",
  "I feared that I would be \"thrown\" by some trivial but unfamiliar task",
  "I felt terrified",
  "I was worried about situations in which I might panic and make a fool of myself",
  "I experienced trembling (eg, in the hands)",
];

// Original question indices from full DASS-42
final questionIndices = [2, 4, 7, 9, 15, 19, 20, 23, 25, 28, 30, 36, 40, 41];

class DassAnxietyQuestions extends FormBloc<String, String> {
  final questionList = ListFieldBloc<SelectFieldBloc, dynamic>(
    name: 'questionList',
    fieldBlocs: List.generate(
      14,
      (index) => SelectFieldBloc(
        name: '$index',
        validators: [FieldBlocValidators.required],
        items: ['0', '1', '2', '3'],
      ),
    ),
  );

  DassAnxietyQuestions() {
    addFieldBlocs(fieldBlocs: [questionList]);
  }

  @override
  void onSubmitting() async {
    int index;
    for (int i = 0; i < 14; i++) {
      index = optionsThree.indexOf(questionList.state.fieldBlocs[i].value);
      studentTestResults.anxietyDass = studentTestResults.anxietyDass + index;
      // Store with original question number
      studentTestResults.dass =
          "${studentTestResults.dass},${questionIndices[i]}:$index";
    }
    await Future.delayed(Duration(milliseconds: 500), () {});
    emitSuccess();
  }
}

class DassAnxietySection extends StatelessWidget {
  DassAnxietySection({super.key});

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => DassAnxietyQuestions(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<DassAnxietyQuestions>();

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: FormBlocListener<DassAnxietyQuestions, String, String>(
              onSubmitting: (context, state) {
                OverlayLoader.show(context);
              },
              onSuccess: (context, state) {
                OverlayLoader.hide(context);
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: false,
                    builder: (BuildContext context) => DassStressSection(),
                  ),
                );
              },
              onFailure: (context, state) {},
              child: SafeArea(
                child: Column(
                  children: [
                    // Clean Assessment Header
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        border: Border(
                          bottom: BorderSide(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row with title and exit button
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "DASS Assessment",
                                        style: TextStyle(
                                          fontSize: height * 0.028,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Anxiety Scale",
                                        style: TextStyle(
                                          fontSize: height * 0.018,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Exit Button
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.error.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Exit Assessment?',
                                            ),
                                            content: const Text(
                                              'Are you sure you want to quit? Your progress will be lost.',
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(
                                                    context,
                                                    rootNavigator: false,
                                                  ).push(
                                                    CupertinoPageRoute<bool>(
                                                      fullscreenDialog: false,
                                                      builder:
                                                          (
                                                            BuildContext
                                                            context,
                                                          ) => HomeScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Exit',
                                                  style: TextStyle(
                                                    color: colorScheme.error,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: height * 0.028,
                                      color: colorScheme.error,
                                    ),
                                    tooltip: 'Exit Assessment',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Progress Section
                            Row(
                              children: [
                                // Section Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.psychology_rounded,
                                        size: height * 0.018,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Section 2 of 3",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: height * 0.016,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Progress bar
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: 0.67,
                                          minHeight: 8,
                                          backgroundColor: colorScheme.secondary
                                              .withValues(alpha: 0.15),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                colorScheme.secondary,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "67% Complete",
                                        style: TextStyle(
                                          fontSize: height * 0.014,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                          fontWeight: FontWeight.w500,
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
                    ),

                    // Instructions Card
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.secondary.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: colorScheme.secondary,
                              size: height * 0.03,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "During the last week, how much did the following statements apply to you?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: height * 0.02,
                                  height: 1.4,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Questions List
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child:
                              BlocBuilder<
                                ListFieldBloc<SelectFieldBloc, dynamic>,
                                ListFieldBlocState<SelectFieldBloc, dynamic>
                              >(
                                bloc: formBloc.questionList,
                                builder: (context, state) {
                                  if (state.fieldBlocs.isNotEmpty) {
                                    return Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: state.fieldBlocs.length,
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  // Question Number Badge
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          colorScheme.secondary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "Question ${i + 1} of 14",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            height * 0.016,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  // Question Text
                                                  Text(
                                                    questions[i],
                                                    style: TextStyle(
                                                      color:
                                                          colorScheme.onSurface,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: height * 0.022,
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  // Radio Options
                                                  Theme(
                                                    data: Theme.of(context).copyWith(
                                                      inputDecorationTheme:
                                                          InputDecorationTheme(
                                                            filled: false,
                                                            fillColor: Colors
                                                                .transparent,
                                                            border: InputBorder
                                                                .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                          ),
                                                    ),
                                                    child: RadioButtonGroupFieldBlocBuilder(
                                                      selectFieldBloc:
                                                          state.fieldBlocs[i],
                                                      itemBuilder: (context, dynamic value) {
                                                        final isSelected =
                                                            state
                                                                .fieldBlocs[i]
                                                                .value ==
                                                            value;

                                                        // Map values to labels
                                                        String label;
                                                        switch (value) {
                                                          case '0':
                                                            label =
                                                                '0 - Not at all';
                                                            break;
                                                          case '1':
                                                            label =
                                                                '1 - Sometimes';
                                                            break;
                                                          case '2':
                                                            label = '2 - Often';
                                                            break;
                                                          case '3':
                                                            label =
                                                                '3 - Almost always';
                                                            break;
                                                          default:
                                                            label = value;
                                                        }

                                                        return FieldItem(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  vertical: 4,
                                                                  horizontal: 8,
                                                                ),
                                                            child: Text(
                                                              label,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    height *
                                                                    0.019,
                                                                color:
                                                                    isSelected
                                                                    ? colorScheme
                                                                          .secondary
                                                                    : colorScheme
                                                                          .onSurface,
                                                                fontWeight:
                                                                    isSelected
                                                                    ? FontWeight
                                                                          .w600
                                                                    : FontWeight
                                                                          .normal,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        // Submit Button inside scrollable area
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                formBloc.submit();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    colorScheme.secondary,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                elevation: 2,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_rounded,
                                                    size: height * 0.024,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "Continue to Stress",
                                                    style: TextStyle(
                                                      fontSize: height * 0.022,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    );
                                  }
                                  return Container();
                                },
                              ),
                        ),
                      ),
                    ),

                    // Bottom branding
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Puducherry Technological University',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: height * 0.016,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
