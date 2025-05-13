import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/assessment_result.dart';
import '../services/progress_service.dart';
import '../controllers/learning_controller.dart';
import 'dart:async';

class CoachingController extends GetxController {
  final ProgressService _progressService = ProgressService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _refreshTimer;

  final RxBool hasCompletedAssessment = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<AssessmentResult?> lastAssessmentResult =
      Rx<AssessmentResult?>(null);

  // Add fields for post-assessment
  final RxBool canTakePostAssessment = false.obs;
  final RxBool hasCompletedPostAssessment = false.obs;
  final Rx<AssessmentResult?> lastPostAssessmentResult =
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

    // Start a periodic refresh timer to check for module completion
    // This ensures the UI is updated even if there's an issue with direct controller communication
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_auth.currentUser != null && !isLoading.value) {
        print("CoachingController: Running scheduled refresh check");
        _checkPostAssessmentEligibility();
      }
    });
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  // Method to check if post-assessment can be taken without loading all user data
  Future<void> _checkPostAssessmentEligibility() async {
    try {
      if (!hasCompletedAssessment.value || lastAssessmentResult.value == null) {
        return; // Skip if no pre-assessment has been completed
      }

      // Only check if post-assessment is not already completed
      if (!hasCompletedPostAssessment.value) {
        if (Get.isRegistered<LearningController>()) {
          final learningController = Get.find<LearningController>();
          await learningController.refreshProgressFromFirestore();

          // Check if required modules are completed
          final oldValue = canTakePostAssessment.value;
          final newValue = _checkRequiredModulesCompleted(learningController);

          if (oldValue != newValue) {
            print(
                "CoachingController: Post-assessment eligibility changed from $oldValue to $newValue");
            canTakePostAssessment.value = newValue;
            update(); // Force UI update
          }
        }
      }
    } catch (e) {
      print('Error checking post-assessment eligibility: $e');
    }
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

      // Find the latest pre-assessment result and post-assessment result
      AssessmentResult? latestPreAssessment;
      AssessmentResult? latestPostAssessment;

      for (var result in userProgress.assessmentResults) {
        if (result.isPostAssessment) {
          if (latestPostAssessment == null ||
              result.timestamp.isAfter(latestPostAssessment.timestamp)) {
            latestPostAssessment = result;
          }
        } else {
          if (latestPreAssessment == null ||
              result.timestamp.isAfter(latestPreAssessment.timestamp)) {
            latestPreAssessment = result;
          }
        }
      }

      // Set pre-assessment result
      if (latestPreAssessment != null) {
        lastAssessmentResult.value = latestPreAssessment;
        hasCompletedAssessment.value = true;

        print(
            "CoachingController: Found pre-assessment result with score: ${lastAssessmentResult.value?.overallScore}");

        // Also load recommended modules based on this assessment
        if (Get.isRegistered<LearningController>()) {
          final learningController = Get.find<LearningController>();
          await learningController
              .loadRecommendedModules(lastAssessmentResult.value!);
        }
      } else {
        print("CoachingController: No pre-assessment results found for user");
        hasCompletedAssessment.value = false;
        lastAssessmentResult.value = null;
      }

      // Set post-assessment result
      if (latestPostAssessment != null) {
        lastPostAssessmentResult.value = latestPostAssessment;
        hasCompletedPostAssessment.value = true;
        print(
            "CoachingController: Found post-assessment result with score: ${lastPostAssessmentResult.value?.overallScore}");
      } else {
        print("CoachingController: No post-assessment results found for user");
        hasCompletedPostAssessment.value = false;
        lastPostAssessmentResult.value = null;
      }

      // Make sure to refresh the learning controller first
      if (Get.isRegistered<LearningController>()) {
        final learningController = Get.find<LearningController>();
        await learningController.refreshProgressFromFirestore();

        // Then check if required modules are completed AFTER progress is refreshed
        canTakePostAssessment.value =
            _checkRequiredModulesCompleted(learningController);

        print(
            "CoachingController: Post-assessment availability updated: ${canTakePostAssessment.value}");
      }

      isLoading.value = false;
      update(); // Force update on all widgets using this controller
    } catch (e) {
      print('Error loading user data: $e');
      isLoading.value = false;
    }
  }

  // Helper method to check if required modules are completed
  bool _checkRequiredModulesCompleted(LearningController controller) {
    // Get recommended modules from pre-assessment
    final recommendedModules = lastAssessmentResult.value?.recommendations
            .where((rec) =>
                rec.learningModuleId != null &&
                rec.learningModuleId!.isNotEmpty)
            .map((rec) => rec.learningModuleId!)
            .toList() ??
        [];

    // Get modules based on related content
    final relatedModules = lastAssessmentResult.value?.recommendations
            .where((rec) => rec.relatedContentIds.isNotEmpty)
            .expand((rec) => rec.relatedContentIds)
            .where((id) => id.isNotEmpty)
            .toList() ??
        [];

    // Combine all required module IDs (using a Set to eliminate duplicates)
    final allRequiredModules = <String>{};
    allRequiredModules.addAll(recommendedModules);
    allRequiredModules.addAll(relatedModules);

    // Filter out any empty strings
    allRequiredModules.removeWhere((moduleId) => moduleId.isEmpty);

    // If no valid recommended modules found, check a default set
    if (allRequiredModules.isEmpty) {
      final defaultRequired = [
        'module_academic_improvement',
        'module_essay_writing',
        'module_leadership_development'
      ];

      print(
          "CoachingController: Using default required modules: $defaultRequired");

      // Verify the module exists before checking completion
      final existingModules = defaultRequired
          .where((moduleId) => controller.getModuleById(moduleId) != null)
          .toList();

      if (existingModules.isEmpty) {
        print(
            "CoachingController: No valid modules found, allowing post-assessment");
        canTakePostAssessment.value = true;
        return true;
      }

      final allCompleted = existingModules
          .every((moduleId) => controller.completedModules.contains(moduleId));

      // Update observable
      print(
          "CoachingController: Default modules completion status: $allCompleted");
      canTakePostAssessment.value = allCompleted;
      return allCompleted;
    }

    // Log the required modules and completion status
    print("CoachingController: Required modules to unlock post-assessment:");
    int completedCount = 0;

    // Filter to only include modules that actually exist
    final validModules = allRequiredModules
        .where((moduleId) => controller.getModuleById(moduleId) != null)
        .toList();

    // If no valid modules found (they might have been removed/renamed), allow post-assessment
    if (validModules.isEmpty) {
      print(
          "CoachingController: No valid modules found, allowing post-assessment");
      canTakePostAssessment.value = true;
      return true;
    }

    for (final moduleId in validModules) {
      final isCompleted = controller.completedModules.contains(moduleId);
      if (isCompleted) completedCount++;
      print("  - $moduleId: ${isCompleted ? 'Completed' : 'Not completed'}");
    }

    // Check if all required modules are completed
    final allCompleted = validModules
        .every((moduleId) => controller.completedModules.contains(moduleId));

    print(
        "CoachingController: Completed $completedCount/${validModules.length} required modules");
    print("CoachingController: Post-assessment unlock status: $allCompleted");

    // Update observable
    canTakePostAssessment.value = allCompleted;
    return allCompleted;
  }

  Future<void> saveAssessmentResult(AssessmentResult result) async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        Get.offAllNamed('/login'); // Redirect to login if not authenticated
        throw Exception('Authentication required to save assessment results');
      }

      await _progressService.saveAssessmentResult(userId, result);

      if (result.isPostAssessment) {
        lastPostAssessmentResult.value = result;
        hasCompletedPostAssessment.value = true;
      } else {
        lastAssessmentResult.value = result;
        hasCompletedAssessment.value = true;
      }

      // Refresh can take post assessment status
      if (Get.isRegistered<LearningController>()) {
        final learningController = Get.find<LearningController>();
        canTakePostAssessment.value =
            _checkRequiredModulesCompleted(learningController);
      }

      update(); // Force UI update
    } catch (e) {
      print('Error saving assessment result: $e');
    }
  }

  void startPreAssessment() {
    Get.toNamed('/coaching/assessment');
  }

  // Add method to start post-assessment
  void startPostAssessment() {
    if (canTakePostAssessment.value) {
      Get.toNamed('/coaching/post-assessment');
    } else {
      Get.snackbar(
        'Complete Required Modules',
        'You need to complete all recommended modules before taking the post-assessment.',
        backgroundColor: Colors.amber,
        colorText: Colors.black,
      );
    }
  }

  void viewLearningPlan() {
    if (lastAssessmentResult.value != null) {
      Get.toNamed('/coaching/learning-plan',
          arguments: {'result': lastAssessmentResult.value});
    }
  }
}
