// Add RecommendationPriority enum
enum RecommendationPriority {
  low(1),
  medium(3),
  high(5);

  final int value;
  const RecommendationPriority(this.value);

  int compareTo(RecommendationPriority other) {
    return value.compareTo(other.value);
  }
}

class AssessmentResult {
  final DateTime timestamp;
  final double overallScore;
  final Map<String, double> categoryScores;
  final List<Recommendation> recommendations;
  final ScholarshipEligibility eligibility;
  final String? readinessLevel; // Added for post-assessment
  final bool isPostAssessment; // Flag to identify post-assessment results

  AssessmentResult({
    required this.timestamp,
    required this.overallScore,
    required this.categoryScores,
    required this.recommendations,
    required this.eligibility,
    this.readinessLevel,
    this.isPostAssessment = false,
  });
}

class Recommendation {
  final String id;
  final String title;
  final String description;
  final String? category;
  final RecommendationPriority priority;
  final String? action;
  final String? learningModuleId;
  final List<String> relatedContentIds;

  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    required this.priority,
    this.action,
    this.learningModuleId,
    this.relatedContentIds = const [],
  });
}

class ScholarshipEligibility {
  final bool meritBased;
  final bool needBased;
  final double eligibilityScore; // 0-100%
  final Map<String, String> strengthAreas;
  final Map<String, String> improvementAreas;

  ScholarshipEligibility({
    required this.meritBased,
    required this.needBased,
    required this.eligibilityScore,
    required this.strengthAreas,
    required this.improvementAreas,
  });
}
