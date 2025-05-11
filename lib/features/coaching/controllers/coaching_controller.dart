import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/assessment_result.dart';
import '../services/progress_service.dart';
import '../controllers/learning_controller.dart';

class CoachingController extends GetxController {
  final ProgressService _progressService = ProgressService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool hasCompletedAssessment = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<AssessmentResult?> lastAssessmentResult =
      Rx<AssessmentResult?>(null);

  // Get current user ID from Firebase Auth
  String get userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }
    return user.uid;
  }

  @override
  void onInit() {
    super.onInit();

    // Ensure the user is authenticated before initializing
    if (_auth.currentUser == null) {
      // Delay redirect slightly to allow controller initialization to complete
      Future.delayed(Duration.zero, () {
        Get.offAllNamed('/login');
      });
      return;
    }

    print(
        "CoachingController: initializing for user ${_auth.currentUser?.uid}");
    loadUserData();

    // Listen for authentication state changes
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        // If user signs out while using the app, redirect to login
        print("CoachingController: User signed out");
        Get.offAllNamed('/login');
      } else {
        // Reload user data when authentication state changes
        print("CoachingController: User signed in: ${user.uid}");
        loadUserData();
      }
    });
  }

  Future<void> loadUserData() async {
    try {
      print("CoachingController: Loading user data from Firestore");
      isLoading.value = true;

      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        Get.offAllNamed('/login'); // Redirect to login if not authenticated
        throw Exception('Authentication required to access coaching features');
      }

      final userID = _auth.currentUser!.uid;
      print("CoachingController: Getting progress for user $userID");

      final userProgress = await _progressService.getUserProgress(userID);
      print(
          "CoachingController: Got user progress, assessment results count: ${userProgress.assessmentResults.length}");

      if (userProgress.assessmentResults.isNotEmpty) {
        lastAssessmentResult.value = userProgress.assessmentResults.last;
        hasCompletedAssessment.value = true;

        print(
            "CoachingController: Found assessment result with score: ${lastAssessmentResult.value?.overallScore}");

        // Also load recommended modules based on this assessment
        if (Get.isRegistered<LearningController>()) {
          final learningController = Get.find<LearningController>();
          await learningController
              .loadRecommendedModules(lastAssessmentResult.value!);
        }
      } else {
        print("CoachingController: No assessment results found for user");
        hasCompletedAssessment.value = false;
        lastAssessmentResult.value = null;
      }

      // Also refresh learning controller data if it exists
      if (Get.isRegistered<LearningController>()) {
        final learningController = Get.find<LearningController>();
        await learningController.refreshProgressFromFirestore();
      }

      isLoading.value = false;
    } catch (e) {
      print('Error loading user data: $e');
      isLoading.value = false;
    }
  }

  Future<void> saveAssessmentResult(AssessmentResult result) async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        Get.offAllNamed('/login'); // Redirect to login if not authenticated
        throw Exception('Authentication required to save assessment results');
      }

      await _progressService.saveAssessmentResult(userId, result);
      lastAssessmentResult.value = result;
      hasCompletedAssessment.value = true;
    } catch (e) {
      print('Error saving assessment result: $e');
    }
  }

  void startPreAssessment() {
    Get.toNamed('/coaching/assessment', arguments: {'isPreAssessment': true});
  }

  void startPostAssessment() {
    Get.toNamed('/coaching/assessment', arguments: {'isPreAssessment': false});
  }

  void viewLearningPlan() {
    if (lastAssessmentResult.value != null) {
      Get.toNamed('/coaching/learning-plan',
          arguments: {'result': lastAssessmentResult.value});
    }
  }
}
