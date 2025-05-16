import '../data/learning_content_data.dart';
import '../models/learning_module.dart';
import '../models/assessment_result.dart';
// import '../data/learning_content_data.dart.dart';

class LearningService {
  final LearningContentData _contentData = LearningContentData();

  List<LearningModule> getAllModules() {
    return _contentData.learningModules;
  }

  LearningModule? getModuleById(String id) {
    try {
      return _contentData.learningModules
          .firstWhere((module) => module.id == id);
    } catch (e) {
      return null;
    }
  }

  List<LearningModule> getRecommendedModules(AssessmentResult result) {
    List<String> recommendedModuleIds = [];
    List<String> missingModuleIds = [];
    Set<String> uniqueModuleIds = {};

    // Collect all module IDs from recommendations
    for (var recommendation in result.recommendations) {
      // Add related content IDs
      if (recommendation.relatedContentIds.isNotEmpty) {
        recommendedModuleIds.addAll(recommendation.relatedContentIds);
      }

      // Also add the primary learning module ID if it exists
      if (recommendation.learningModuleId != null) {
        recommendedModuleIds.add(recommendation.learningModuleId!);
      }
    }

    // Get modules by IDs
    List<LearningModule> recommendedModules = [];
    for (String id in recommendedModuleIds) {
      // Skip if we've already added this module to prevent duplicates
      if (uniqueModuleIds.contains(id)) continue;

      LearningModule? module = getModuleById(id);
      if (module != null) {
        recommendedModules.add(module);
        uniqueModuleIds.add(id); // Mark this ID as added
      } else {
        missingModuleIds.add(id);
      }
    }

    // No diagnostic logs in production

    return recommendedModules;
  }

// Additional methods for tracking progress, marking modules as completed, etc.
}
