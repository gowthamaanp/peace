import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_form_plus/flutter_bloc_form.dart';
import 'package:peace/screens/home_screen.dart';
import 'package:peace/screens/assessments/phq/phq_section_d_screen.dart';
import 'package:peace/screens/assessments/phq/phq_section_e_screen.dart';

final questions = [
  "Has this ever happened before?",
  "Do some of these attacks come suddenly out of the blue ⎯ that is, in situations where you don’t expect to be nervous or uncomfortable?",
  "Do these attacks bother you a lot or are you worried about having another attack?",
  "During your last bad anxiety attack, did you have symptoms like shortness of breath, sweating, or your heart racing, pounding or skipping?",
];

class PHQSectionCQuestions extends FormBloc<String, String> {
  final questionOne = SelectFieldBloc(
    validators: [FieldBlocValidators.required],
    items: ['No', 'Yes'],
  );

  final questionList = ListFieldBloc<SelectFieldBloc, dynamic>(
    name: 'questionList',
  );

  PHQSectionCQuestions() {
    addFieldBlocs(fieldBlocs: [questionOne]);
    questionOne.onValueChanges(
      onData: (previous, current) async* {
        for (int i = 0; i < 4; i++) {
          questionList.removeFieldBlocsWhere((element) => true);
        }
        removeFieldBlocs(fieldBlocs: [questionList]);

        if (current.value == 'No') {
        } else if (current.value == 'Yes') {
          for (int i = 0; i < 4; i++) {
            questionList.addFieldBloc(
              SelectFieldBloc(
                name: '$i',
                validators: [FieldBlocValidators.required],
                items: ['Yes', 'No'],
              ),
            );
          }
          addFieldBlocs(fieldBlocs: [questionList]);
        }
      },
    );
  }

  @override
  void onSubmitting() {
    emitSuccess();
  }
}

class PHQSectionC extends StatelessWidget {
  PHQSectionC({super.key});

  final _scrollController = ScrollController(initialScrollOffset: 0.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => PHQSectionCQuestions(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<PHQSectionCQuestions>();

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: FormBlocListener<PHQSectionCQuestions, String, String>(
              onSubmitting: (context, state) {},
              onSuccess: (context, state) {
                if (formBloc.questionOne.value == 'Yes') {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<bool>(
                      fullscreenDialog: false,
                      builder: (BuildContext context) => PHQSectionD(),
                    ),
                  );
                } else {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<bool>(
                      fullscreenDialog: false,
                      builder: (BuildContext context) => PHQSectionE(),
                    ),
                  );
                }
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
                                        "Health Assessment",
                                        style: TextStyle(
                                          fontSize: height * 0.028,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Anxiety & Panic Assessment",
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
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.filter_drama_outlined,
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
                                          backgroundColor: colorScheme.primary
                                              .withValues(alpha: 0.15),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                colorScheme.primary,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "100% Complete",
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
                            color: colorScheme.primary.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: colorScheme.primary,
                              size: height * 0.03,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "In the last 4 weeks, have you had an anxiety attack ⎯  suddenly feeling fear or panic?",
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
                          child: Column(
                            children: [
                              // First Question Card
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                              filled: false,
                                              fillColor: Colors.transparent,
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                      ),
                                      child: RadioButtonGroupFieldBlocBuilder(
                                        selectFieldBloc: formBloc.questionOne,
                                        itemBuilder: (context, dynamic value) {
                                          final isSelected =
                                              formBloc.questionOne.value ==
                                              value;
                                          return FieldItem(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 8,
                                                  ),
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontSize: height * 0.02,
                                                  color: isSelected
                                                      ? colorScheme.primary
                                                      : colorScheme.onSurface,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Dynamic Follow-up Questions
                              BlocBuilder<
                                ListFieldBloc<SelectFieldBloc, dynamic>,
                                ListFieldBlocState<SelectFieldBloc, dynamic>
                              >(
                                bloc: formBloc.questionList,
                                builder: (context, state) {
                                  if (state.fieldBlocs.isNotEmpty) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: state.fieldBlocs.length,
                                      itemBuilder: (context, i) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
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
                                                  color: colorScheme.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  "Follow-up ${i + 1} of 4",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: height * 0.016,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              // Question Text
                                              Text(
                                                questions[i],
                                                style: TextStyle(
                                                  color: colorScheme.onSurface,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: height * 0.022,
                                                  height: 1.3,
                                                ),
                                              ),
                                              // Radio Options
                                              Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
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
                                                  itemBuilder: (context, value) {
                                                    final isSelected =
                                                        state
                                                            .fieldBlocs[i]
                                                            .value ==
                                                        value;
                                                    return FieldItem(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 4,
                                                              horizontal: 8,
                                                            ),
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                            fontSize:
                                                                height * 0.02,
                                                            color: isSelected
                                                                ? colorScheme
                                                                      .primary
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
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    filled: false,
                                                    fillColor:
                                                        Colors.transparent,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              ),

                              const SizedBox(height: 16),
                              // Continue Button inside scrollable area
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
                                      backgroundColor: colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Continue to Next Section",
                                          style: TextStyle(
                                            fontSize: height * 0.022,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
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
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
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
