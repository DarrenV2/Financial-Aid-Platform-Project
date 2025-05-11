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
      overallScore =
          categoryScores.values.reduce((a, b) => a + b) / categoryScores.length;
    }

    // Determine eligibility for scholarship types
    bool meritBased = _isMeritEligible(categoryScores);
    bool needBased = _isNeedEligible(categoryScores);

    // Generate recommendations based on scores
    List<Recommendation> recommendations =
        _generateRecommendations(categoryScores);

    // Identify strengths and improvement areas
    Map<String, String> strengthAreas = _identifyStrengthAreas(categoryScores);
    Map<String, String> improvementAreas =
        _identifyImprovementAreas(categoryScores);

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
          if (gpa >= 3.5) {
            score += 5.0;
          } else if (gpa >= 3.0) {
            score += 4.0;
          } else if (gpa >= 2.5) {
            score += 3.0;
          } else if (gpa >= 2.0) {
            score += 2.0;
          } else {
            score += 1.0;
          }
        }

        // Score based on academic awards
        else if (questionId == 'academic_awards') {
          if (answer.value is List) {
            List awards = answer.value as List;
            if (awards.isEmpty || awards.contains('none')) {
              score += 0.0;
            } else {
              // Higher scores for more prestigious awards
              if (awards.contains('presidents_honor')) {
                score += 5.0;
              } else if (awards.contains('deans_list')) {
                score += 4.0;
              } else if (awards.contains('scholarship') ||
                  awards.contains('department_award')) {
                score += 3.0;
              } else {
                score += 2.0;
              }
            }
          } else if (answer.value is String) {
            String response = answer.value as String;
            score += (response.toLowerCase() == 'yes' || response.isNotEmpty)
                ? 5.0
                : 0.0;
          }
        }

        // Research and academic competitions
        else if (questionId == 'research_competition') {
          if (answer.value is List) {
            List activities = answer.value as List;
            if (activities.contains('published_research')) {
              score += 5.0;
            } else if (activities.contains('research_team')) {
              score += 4.0;
            } else {
              score += 0.0;
            }
          }
        }

        // Additional qualifications
        else if (questionId == 'additional_qualifications') {
          if (answer.value is List) {
            List qualifications = answer.value as List;
            if (qualifications.isEmpty || qualifications.contains('none')) {
              score += 0.0;
            } else {
              // Higher scores for more advanced qualifications
              if (qualifications.contains('associate')) {
                score += 5.0;
              } else if (qualifications.contains('diploma') ||
                  qualifications.contains('certificate')) {
                score += 4.0;
              } else if (qualifications.contains('cape')) {
                score += 3.0;
              } else {
                score += 2.0;
              }
            }
          }
        }

        // External exams
        else if (questionId == 'external_exams') {
          bool hasExams = answer.value.toString().toLowerCase() == 'yes';
          score += hasExams ? 4.0 : 0.0;
        }

        // Exchange programs
        else if (questionId == 'exchange_program') {
          bool hasExchange = answer.value.toString().toLowerCase() == 'yes';
          score += hasExchange ? 5.0 : 0.0;
        }

        // Essay grades
        else if (questionId == 'essay_grade') {
          String grade = answer.value.toString().toLowerCase();
          if (grade == 'a') {
            score += 5.0;
          } else if (grade == 'b') {
            score += 4.0;
          } else if (grade == 'c') {
            score += 3.0;
          } else if (grade == 'd') {
            score += 2.0;
          } else {
            score += 1.0;
          }
        }

        // Essay feedback frequency
        else if (questionId == 'essay_feedback') {
          String frequency = answer.value.toString().toLowerCase();
          if (frequency == 'always') {
            score += 5.0;
          } else if (frequency == 'often') {
            score += 4.0;
          } else if (frequency == 'sometimes') {
            score += 3.0;
          } else if (frequency == 'rarely') {
            score += 2.0;
          } else {
            score += 1.0;
          }
        }

        // Grammar check
        else if (questionId == 'grammar_check') {
          bool checksGrammar = answer.value.toString().toLowerCase() == 'yes';
          score += checksGrammar ? 4.0 : 0.0;
        }
      }
    }

    // Normalize score to 0-100
    return totalQuestions > 0 ? (score / (totalQuestions * 5.0)) * 100 : 0.0;
  }

  double _calculateFinancialScore(List<Answer> answers) {
    double score = 0.0;
    int totalQuestions = 0;

    for (Answer answer in answers) {
      String questionId = answer.questionId;
      Question? question = _assessmentData.findQuestionById(questionId);

      if (question != null) {
        totalQuestions++;

        // Household income
        if (questionId == 'household_income') {
          String incomeRange = answer.value.toString().toLowerCase();
          if (incomeRange.contains('less than') ||
              incomeRange.contains('under')) {
            score += 5.0; // Highest financial need
          } else if (incomeRange.contains('between')) {
            score += 3.0; // Moderate financial need
          } else {
            score += 1.0; // Lower financial need
          }
        }

        // Number of dependents in family
        else if (questionId == 'dependents') {
          int dependents = int.tryParse(answer.value.toString()) ?? 0;
          if (dependents >= 3) {
            score += 5.0;
          } else if (dependents >= 1) {
            score += 3.0;
          } else {
            score += 1.0;
          }
        }

        // Financial hardship
        else if (questionId == 'financial_hardship') {
          bool hasHardship = answer.value.toString().toLowerCase() == 'yes';
          score += hasHardship ? 5.0 : 0.0;
        }

        // First generation college student
        else if (questionId == 'first_generation') {
          bool isFirstGen = answer.value.toString().toLowerCase() == 'yes';
          score += isFirstGen ? 5.0 : 0.0;
        }
      }
    }

    // Normalize score to 0-100
    return totalQuestions > 0 ? (score / (totalQuestions * 5.0)) * 100 : 0.0;
  }

  double _calculateExtracurricularScore(List<Answer> answers) {
    double score = 0.0;
    int totalQuestions = 0;

    for (Answer answer in answers) {
      String questionId = answer.questionId;
      Question? question = _assessmentData.findQuestionById(questionId);

      if (question != null) {
        totalQuestions++;

        // Extracurricular activities
        if (questionId == 'extracurricular') {
          if (answer.value is List) {
            List activities = answer.value as List;
            if (activities.isEmpty || activities.contains('none')) {
              score += 0.0;
            } else {
              // More activities = higher score
              if (activities.length >= 3) {
                score += 5.0;
              } else if (activities.length == 2) {
                score += 4.0;
              } else {
                score += 3.0;
              }
            }
          } else if (answer.value is String) {
            String response = answer.value as String;
            score += response.isNotEmpty ? 3.0 : 0.0;
          }
        }

        // Honor societies
        else if (questionId == 'honor_societies') {
          if (answer.value is List) {
            List societies = answer.value as List;
            if (societies.isEmpty || societies.contains('none')) {
              score += 0.0;
            } else {
              if (societies.contains('honor_society')) {
                score += 5.0;
              } else if (societies.contains('professional_org')) {
                score += 4.0;
              } else {
                score += 3.0;
              }
            }
          } else if (answer.value is String) {
            String response = answer.value as String;
            score += response.isNotEmpty ? 3.0 : 0.0;
          }
        }

        // Work experience
        else if (questionId == 'work_experience') {
          bool hasExperience = answer.value.toString().toLowerCase() == 'yes';
          score += hasExperience ? 5.0 : 0.0;
        }

        // Number of activities
        if (questionId == 'extracurricular_count') {
          int count = int.tryParse(answer.value.toString()) ?? 0;
          if (count >= 3) {
            score += 5.0;
          } else if (count >= 1) {
            score += 3.0;
          } else {
            score += 1.0;
          }
        }

        // Years of participation
        else if (questionId == 'extracurricular_years') {
          int years = int.tryParse(answer.value.toString()) ?? 0;
          if (years >= 2) {
            score += 5.0;
          } else if (years >= 1) {
            score += 3.0;
          } else {
            score += 1.0;
          }
        }

        // New extracurricular activities for post-assessment
        else if (questionId == 'new_extracurricular') {
          if (answer.value is List) {
            List activities = answer.value as List;
            if (activities.isEmpty || activities.contains('none')) {
              score += 0.0;
            } else {
              // More activities = higher score
              if (activities.length >= 3) {
                score += 5.0;
              } else if (activities.length == 2) {
                score += 4.0;
              } else {
                score += 3.0;
              }
            }
          }
        }
      }
    }

    // Normalize score to 0-100
    return totalQuestions > 0 ? (score / (totalQuestions * 5.0)) * 100 : 0.0;
  }

  double _calculateLeadershipScore(List<Answer> answers) {
    double score = 0.0;
    int totalQuestions = 0;

    for (Answer answer in answers) {
      String questionId = answer.questionId;
      Question? question = _assessmentData.findQuestionById(questionId);

      if (question != null) {
        totalQuestions++;

        // Leadership positions held
        if (questionId == 'leadership_position') {
          if (answer.value is List) {
            List positions = answer.value as List;
            if (positions.isEmpty || positions.contains('none')) {
              score += 0.0;
            } else {
              // Higher positions get higher scores
              if (positions.contains('president')) {
                score += 5.0;
              } else if (positions.contains('vice_president')) {
                score += 4.5;
              } else if (positions.contains('secretary') ||
                  positions.contains('treasurer') ||
                  positions.contains('team_captain')) {
                score += 4.0;
              } else if (positions.contains('committee_chair') ||
                  positions.contains('project_lead')) {
                score += 3.5;
              } else {
                score += 3.0;
              }
            }
          } else if (answer.value is String) {
            String response = answer.value as String;
            score += response.isNotEmpty ? 3.0 : 0.0;
          }
        }

        // New leadership roles for post-assessment
        else if (questionId == 'new_leadership_roles') {
          if (answer.value is List) {
            List positions = answer.value as List;
            if (positions.isEmpty || positions.contains('none')) {
              score += 0.0;
            } else {
              // Higher positions get higher scores
              if (positions.contains('president')) {
                score += 5.0;
              } else if (positions.contains('vice_president')) {
                score += 4.5;
              } else if (positions.contains('secretary') ||
                  positions.contains('treasurer') ||
                  positions.contains('team_captain')) {
                score += 4.0;
              } else if (positions.contains('committee_chair') ||
                  positions.contains('project_lead')) {
                score += 3.5;
              } else {
                score += 3.0;
              }
            }
          }
        }

        // Leadership training
        else if (questionId == 'leadership_training') {
          bool hasTraining = answer.value.toString().toLowerCase() == 'yes';
          score += hasTraining ? 5.0 : 0.0;
        }
      }
    }

    // Normalize score to 0-100
    return totalQuestions > 0 ? (score / (totalQuestions * 5.0)) * 100 : 0.0;
  }

  double _calculateCommunityServiceScore(List<Answer> answers) {
    double score = 0.0;
    int totalQuestions = 0;

    for (Answer answer in answers) {
      String questionId = answer.questionId;
      Question? question = _assessmentData.findQuestionById(questionId);

      if (question != null) {
        totalQuestions++;

        // Community activity
        if (questionId == 'community_activity') {
          if (answer.value is List) {
            List activities = answer.value as List;
            if (activities.isEmpty || activities.contains('none')) {
              score += 0.0;
            } else {
              // More activities = higher score
              if (activities.length >= 3) {
                score += 5.0;
              } else if (activities.length == 2) {
                score += 4.0;
              } else {
                score += 3.0;
              }
            }
          } else if (answer.value is String) {
            String response = answer.value as String;
            score += response.isNotEmpty ? 3.0 : 0.0;
          }
        }

        // Service hours
        else if (questionId == 'community_service_hours') {
          int hours = int.tryParse(answer.value.toString()) ?? 0;
          if (hours >= 100) {
            score += 5.0;
          } else if (hours >= 50) {
            score += 4.0;
          } else if (hours >= 20) {
            score += 3.0;
          } else if (hours >= 10) {
            score += 2.0;
          } else {
            score += 1.0;
          }
        }

        // Leadership in service
        else if (questionId == 'service_leadership') {
          bool hasLed = answer.value.toString().toLowerCase() == 'yes';
          score += hasLed ? 5.0 : 0.0;
        }
      }
    }

    // Normalize score to 0-100
    return totalQuestions > 0 ? (score / (totalQuestions * 5.0)) * 100 : 0.0;
  }

  bool _isMeritEligible(Map<String, double> categoryScores) {
    // Check if eligible for merit-based scholarships
    double academicScore = categoryScores['academic'] ?? 0.0;
    double leadershipScore = categoryScores['leadership'] ?? 0.0;
    double extracurricularScore = categoryScores['extracurricular'] ?? 0.0;

    // Merit-based eligibility requires good academic performance and other achievements
    return academicScore >= 70.0 &&
        (leadershipScore >= 60.0 || extracurricularScore >= 60.0);
  }

  bool _isNeedEligible(Map<String, double> categoryScores) {
    // Check if eligible for need-based scholarships
    double financialScore = categoryScores['financial'] ?? 0.0;

    // Need-based eligibility is primarily determined by financial need
    return financialScore >= 70.0;
  }

  List<Recommendation> _generateRecommendations(
      Map<String, double> categoryScores) {
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
          description:
              'Work on improving all aspects of your scholarship profile.',
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
        description:
            'Focus on improving your GPA as it\'s a key factor for scholarship eligibility. Consider tutoring, study groups, or academic support services.',
        category: 'academic',
        priority: priority,
        relatedContentIds: ['module_academic_improvement'],
      );
    } else {
      return Recommendation(
        id: 'academic_low',
        title: 'Maintain Academic Excellence',
        description:
            'Continue your strong academic performance and consider pursuing additional academic challenges or honors programs.',
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
      description:
          'Ensure you have proper documentation of your financial situation for need-based scholarships.',
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
      description:
          'Join clubs or activities related to your field of study to demonstrate passion and commitment.',
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
      description:
          'Seek leadership positions in campus organizations or community groups.',
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
      description:
          'Volunteer for causes that align with your interests or field of study.',
      category: 'community_service',
      priority: priority,
      relatedContentIds: ['module_community_service'],
    );
  }

  Map<String, String> _identifyStrengthAreas(
      Map<String, double> categoryScores) {
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

  Map<String, String> _identifyImprovementAreas(
      Map<String, double> categoryScores) {
    Map<String, String> improvements = {};

    categoryScores.forEach((category, score) {
      if (score < 60.0) {
        switch (category) {
          case 'academic':
            improvements[category] = 'Academic performance needs improvement';
            break;
          case 'financial':
            improvements[category] =
                'Better documentation of financial need required';
            break;
          case 'extracurricular':
            improvements[category] =
                'More extracurricular involvement recommended';
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
