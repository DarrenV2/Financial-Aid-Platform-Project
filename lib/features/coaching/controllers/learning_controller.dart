import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/learning_module.dart';
import '../models/assessment_result.dart';
import '../services/learning_service.dart';
import '../services/progress_service.dart';

class LearningController extends GetxController {
  final LearningService _learningService = LearningService();
  final ProgressService _progressService = ProgressService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<LearningModule> recommendedModules = <LearningModule>[].obs;
  final RxList<LearningModule> allModules = <LearningModule>[].obs;
  final RxMap<String, double> moduleProgress = <String, double>{}.obs;
  final RxList<String> completedModules = <String>[].obs;
  final RxBool isLoading = true.obs;

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

    loadAllModules();

    // Load user progress when controller initializes
    refreshProgressFromFirestore();

    // Listen for authentication state changes
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        // If user signs out while using the app, redirect to login
        Get.offAllNamed('/login');
      } else {
        // Refresh progress when user signs in
        refreshProgressFromFirestore();
      }
    });
  }

  void loadAllModules() {
    allModules.value = _learningService.getAllModules();
  }

  Future<void> loadRecommendedModules(AssessmentResult result) async {
    try {
      isLoading.value = true;

      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        Get.offAllNamed('/login'); // Redirect to login if not authenticated
        throw Exception('Authentication required to access learning modules');
      }

      // Debug: Print recommendations and their module IDs
      print('Loading recommendations:');
      for (var rec in result.recommendations) {
        print('Recommendation: ${rec.title}');
        print('  - Category: ${rec.category}');
        print('  - LearningModuleId: ${rec.learningModuleId}');
        print('  - RelatedContentIds: ${rec.relatedContentIds}');
      }

      // Fetch data first
      final userProgress = await _progressService.getUserProgress(userId);
      final modules = _learningService.getRecommendedModules(result);

      // Debug: Print found modules
      print('Found ${modules.length} modules:');
      for (var module in modules) {
        print('  - ${module.id}: ${module.title} (${module.category})');
      }

      // Then update UI all at once to avoid partial updates during build
      Future.microtask(() {
        recommendedModules.value = modules;
        moduleProgress.value = userProgress.moduleProgress;
        completedModules.value = userProgress.completedModules;
        isLoading.value = false;
      });
    } catch (e) {
      print('Error loading recommended modules: $e');
      Future.microtask(() {
        isLoading.value = false;
      });
    }
  }

  LearningModule? getModuleById(String id) {
    return _learningService.getModuleById(id);
  }

  Future<void> updateModuleProgress(String moduleId, double progress) async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        Get.offAllNamed('/login'); // Redirect to login if not authenticated
        throw Exception('Authentication required to update module progress');
      }

      await _progressService.updateModuleProgress(userId, moduleId, progress);

      // Update UI after the async operation completes
      Future.microtask(() {
        moduleProgress[moduleId] = progress;
      });

      // If module is completed
      if (progress >= 100) {
        await _progressService.markModuleCompleted(userId, moduleId);

        // Update UI after the async operation completes
        Future.microtask(() {
          if (!completedModules.contains(moduleId)) {
            completedModules.add(moduleId);
          }
        });
      }
    } catch (e) {
      // Silently handle errors
    }
  }

  List<LearningModule> getModulesByCategory(String category) {
    return allModules.where((module) => module.category == category).toList();
  }

  // Method to force refresh data from Firestore
  Future<void> refreshProgressFromFirestore() async {
    try {
      // Don't set isLoading inside this function as it might be called during build

      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        Get.offAllNamed('/login'); // Redirect to login if not authenticated
        throw Exception('Authentication required to refresh progress data');
      }

      // Update recommendation module IDs first if needed
      await _progressService.updateRecommendationModuleIds(userId);

      // Get latest progress from Firestore
      final userProgress = await _progressService.getUserProgress(userId);

      // Update local state using microtask to avoid build-time issues
      Future.microtask(() {
        moduleProgress.value = userProgress.moduleProgress;
        completedModules.value = userProgress.completedModules;

        // If there's at least one assessment result, also load recommended modules
        if (userProgress.assessmentResults.isNotEmpty) {
          // Use the most recent assessment result to load recommended modules
          final modules = _learningService
              .getRecommendedModules(userProgress.assessmentResults.last);
          recommendedModules.value = modules;
        }
      });
    } catch (e) {
      // Silently handle errors
    }
  }
}
