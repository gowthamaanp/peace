import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_form_plus/flutter_bloc_form.dart';
import 'package:peace/widgets/loading_widget.dart';
import 'package:peace/models/test_results.dart';
import 'package:peace/screens/home_screen.dart';
import 'package:peace/screens/assessments/dass/dass_success_screen.dart';

final questions = [
  "I found myself getting upset by quite trivial things",
  "I tended to over-react to situations",
  "I found it difficult to relax",
  "I found myself getting upset rather easily",
  "I felt that I was using a lot of nervous energy",
  "I found myself getting impatient when I was delayed in any way (eg, lifts, traffic lights, being kept waiting)",
  "I felt that I was rather touchy",
  "I found it hard to wind down",
  "I found it hard to calm down after something upset me",
  "I found it difficult to tolerate interruptions to what I was doing",
  "I was in a state of nervous tension",
  "I was intolerant of anything that kept me from getting on with what I was doing",
  "I found myself getting agitated",
  "I found it difficult to work up the initiative to do things",
];

// Original question indices from full DASS-42
final questionIndices = [1, 6, 8, 11, 12, 14, 18, 22, 27, 29, 32, 33, 35, 39];

class DassStressQuestions extends FormBloc<String, String> {
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

  DassStressQuestions() {
    addFieldBlocs(fieldBlocs: [questionList]);
  }

  @override
  void onSubmitting() async {
    int index;
    for (int i = 0; i < 14; i++) {
      index = optionsThree.indexOf(questionList.state.fieldBlocs[i].value);
      studentTestResults.stressDass = studentTestResults.stressDass + index;
      // Store with original question number
      studentTestResults.dass =
          "${studentTestResults.dass},${questionIndices[i]}:$index";
    }
    await Future.delayed(Duration(milliseconds: 500), () {});
    emitSuccess();
  }
}

class DassStressSection extends StatelessWidget {
  DassStressSection({super.key});

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => DassStressQuestions(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<DassStressQuestions>();

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: FormBlocListener<DassStressQuestions, String, String>(
              onSubmitting: (context, state) {
                OverlayLoader.show(context);
              },
              onSuccess: (context, state) {
                OverlayLoader.hide(context);
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: false,
                    builder: (BuildContext context) => SuccessScreen(),
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
                                        "Stress Scale",
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
                                    color: Colors.green.shade600,
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
                                        "Section 3 of 3",
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
                                          value: 1.0,
                                          minHeight: 8,
                                          backgroundColor:
                                              Colors.green.shade100,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.green.shade600,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Final Section",
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
                            color: Colors.green.shade600.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Colors.green.shade600,
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
                                                          Colors.green.shade600,
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
                                                                    ? Colors
                                                                          .green
                                                                          .shade600
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
                                                    Colors.green.shade600,
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
                                                    Icons
                                                        .check_circle_outline_rounded,
                                                    size: height * 0.024,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "Complete DASS Assessment",
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
