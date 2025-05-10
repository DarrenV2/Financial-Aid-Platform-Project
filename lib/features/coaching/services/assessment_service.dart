
import '../data/assessment_data.dart';
import '../models/question.dart';
import '../models/answer.dart';
import '../models/assessment_result.dart';


class AssessmentService {
  final AssessmentData _assessmentData = AssessmentData();

  List<Question> getPreAssessmentQuestions() {
    return _assessmentData.preAssessmentQuestions;
  }

  List<Question> getPostAssessmentQuestions() {
    return _assessmentData.postAssessmentQuestions;
  }

  Future<AssessmentResult> evaluatePreAssessment(List<Answer> answers) async {
    // Calculate scores based on answers
    double overallScore = 0.0;
    Map<String, double> categoryScores = {};
    Map<String, List<Answer>> categorizedAnswers = {};

    // Group answers by category
    for (Answer answer in answers) {
      String questionId = answer.questionId;
      Question? question = _assessmentData.findQuestionById(questionId);

      if (question != null && question.category != null) {
        if (!categorizedAnswers.containsKey(question.category)) {
          categorizedAnswers[question.category!] = [];
        }
        categorizedAnswers[question.category!]!.add(answer);
      }
    }

    // Calculate category scores
    categorizedAnswers.forEach((category, categoryAnswers) {
      double categoryScore = _calculateCategoryScore(category, categoryAnswers);
      categoryScores[category] = categoryScore;
    });

    // Calculate overall score (weighted average of category scores)
    if (categoryScores.isNotEmpty) {
      overallScore = categoryScores.values.reduce((a, b) => a + b) / categoryScores.length;
    }

    // Determine eligibility for scholarship types
    bool meritBased = _isMeritEligible(categoryScores);
    bool needBased = _isNeedEligible(categoryScores);

    // Generate recommendations based on scores
    List<Recommendation> recommendations = _generateRecommendations(categoryScores);

    // Identify strengths and improvement areas
    Map<String, String> strengthAreas = _identifyStrengthAreas(categoryScores);
    Map<String, String> improvementAreas = _identifyImprovementAreas(categoryScores);

    return AssessmentResult(
      timestamp: DateTime.now(),
      overallScore: overallScore,
      categoryScores: categoryScores,
      recommendations: recommendations,
      eligibility: ScholarshipEligibility(
        meritBased: meritBased,
        needBased: needBased,
        eligibilityScore: overallScore,
        strengthAreas: strengthAreas,
        improvementAreas: improvementAreas,
      ),
    );
  }

  double _calculateCategoryScore(String category, List<Answer> answers) {
    // Implement scoring logic for each category
    switch (category) {
      case 'academic':
        return _calculateAcademicScore(answers);
      case 'financial':
        return _calculateFinancialScore(answers);
      case 'extracurricular':
        return _calculateExtracurricularScore(answers);
      case 'leadership':
        return _calculateLeadershipScore(answers);
      case 'community_service':
        return _calculateCommunityServiceScore(answers);
      default:
        return 0.0;
    }
  }

  double _calculateAcademicScore(List<Answer> answers) {
    double score = 0.0;
    int totalQuestions = 0;

    for (Answer answer in answers) {
      String questionId = answer.questionId;
      Question? question = _assessmentData.findQuestionById(questionId);

      if (question != null) {
        totalQuestions++;

        // Score based on GPA
        if (questionId == 'academic_gpa') {
          double gpa = double.tryParse(answer.value.toString()) ?? 0.0;
          if (gpa >= 3.5) score += 5.0;
          else if (gpa >= 3.0) score += 4.0;
          else if (gpa >= 2.5) score += 3.0;
          else if (gpa >= 2.0) score += 2.0;
          else score += 1.0;
        }

        // Score based on academic awards
        else if (questionId == 'academic_awards') {
          List awards = answer.value as List? ?? [];
          score += awards.length > 0 ? 5.0 : 0.0;
        }

        // Score based on participation in academic activities
        else if (questionId == 'academic_activities') {
          List activities = answer.value as List? ?? [];
          score += activities.length > 0 ? 5.0 : 0.0;
        }
      }
    }

    // Normalize score to 0-100
    return totalQuestions > 0 ? (score / (totalQuestions * 5.0)) * 100 : 0.0;
  }

  double _calculateFinancialScore(List<Answer> answers) {
    // Implement financial need scoring logic
    double score = 0.0;
    // Logic to evaluate financial need based on household income, dependents, etc.
    return score;
  }

  double _calculateExtracurricularScore(List<Answer> answers) {
    // Implement extracurricular activities scoring logic
    double score = 0.0;
    // Logic to evaluate extracurricular involvement
    return score;
  }

  double _calculateLeadershipScore(List<Answer> answers) {
    // Implement leadership scoring logic
    double score = 0.0;
    // Logic to evaluate leadership positions and experiences
    return score;
  }

  double _calculateCommunityServiceScore(List<Answer> answers) {
    // Implement community service scoring logic
    double score = 0.0;
    // Logic to evaluate community service hours and impact
    return score;
  }

  bool _isMeritEligible(Map<String, double> categoryScores) {
    // Check if eligible for merit-based scholarships
    double academicScore = categoryScores['academic'] ?? 0.0;
    double leadershipScore = categoryScores['leadership'] ?? 0.0;
    double extracurricularScore = categoryScores['extracurricular'] ?? 0.0;

    // Merit-based eligibility requires good academic performance and other achievements
    return academicScore >= 70.0 && (leadershipScore >= 60.0 || extracurricularScore >= 60.0);
  }

  bool _isNeedEligible(Map<String, double> categoryScores) {
    // Check if eligible for need-based scholarships
    double financialScore = categoryScores['financial'] ?? 0.0;

    // Need-based eligibility is primarily determined by financial need
    return financialScore >= 70.0;
  }

  List<Recommendation> _generateRecommendations(Map<String, double> categoryScores) {
    List<Recommendation> recommendations = [];

    // Generate recommendations based on category scores
    categoryScores.forEach((category, score) {
      if (score < 60.0) {
        // Low score, high priority recommendation
        recommendations.add(_getRecommendationForCategory(category, 5));
      } else if (score < 80.0) {
        // Medium score, medium priority recommendation
        recommendations.add(_getRecommendationForCategory(category, 3));
      } else {
        // High score, low priority recommendation (for further improvement)
        recommendations.add(_getRecommendationForCategory(category, 1));
      }
    });

    // Sort recommendations by priority (highest first)
    recommendations.sort((a, b) => b.priority.compareTo(a.priority));

    return recommendations;
  }

  Recommendation _getRecommendationForCategory(String category, int priority) {
    // Get appropriate recommendation for the category and priority level
    switch (category) {
      case 'academic':
        return _getAcademicRecommendation(priority);
      case 'financial':
        return _getFinancialRecommendation(priority);
      case 'extracurricular':
        return _getExtracurricularRecommendation(priority);
      case 'leadership':
        return _getLeadershipRecommendation(priority);
      case 'community_service':
        return _getCommunityServiceRecommendation(priority);
      default:
        return Recommendation(
          id: 'default_rec',
          title: 'Improve Overall Profile',
          description: 'Work on improving all aspects of your scholarship profile.',
          category: category,
          priority: priority,
        );
    }
  }

  Recommendation _getAcademicRecommendation(int priority) {
    if (priority >= 4) {
      return Recommendation(
        id: 'academic_high',
        title: 'Boost Your GPA',
        description: 'Focus on improving your GPA as it\'s a key factor for scholarship eligibility. Consider tutoring, study groups, or academic support services.',
        category: 'academic',
        priority: priority,
        relatedContentIds: ['module_academic_improvement'],
      );
    } else {
      return Recommendation(
        id: 'academic_low',
        title: 'Maintain Academic Excellence',
        description: 'Continue your strong academic performance and consider pursuing additional academic challenges or honors programs.',
        category: 'academic',
        priority: priority,
        relatedContentIds: ['module_academic_excellence'],
      );
    }
  }

  Recommendation _getFinancialRecommendation(int priority) {
    // Financial need recommendations
    return Recommendation(
      id: 'financial_rec',
      title: 'Document Financial Need',
      description: 'Ensure you have proper documentation of your financial situation for need-based scholarships.',
      category: 'financial',
      priority: priority,
      relatedContentIds: ['module_financial_documentation'],
    );
  }

  Recommendation _getExtracurricularRecommendation(int priority) {
    // Extracurricular activity recommendations
    return Recommendation(
      id: 'extracurricular_rec',
      title: 'Enhance Extracurricular Involvement',
      description: 'Join clubs or activities related to your field of study to demonstrate passion and commitment.',
      category: 'extracurricular',
      priority: priority,
      relatedContentIds: ['module_extracurricular_enhancement'],
    );
  }

  Recommendation _getLeadershipRecommendation(int priority) {
    // Leadership recommendations
    return Recommendation(
      id: 'leadership_rec',
      title: 'Develop Leadership Skills',
      description: 'Seek leadership positions in campus organizations or community groups.',
      category: 'leadership',
      priority: priority,
      relatedContentIds: ['module_leadership_development'],
    );
  }

  Recommendation _getCommunityServiceRecommendation(int priority) {
    // Community service recommendations
    return Recommendation(
      id: 'community_service_rec',
      title: 'Increase Community Involvement',
      description: 'Volunteer for causes that align with your interests or field of study.',
      category: 'community_service',
      priority: priority,
      relatedContentIds: ['module_community_service'],
    );
  }

  Map<String, String> _identifyStrengthAreas(Map<String, double> categoryScores) {
    Map<String, String> strengths = {};

    categoryScores.forEach((category, score) {
      if (score >= 80.0) {
        switch (category) {
          case 'academic':
            strengths[category] = 'Strong academic performance';
            break;
          case 'financial':
            strengths[category] = 'Demonstrated financial need';
            break;
          case 'extracurricular':
            strengths[category] = 'Well-rounded extracurricular profile';
            break;
          case 'leadership':
            strengths[category] = 'Excellent leadership experience';
            break;
          case 'community_service':
            strengths[category] = 'Significant community involvement';
            break;
        }
      }
    });

    return strengths;
  }

  Map<String, String> _identifyImprovementAreas(Map<String, double> categoryScores) {
    Map<String, String> improvements = {};

    categoryScores.forEach((category, score) {
      if (score < 60.0) {
        switch (category) {
          case 'academic':
            improvements[category] = 'Academic performance needs improvement';
            break;
          case 'financial':
            improvements[category] = 'Better documentation of financial need required';
            break;
          case 'extracurricular':
            improvements[category] = 'More extracurricular involvement recommended';
            break;
          case 'leadership':
            improvements[category] = 'Develop stronger leadership experiences';
            break;
          case 'community_service':
            improvements[category] = 'Increase community service participation';
            break;
        }
      }
    });

    return improvements;
  }
}