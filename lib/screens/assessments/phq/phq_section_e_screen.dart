import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_form_plus/flutter_bloc_form.dart';
import 'package:peace/screens/home_screen.dart';

import 'phq_success_screen.dart';

class PHQSectionEQuestions extends FormBloc<String, String> {
  final question = SelectFieldBloc(
    name: 'lastQuestion',
    validators: [FieldBlocValidators.required],
    items: [
      'Not difficult at all',
      'Somewhat difficult',
      'Very difficult',
      'Extremely difficult',
    ],
  );

  PHQSectionEQuestions() {
    addFieldBlocs(fieldBlocs: [question]);
  }

  @override
  void onSubmitting() {
    emitSuccess();
  }
}

class PHQSectionE extends StatelessWidget {
  const PHQSectionE({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => PHQSectionEQuestions(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<PHQSectionEQuestions>();

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: FormBlocListener<PHQSectionEQuestions, String, String>(
              onSubmitting: (context, state) {},
              onSuccess: (context, state) {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => const PhqSuccessScreen(),
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
                                        "Impact Assessment",
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
                                        Icons.done_all_rounded,
                                        size: height * 0.018,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Final Question",
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
                                // Info text
                                Expanded(
                                  child: Text(
                                    "Almost done!",
                                    style: TextStyle(
                                      fontSize: height * 0.014,
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
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
                                "If you checked off any problems on this questionnaire, how difficult have these problems made it for you to do your work, take care of things at home, or get along with other people?",
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

                    // Final Question Card
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
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
                                      selectFieldBloc: formBloc.question,
                                      itemBuilder: (context, value) {
                                        final isSelected =
                                            formBloc.question.value == value;
                                        return FieldItem(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
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

                                  // Radio Options
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Submit Button
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
                                    backgroundColor: Colors.green.shade600,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: height * 0.024,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Complete Assessment",
                                        style: TextStyle(
                                          fontSize: height * 0.022,
                                          fontWeight: FontWeight.bold,
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
