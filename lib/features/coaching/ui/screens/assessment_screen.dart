import 'package:flutter/material.dart';
import '../widgets/question_widget.dart';
import '../../models/question.dart';
import '../../models/answer.dart';
import '../../services/assessment_service.dart';
import 'assessment_result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  final bool isPreAssessment;

  const AssessmentScreen({Key? key, required this.isPreAssessment}) : super(key: key);

  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final AssessmentService _assessmentService = AssessmentService();
  late List<Question> questions;
  final Map<String, dynamic> answers = {};
  int currentQuestionIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Get questions based on assessment type
    questions = widget.isPreAssessment
        ? _assessmentService.getPreAssessmentQuestions()
        : _assessmentService.getPostAssessmentQuestions();
  }

  void _saveAnswer(String questionId, dynamic value) {
    setState(() {
      answers[questionId] = value;
    });
  }

  void _goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      // Check if current question is required and answered
      String currentQuestionId = questions[currentQuestionIndex].id;
      bool isRequired = questions[currentQuestionIndex].required;

      if (isRequired && !answers.containsKey(currentQuestionId)) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please answer this question before proceeding.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Submit the assessment
      _submitAssessment();
    }
  }

  Future<void> _submitAssessment() async {
    // Check if all required questions are answered
    bool allRequiredAnswered = true;
    List<String> unansweredQuestions = [];

    for (Question question in questions) {
      if (question.required && !answers.containsKey(question.id)) {
        allRequiredAnswered = false;
        unansweredQuestions.add(question.id);
      }
    }

    if (!allRequiredAnswered) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please answer all required questions before submitting.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Convert answers to Answer objects
    List<Answer> answerObjects = [];
    answers.forEach((questionId, value) {
      answerObjects.add(Answer(
        questionId: questionId,
        value: value,
      ));
    });

    if (widget.isPreAssessment) {
      // Process pre-assessment
      final result = await _assessmentService.evaluatePreAssessment(answerObjects);

      setState(() {
        isLoading = false;
      });

      // Navigate to results screen
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssessmentResultScreen(result: result),
        ),
      );
    } else {
      // Process post-assessment
      // This would typically update progress with new assessment
      // For simplicity, we're using a similar evaluation but would track progress
      final result = await _assessmentService.evaluatePreAssessment(answerObjects);

      setState(() {
        isLoading = false;
      });

      // Navigate to results screen with comparison to previous results
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssessmentResultScreen(
            result: result,
            isPostAssessment: true,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.isPreAssessment ? 'Pre-Assessment' : 'Post-Assessment'),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Processing your assessment...'),
            ],
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPreAssessment ? 'Scholarship Pre-Assessment' : 'Scholarship Post-Assessment'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            Text(
              'Question ${currentQuestionIndex + 1} of ${questions.length}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),

            // Category indicator if available
            if (currentQuestion.category != null)
              Chip(
                label: Text(
                  _formatCategoryName(currentQuestion.category!),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _getCategoryColor(currentQuestion.category!),
              ),

            SizedBox(height: 20),

            // Question
            Text(
              currentQuestion.text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Description if available
            if (currentQuestion.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  currentQuestion.description!,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                ),
              ),

            SizedBox(height: 20),

            // Question input widget
            Expanded(
              child: SingleChildScrollView(
                child: QuestionWidget(
                  question: currentQuestion,
                  initialValue: answers[currentQuestion.id],
                  onChanged: (value) => _saveAnswer(currentQuestion.id, value),
                ),
              ),
            ),

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: currentQuestionIndex > 0 ? _goToPreviousQuestion : null,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _goToNextQuestion,
                  child: Text(currentQuestionIndex < questions.length - 1 ? 'Next' : 'Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCategoryName(String category) {
    return category.replaceAll('_', ' ').split(' ').map((word) =>
    word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ');
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        return Colors.purple;
      case 'academic':
        return Colors.blue;
      case 'financial':
        return Colors.green;
      case 'leadership':
        return Colors.orange;
      case 'extracurricular':
        return Colors.teal;
      case 'community_service':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
