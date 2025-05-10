import 'assessment_result.dart';

class UserProgress {
  final String userId;
  final Map<String, double> moduleProgress; // moduleId: progress percentage
  final List<String> completedModules;
  final List<AssessmentResult> assessmentResults;
  final DateTime lastUpdated;

  UserProgress({
    required this.userId,
    required this.moduleProgress,
    required this.completedModules,
    required this.assessmentResults,
    required this.lastUpdated,
  });
}