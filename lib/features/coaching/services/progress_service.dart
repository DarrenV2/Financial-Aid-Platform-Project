import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_progress.dart';
import '../models/assessment_result.dart';
import '../data/progress_repository.dart';

class ProgressService {
  final IProgressRepository _repository;

  // Use dependency injection for better testability
  ProgressService({IProgressRepository? repository})
      : _repository = repository ?? FirestoreProgressRepository();

  Future<UserProgress> getUserProgress(String userId) async {
    return await _repository.getUserProgress(userId);
  }

  Future<void> updateModuleProgress(
      String userId, String moduleId, double progress) async {
    await _repository.updateModuleProgress(userId, moduleId, progress);
  }

  Future<void> markModuleCompleted(String userId, String moduleId) async {
    await _repository.markModuleCompleted(userId, moduleId);
  }

  Future<void> saveAssessmentResult(
      String userId, AssessmentResult result) async {
    await _repository.saveAssessmentResult(userId, result);
  }

  // New method to update existing recommendations with proper module IDs
  Future<void> updateRecommendationModuleIds(String userId) async {
    try {
      // Get current user progress
      UserProgress progress = await getUserProgress(userId);

      if (progress.assessmentResults.isEmpty) return;

      // Get the most recent assessment result
      AssessmentResult latestResult = progress.assessmentResults.last;
      bool needsUpdate = false;

      // Check if any recommendations need updates
      for (var rec in latestResult.recommendations) {
        if (rec.learningModuleId == null || rec.relatedContentIds.isEmpty) {
          needsUpdate = true;
          break;
        }
      }

      if (needsUpdate) {
        // Create updated recommendations with proper module IDs based on categories
        List<Recommendation> updatedRecommendations = [];

        for (var rec in latestResult.recommendations) {
          List<String> relatedIds = [];
          String? moduleId;

          // Set module IDs based on category
          switch (rec.category?.toLowerCase() ?? 'general') {
            case 'academic':
              moduleId = 'module_academic_improvement';
              relatedIds = [
                'module_academic_improvement',
                'module_essay_writing'
              ];
              break;
            case 'financial':
              moduleId = 'module_essay_writing';
              relatedIds = [
                'module_essay_writing',
                'module_application_strategy'
              ];
              break;
            case 'leadership':
              moduleId = 'module_leadership_development';
              relatedIds = [
                'module_leadership_development',
                'module_community_service'
              ];
              break;
            case 'extracurricular':
              moduleId = 'module_leadership_development';
              relatedIds = [
                'module_leadership_development',
                'module_community_service'
              ];
              break;
            case 'community_service':
              moduleId = 'module_community_service';
              relatedIds = [
                'module_community_service',
                'module_leadership_development'
              ];
              break;
            case 'personal':
              moduleId = 'module_personal_statement';
              relatedIds = [
                'module_personal_statement',
                'module_personal_branding'
              ];
              break;
            case 'strategy':
              moduleId = 'module_application_strategy';
              relatedIds = [
                'module_application_strategy',
                'module_essay_writing'
              ];
              break;
            default:
              moduleId = 'module_essay_writing';
              relatedIds = [
                'module_essay_writing',
                'module_application_strategy'
              ];
          }

          // Create updated recommendation
          updatedRecommendations.add(
            Recommendation(
              id: rec.id,
              title: rec.title,
              description: rec.description,
              category: rec.category ?? 'general',
              priority: rec.priority,
              action: rec.action,
              learningModuleId: moduleId,
              relatedContentIds: relatedIds,
            ),
          );
        }

        // Create updated assessment result
        AssessmentResult updatedResult = AssessmentResult(
          timestamp: latestResult.timestamp,
          overallScore: latestResult.overallScore,
          categoryScores: latestResult.categoryScores,
          recommendations: updatedRecommendations,
          eligibility: latestResult.eligibility,
        );

        // Save the updated assessment result
        await saveAssessmentResult(userId, updatedResult);

        print('Updated recommendations with proper module IDs');
      }
    } catch (e) {
      print('Error updating recommendation module IDs: $e');
    }
  }
}
