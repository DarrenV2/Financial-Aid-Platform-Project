class AssessmentResult {
  final DateTime timestamp;
  final double overallScore;
  final Map<String, double> categoryScores;
  final List<Recommendation> recommendations;
  final ScholarshipEligibility eligibility;

  AssessmentResult({
    required this.timestamp,
    required this.overallScore,
    required this.categoryScores,
    required this.recommendations,
    required this.eligibility,
  });
}

class Recommendation {
  final String id;
  final String title;
  final String description;
  final String category;
  final int priority; // 1-5, with 5 being highest priority
  final List<String> relatedContentIds;

  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
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
