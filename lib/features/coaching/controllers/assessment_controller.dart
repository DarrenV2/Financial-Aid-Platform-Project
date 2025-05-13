import 'package:get/get.dart';
import '../models/question.dart';
import '../models/answer.dart';
import '../models/assessment_result.dart';
import '../services/assessment_service.dart';

class AssessmentController extends GetxController {
  final AssessmentService _assessmentService = AssessmentService();

  final RxBool isLoading = false.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxMap<String, dynamic> answers = <String, dynamic>{}.obs;
  final RxList<Question> questions = <Question>[].obs;
  final RxBool isPostAssessment = false.obs;

  void initPreAssessment() {
    isPostAssessment.value = false;
    questions.value = _assessmentService.getPreAssessmentQuestions();
    resetAssessment();
  }

  void initPostAssessment() {
    isPostAssessment.value = true;
    questions.value = _assessmentService.getPostAssessmentQuestions();
    resetAssessment();
  }

  void resetAssessment() {
    currentQuestionIndex.value = 0;
    answers.clear();
  }

  void saveAnswer(String questionId, dynamic value) {
    answers[questionId] = value;
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  void goToNextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    }
  }

  bool isCurrentQuestionAnswered() {
    if (questions.isEmpty) return true;

    String currentQuestionId = questions[currentQuestionIndex.value].id;
    bool isRequired = questions[currentQuestionIndex.value].required;

    return !isRequired || answers.containsKey(currentQuestionId);
  }

  bool areAllRequiredQuestionsAnswered() {
    for (Question question in questions) {
      if (question.required && !answers.containsKey(question.id)) {
        return false;
      }
    }
    return true;
  }

  Future<AssessmentResult?> submitAssessment() async {
    if (!areAllRequiredQuestionsAnswered()) {
      return null;
    }

    isLoading.value = true;

    // Convert answers to Answer objects
    List<Answer> answerObjects = [];
    answers.forEach((questionId, value) {
      answerObjects.add(Answer(
        questionId: questionId,
        value: value,
      ));
    });

    AssessmentResult result;
    if (isPostAssessment.value) {
      result = await _assessmentService.evaluatePostAssessment(answerObjects);
    } else {
      result = await _assessmentService.evaluatePreAssessment(answerObjects);
    }

    isLoading.value = false;
    return result;
  }
}
