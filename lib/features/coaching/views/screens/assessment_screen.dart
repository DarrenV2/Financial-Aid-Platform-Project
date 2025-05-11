import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/assessment_controller.dart';
import '../../controllers/coaching_controller.dart';
import '../widgets/question_widget.dart';

class AssessmentScreen extends StatefulWidget {
  final bool isPreAssessment;

  const AssessmentScreen({Key? key, required this.isPreAssessment})
      : super(key: key);

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  late final AssessmentController assessmentController;
  late final CoachingController coachingController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    assessmentController = Get.put(AssessmentController());
    coachingController = Get.find<CoachingController>();

    // Initialize the appropriate assessment
    if (widget.isPreAssessment) {
      assessmentController.initPreAssessment();
    } else {
      assessmentController.initPostAssessment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPreAssessment
            ? 'Scholarship Pre-Assessment'
            : 'Scholarship Post-Assessment'),
        elevation: 0,
      ),
      body: Obx(() {
        if (assessmentController.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Processing your assessment...'),
              ],
            ),
          );
        }

        if (assessmentController.questions.isEmpty) {
          return const Center(
            child: Text('No questions available. Please try again later.'),
          );
        }

        final currentQuestion = assessmentController
            .questions[assessmentController.currentQuestionIndex.value];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (assessmentController.currentQuestionIndex.value + 1) /
                    assessmentController.questions.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
              Text(
                'Question ${assessmentController.currentQuestionIndex.value + 1} of ${assessmentController.questions.length}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Category indicator if available
              if (currentQuestion.category != null)
                Chip(
                  label: Text(_formatCategoryName(currentQuestion.category!)),
                  backgroundColor: _getCategoryColor(currentQuestion.category!)
                      .withOpacity(0.2),
                  labelStyle: TextStyle(
                      color: _getCategoryColor(currentQuestion.category!)),
                ),
              const SizedBox(height: 16),

              // Question
              Expanded(
                child: SingleChildScrollView(
                  child: QuestionWidget(
                    question: currentQuestion,
                    value: assessmentController.answers[currentQuestion.id],
                    onChanged: (value) {
                      assessmentController.saveAnswer(
                          currentQuestion.id, value);
                    },
                  ),
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    Visibility(
                      visible:
                          assessmentController.currentQuestionIndex.value > 0,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: ElevatedButton(
                        onPressed: assessmentController.goToPreviousQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                        ),
                        child: const Text('Previous'),
                      ),
                    ),

                    // Next/Submit button
                    ElevatedButton(
                      onPressed: () async {
                        // If current question is required and not answered
                        if (!assessmentController.isCurrentQuestionAnswered()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please answer this question before proceeding.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // If this is the last question
                        if (assessmentController.currentQuestionIndex.value ==
                            assessmentController.questions.length - 1) {
                          // Submit the assessment
                          final result =
                              await assessmentController.submitAssessment();

                          if (result != null) {
                            // Save result to coaching controller
                            await coachingController
                                .saveAssessmentResult(result);

                            // Navigate to results screen
                            Get.offNamed(
                              '/coaching/results',
                              arguments: {
                                'result': result,
                                'isPostAssessment': !widget.isPreAssessment,
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please answer all required questions before submitting.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          // Go to next question
                          assessmentController.goToNextQuestion();
                        }
                      },
                      child: Text(
                        assessmentController.currentQuestionIndex.value ==
                                assessmentController.questions.length - 1
                            ? 'Submit'
                            : 'Next',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'academic':
        return Colors.blue;
      case 'financial':
        return Colors.green;
      case 'extracurricular':
        return Colors.purple;
      case 'leadership':
        return Colors.orange;
      case 'community_service':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
