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
      return _contentData.learningModules.firstWhere((module) => module.id == id);
    } catch (e) {
      return null;
    }
  }

  List<LearningModule> getRecommendedModules(AssessmentResult result) {
    List<String> recommendedModuleIds = [];

    // Collect all module IDs from recommendations
    for (var recommendation in result.recommendations) {
      recommendedModuleIds.addAll(recommendation.relatedContentIds);
    }

    // Get modules by IDs
    List<LearningModule> recommendedModules = [];
    for (String id in recommendedModuleIds) {
      LearningModule? module = getModuleById(id);
      if (module != null) {
        recommendedModules.add(module);
      }
    }

    return recommendedModules;
  }

// Additional methods for tracking progress, marking modules as completed, etc.
}