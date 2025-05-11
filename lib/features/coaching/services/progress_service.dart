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
}
