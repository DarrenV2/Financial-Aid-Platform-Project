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

  Future<AssessmentResult> evaluatePostAssessment(List<Answer> answers) async {
    // Calculate scores based on answers
    double overallScore = 0.0;
    Map<String, double> categoryScores = {};
    Map<String, List<Answer>> categorizedAnswers = {};

    // Group answers by category
    for (Answer answer in answers) {
      String questionId = answer.questionId;
      Question? question =
          _assessmentData.findQuestionById(questionId, isPostAssessment: true);

      if (question != null && question.category != null) {
        if (!categorizedAnswers.containsKey(question.category)) {
          categorizedAnswers[question.category!] = [];
        }
        categorizedAnswers[question.category!]!.add(answer);
      }
    }

    // Calculate category scores
    categorizedAnswers.forEach((category, categoryAnswers) {
      double categoryScore =
          _calculatePostCategoryScore(category, categoryAnswers);
      categoryScores[category] = categoryScore;
    });

    // Calculate overall score from post-assessment (out of 30 points)
    int totalPoints = _calculatePostAssessmentPoints(answers);
    overallScore = totalPoints.toDouble();

    // Determine eligibility for scholarship types
    bool meritBased = _isMeritEligible(categoryScores);
    bool needBased = _isNeedEligible(categoryScores);

    // Generate recommendations based on scores
    List<Recommendation> recommendations =
        _generatePostRecommendations(categoryScores, totalPoints);

    // Identify strengths and improvement areas
    Map<String, String> strengthAreas = _identifyStrengthAreas(categoryScores);
    Map<String, String> improvementAreas =
        _identifyImprovementAreas(categoryScores);

    // Determine readiness level based on total points
    String readinessLevel = _determineReadinessLevel(totalPoints);

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
      readinessLevel: readinessLevel,
      isPostAssessment: true,
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
      case 'personal':
        return _calculatePersonalScore(answers);
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

  double _calculatePersonalScore(List<Answer> answers) {
    double score = 0.0;
    int totalQuestions = 0;

    for (Answer answer in answers) {
      String questionId = answer.questionId;
      Question? question = _assessmentData.findQuestionById(questionId);

      if (question != null) {
        totalQuestions++;

        // Citizenship
        if (questionId == 'citizenship') {
          bool isJamaican = answer.value.toString().toLowerCase() == 'yes';
          score += isJamaican ? 5.0 : 0.0;
        }

        // UTech student ID
        else if (questionId == 'utech_student') {
          bool hasStudentId = answer.value.toString().toLowerCase() == 'yes';
          score += hasStudentId ? 5.0 : 0.0;
        }

        // Enrollment status
        else if (questionId == 'enrollment_status') {
          String status = answer.value.toString().toLowerCase();
          score += (status == 'full_time') ? 5.0 : 3.0;
        }

        // Previous scholarship
        else if (questionId == 'previous_scholarship') {
          bool hadScholarship = answer.value.toString().toLowerCase() == 'yes';
          score += hadScholarship
              ? 3.0
              : 5.0; // Give higher score to those who haven't had scholarships
        }

        // Career goals
        else if (questionId == 'career_goals') {
          String goal = answer.value.toString().toLowerCase();
          // All goals are valid, but clear direction gets higher score
          score += (goal == 'undecided') ? 3.0 : 5.0;
        }

        // Post-assessment: Scholarship applications
        else if (questionId == 'scholarship_applications') {
          int applications = int.tryParse(answer.value.toString()) ?? 0;
          if (applications > 10) {
            score += 5.0;
          } else if (applications > 5) {
            score += 4.0;
          } else if (applications > 0) {
            score += 3.0;
          } else {
            score += 0.0;
          }
        }

        // Post-assessment: Application confidence
        else if (questionId == 'application_confidence') {
          String confidence = answer.value.toString().toLowerCase();
          if (confidence == 'very_confident') {
            score += 5.0;
          } else if (confidence == 'confident') {
            score += 4.0;
          } else if (confidence == 'neutral') {
            score += 3.0;
          } else if (confidence == 'not_confident') {
            score += 2.0;
          } else {
            score += 1.0;
          }
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

    // Academic recommendations
    if (categoryScores.containsKey('academic')) {
      double score = categoryScores['academic']!;
      if (score < 50) {
        recommendations.add(
          Recommendation(
            id: 'academic_improvement',
            title: 'Improve Academic Performance',
            description:
                'Focus on improving your GPA and academic standing to increase scholarship eligibility.',
            action:
                'Complete the Academic Performance module in your Learning Plan.',
            priority: RecommendationPriority.high,
            learningModuleId: 'module_academic_improvement',
            category: 'academic',
            relatedContentIds: [
              'module_academic_improvement',
              'module_essay_writing'
            ],
          ),
        );
      } else if (score < 75) {
        recommendations.add(
          Recommendation(
            id: 'academic_enhancement',
            title: 'Enhance Academic Profile',
            description:
                'Consider additional academic activities such as research or competitions to strengthen your profile.',
            action: 'Join an academic club or research team.',
            priority: RecommendationPriority.medium,
            learningModuleId: 'module_academic_improvement',
            category: 'academic',
            relatedContentIds: [
              'module_academic_improvement',
              'module_essay_writing'
            ],
          ),
        );
      }
    }

    // Financial recommendations
    if (categoryScores.containsKey('financial')) {
      double score = categoryScores['financial']!;
      if (score > 75) {
        recommendations.add(
          Recommendation(
            id: 'need_based_scholarships',
            title: 'Apply for Need-Based Scholarships',
            description:
                'Your financial situation qualifies you for need-based scholarships and grants.',
            action:
                'Apply for need-based scholarships in the Scholarship section.',
            priority: RecommendationPriority.high,
            learningModuleId: 'module_essay_writing',
            category: 'financial',
            relatedContentIds: [
              'module_essay_writing',
              'module_application_strategy'
            ],
          ),
        );
      }

      recommendations.add(
        Recommendation(
          id: 'financial_planning',
          title: 'Develop Financial Planning Skills',
          description:
              'Learn financial planning strategies to maximize available resources and show financial responsibility to scholarship committees.',
          action:
              'Complete the Financial Planning module in your Learning Plan.',
          priority: RecommendationPriority.medium,
          learningModuleId: 'module_essay_writing',
          category: 'financial',
          relatedContentIds: [
            'module_essay_writing',
            'module_application_strategy'
          ],
        ),
      );
    }

    // Extracurricular recommendations
    if (categoryScores.containsKey('extracurricular')) {
      double score = categoryScores['extracurricular']!;
      if (score < 60) {
        recommendations.add(
          Recommendation(
            id: 'extracurricular_involvement',
            title: 'Increase Extracurricular Involvement',
            description:
                'Join clubs, sports, or activities relevant to your interests and major to demonstrate well-roundedness.',
            action:
                'Explore and join at least one extracurricular activity this semester.',
            priority: RecommendationPriority.medium,
            learningModuleId: 'module_leadership_development',
            category: 'extracurricular',
            relatedContentIds: [
              'module_leadership_development',
              'module_community_service'
            ],
          ),
        );
      }
    }

    // Leadership recommendations
    if (categoryScores.containsKey('leadership')) {
      double score = categoryScores['leadership']!;
      if (score < 50) {
        recommendations.add(
          Recommendation(
            id: 'leadership_development',
            title: 'Develop Leadership Skills',
            description:
                'Seek opportunities to develop and demonstrate leadership skills through campus organizations or community initiatives.',
            action:
                'Complete the Leadership Development module in your Learning Plan.',
            priority: RecommendationPriority.high,
            learningModuleId: 'module_leadership_development',
            category: 'leadership',
            relatedContentIds: [
              'module_leadership_development',
              'module_community_service'
            ],
          ),
        );
      } else if (score < 75) {
        recommendations.add(
          Recommendation(
            id: 'leadership_role',
            title: 'Seek Leadership Positions',
            description:
                'Consider taking on a leadership role in an organization or initiative that aligns with your interests.',
            action:
                'Apply for a leadership position in a club or organization.',
            priority: RecommendationPriority.medium,
            learningModuleId: 'module_leadership_development',
            category: 'leadership',
            relatedContentIds: [
              'module_leadership_development',
              'module_community_service'
            ],
          ),
        );
      }
    }

    // Community service recommendations
    if (categoryScores.containsKey('community_service')) {
      double score = categoryScores['community_service']!;
      if (score < 60) {
        recommendations.add(
          Recommendation(
            id: 'community_service',
            title: 'Engage in Community Service',
            description:
                'Participate in volunteer activities that align with your values and interests.',
            action:
                'Complete the Community Service module in your Learning Plan.',
            priority: RecommendationPriority.medium,
            learningModuleId: 'module_community_service',
            category: 'community_service',
            relatedContentIds: [
              'module_community_service',
              'module_leadership_development'
            ],
          ),
        );
      }
    }

    // Personal category recommendations
    if (categoryScores.containsKey('personal')) {
      double score = categoryScores['personal']!;

      // Add recommendation for scholarship application preparation
      recommendations.add(
        Recommendation(
          id: 'personal_statement',
          title: 'Develop a Compelling Personal Statement',
          description:
              'Create a strong personal statement that highlights your background, goals, and motivations for your education.',
          action:
              'Complete the Personal Statement Writing module in your Learning Plan.',
          priority: score < 70
              ? RecommendationPriority.high
              : RecommendationPriority.medium,
          learningModuleId: 'module_personal_statement',
          category: 'personal',
          relatedContentIds: [
            'module_personal_statement',
            'module_essay_writing'
          ],
        ),
      );

      // For students with low personal category scores
      if (score < 60) {
        recommendations.add(
          Recommendation(
            id: 'personal_branding',
            title: 'Develop Your Personal Brand',
            description:
                'Create a consistent personal brand that communicates your strengths, values, and aspirations to scholarship committees.',
            action:
                'Complete the Personal Branding module in your Learning Plan.',
            priority: RecommendationPriority.high,
            learningModuleId: 'module_personal_branding',
            category: 'personal',
            relatedContentIds: [
              'module_personal_branding',
              'module_application_strategy'
            ],
          ),
        );
      }
    }

    // Essay writing recommendation - essential for all applicants
    recommendations.add(
      Recommendation(
        id: 'essay_writing',
        title: 'Strengthen Scholarship Essay Writing Skills',
        description:
            'Develop compelling, well-structured essays that effectively communicate your qualifications and aspirations.',
        action: 'Complete the Essay Writing module in your Learning Plan.',
        priority: RecommendationPriority.high,
        learningModuleId: 'module_essay_writing',
        category: 'academic',
        relatedContentIds: [
          'module_essay_writing',
          'module_academic_improvement'
        ],
      ),
    );

    // Application strategy recommendation - essential for all applicants
    recommendations.add(
      Recommendation(
        id: 'application_strategy',
        title: 'Create an Application Strategy',
        description:
            'Develop a comprehensive plan for researching and applying to scholarships that match your profile.',
        action:
            'Complete the Application Strategy module in your Learning Plan.',
        priority: RecommendationPriority.high,
        learningModuleId: 'module_application_strategy',
        category: 'strategy',
        relatedContentIds: [
          'module_application_strategy',
          'module_essay_writing'
        ],
      ),
    );

    return recommendations;
  }

  Map<String, String> _identifyStrengthAreas(
      Map<String, double> categoryScores) {
    Map<String, String> strengthAreas = {};

    categoryScores.forEach((category, score) {
      if (score >= 80.0) {
        strengthAreas[category] = _getStrengthDescription(category);
      }
    });

    return strengthAreas;
  }

  Map<String, String> _identifyImprovementAreas(
      Map<String, double> categoryScores) {
    Map<String, String> improvementAreas = {};

    categoryScores.forEach((category, score) {
      if (score < 60.0) {
        improvementAreas[category] = _getImprovementDescription(category);
      }
    });

    return improvementAreas;
  }

  String _getStrengthDescription(String category) {
    switch (category) {
      case 'academic':
        return 'Strong academic performance positions you well for merit-based scholarships.';
      case 'financial':
        return 'Your financial situation makes you eligible for need-based scholarships.';
      case 'extracurricular':
        return 'Your extracurricular involvement demonstrates well-roundedness valued by scholarship committees.';
      case 'leadership':
        return 'Your leadership experience is a significant asset for many scholarship applications.';
      case 'community_service':
        return 'Your community service demonstrates a commitment to giving back that scholarship providers value.';
      case 'personal':
        return 'Your personal profile and background information position you well for scholarships that value your unique experiences.';
      default:
        return 'This is a strength area for your profile.';
    }
  }

  String _getImprovementDescription(String category) {
    switch (category) {
      case 'academic':
        return 'Improving your academic performance will enhance your eligibility for merit-based scholarships.';
      case 'financial':
        return 'Better documenting your financial need will improve your chances for need-based scholarships.';
      case 'extracurricular':
        return 'Increasing your extracurricular involvement will make your profile more competitive.';
      case 'leadership':
        return 'Developing leadership skills will strengthen your scholarship applications.';
      case 'community_service':
        return 'Engaging in more community service will enhance your scholarship profile.';
      case 'personal':
        return 'Developing a more compelling personal story and clearer career goals will strengthen your applications.';
      default:
        return 'This is an area to improve in your profile.';
    }
  }

  double _calculatePostCategoryScore(String category, List<Answer> answers) {
    double score = 0.0;
    int totalQuestions = 0;

    for (Answer answer in answers) {
      String questionId = answer.questionId;
      Question? question =
          _assessmentData.findQuestionById(questionId, isPostAssessment: true);

      if (question != null) {
        totalQuestions++;
        String value = answer.value.toString().toLowerCase();

        // Academic scores
        if (category == 'academic') {
          if (questionId == 'post_gpa') {
            if (value == 'gpa_high') {
              score += 3.0;
            } else if (value == 'gpa_medium') {
              score += 2.0;
            } else if (value == 'gpa_low') {
              score += 1.0;
            }
          } else if (questionId == 'post_gpa_goals') {
            if (value == 'goals_clear') {
              score += 3.0;
            } else if (value == 'goals_no_plan') {
              score += 2.0;
            } else {
              score += 0.0;
            }
          } else if (questionId == 'post_study_tools') {
            if (value == 'tools_weekly') {
              score += 3.0;
            } else if (value == 'tools_occasionally') {
              score += 2.0;
            } else {
              score += 0.0;
            }
          }
        }

        // Leadership scores
        else if (category == 'leadership') {
          if (questionId == 'post_leadership_role') {
            if (value == 'leader_yes') {
              score += 3.0;
            } else if (value == 'leader_member') {
              score += 2.0;
            } else {
              score += 0.0;
            }
          }
        }

        // Extracurricular scores
        else if (category == 'extracurricular') {
          if (questionId == 'post_competitions') {
            if (value == 'comp_won') {
              score += 3.0;
            } else if (value == 'comp_no_win') {
              score += 2.0;
            } else {
              score += 0.0;
            }
          }
        }

        // Community service scores
        else if (category == 'community_service') {
          if (questionId == 'post_volunteer_hours') {
            if (value == 'vol_many') {
              score += 3.0;
            } else if (value == 'vol_medium') {
              score += 2.0;
            } else if (value == 'vol_few') {
              score += 1.0;
            }
          } else if (questionId == 'post_volunteer_aligned') {
            if (value == 'vol_aligned_yes') {
              score += 3.0;
            } else if (value == 'vol_aligned_somewhat') {
              score += 2.0;
            } else {
              score += 0.0;
            }
          }
        }

        // Strategy scores
        else if (category == 'strategy') {
          if (questionId == 'post_resume_ready') {
            if (value == 'resume_polished') {
              score += 3.0;
            } else if (value == 'resume_draft') {
              score += 2.0;
            } else {
              score += 0.0;
            }
          } else if (questionId == 'post_scholarship_search') {
            if (value == 'search_targeted') {
              score += 3.0;
            } else if (value == 'search_broad') {
              score += 2.0;
            } else {
              score += 0.0;
            }
          } else if (questionId == 'post_mock_interviews') {
            if (value == 'interview_yes') {
              score += 3.0;
            } else if (value == 'interview_planned') {
              score += 2.0;
            } else {
              score += 0.0;
            }
          } else if (questionId == 'post_documents_ready') {
            if (answer.value is List) {
              List<dynamic> docs = answer.value as List;
              // Each document is worth points (up to a maximum for this question)
              score += docs.length.clamp(0, 3).toDouble();
            }
          }
        }
      }
    }

    // Normalize score to 0-100
    return totalQuestions > 0 ? (score / (totalQuestions * 3.0)) * 100 : 0.0;
  }

  int _calculatePostAssessmentPoints(List<Answer> answers) {
    int totalPoints = 0;

    for (Answer answer in answers) {
      String questionId = answer.questionId;
      String value = answer.value.toString().toLowerCase();

      // Section 1: Academic Preparedness
      if (questionId == 'post_gpa') {
        if (value == 'gpa_high') {
          totalPoints += 3;
        } else if (value == 'gpa_medium') {
          totalPoints += 2;
        } else if (value == 'gpa_low') {
          totalPoints += 1;
        }
      } else if (questionId == 'post_gpa_goals') {
        if (value == 'goals_clear') {
          totalPoints += 3;
        } else if (value == 'goals_no_plan') {
          totalPoints += 2;
        }
      } else if (questionId == 'post_study_tools') {
        if (value == 'tools_weekly') {
          totalPoints += 3;
        } else if (value == 'tools_occasionally') {
          totalPoints += 2;
        }
      }

      // Section 2: Extracurriculars & Leadership
      else if (questionId == 'post_leadership_role') {
        if (value == 'leader_yes') {
          totalPoints += 3;
        } else if (value == 'leader_member') {
          totalPoints += 2;
        }
      } else if (questionId == 'post_competitions') {
        if (value == 'comp_won') {
          totalPoints += 3;
        } else if (value == 'comp_no_win') {
          totalPoints += 2;
        }
      }

      // Section 3: Volunteering
      else if (questionId == 'post_volunteer_hours') {
        if (value == 'vol_many') {
          totalPoints += 3;
        } else if (value == 'vol_medium') {
          totalPoints += 2;
        } else if (value == 'vol_few') {
          totalPoints += 1;
        }
      } else if (questionId == 'post_volunteer_aligned') {
        if (value == 'vol_aligned_yes') {
          totalPoints += 3;
        } else if (value == 'vol_aligned_somewhat') {
          totalPoints += 2;
        }
      }

      // Section 4: Application Strategy
      else if (questionId == 'post_resume_ready') {
        if (value == 'resume_polished') {
          totalPoints += 3;
        } else if (value == 'resume_draft') {
          totalPoints += 2;
        }
      } else if (questionId == 'post_scholarship_search') {
        if (value == 'search_targeted') {
          totalPoints += 3;
        } else if (value == 'search_broad') {
          totalPoints += 2;
        }
      } else if (questionId == 'post_mock_interviews') {
        if (value == 'interview_yes') {
          totalPoints += 3;
        } else if (value == 'interview_planned') {
          totalPoints += 2;
        }
      }
    }

    return totalPoints;
  }

  List<Recommendation> _generatePostRecommendations(
      Map<String, double> categoryScores, int totalPoints) {
    List<Recommendation> recommendations = [];

    // Based on readiness level
    if (totalPoints < 15) {
      recommendations.add(
        Recommendation(
          id: 'post_rec_needs_work',
          title: 'Revisit Core Modules',
          description:
              'Your readiness score indicates you need to revisit the coaching lessons and set clearer goals.',
          priority: RecommendationPriority.high,
          action: 'Review your learning plan and complete all core modules.',
        ),
      );
    } else if (totalPoints < 25) {
      recommendations.add(
        Recommendation(
          id: 'post_rec_almost_there',
          title: 'Focus on Weak Areas',
          description:
              'You\'re almost ready to apply for scholarships! Focus on your identified improvement areas.',
          priority: RecommendationPriority.medium,
          action: 'Review your category scores and strengthen weak areas.',
        ),
      );
    } else {
      recommendations.add(
        Recommendation(
          id: 'post_rec_ready',
          title: 'Start Applying Now',
          description:
              'You\'re a strong candidate for scholarships! Start applying with confidence.',
          priority: RecommendationPriority.low,
          action: 'Begin applying for scholarships that match your profile.',
        ),
      );
    }

    // Add category-specific recommendations based on scores
    categoryScores.forEach((category, score) {
      if (score < 60.0) {
        String title = '';
        String description = '';
        String action = '';
        String? moduleId;

        if (category == 'academic') {
          title = 'Improve Academic Readiness';
          description =
              'Your academic readiness score is lower than optimal for scholarship applications.';
          action = 'Focus on improving your GPA and using more study tools.';
          moduleId = 'module_academic_profile';
        } else if (category == 'leadership') {
          title = 'Enhance Leadership Experience';
          description =
              'Your leadership score could be stronger for scholarship applications.';
          action = 'Seek leadership roles in organizations you participate in.';
          moduleId = 'module_leadership';
        } else if (category == 'extracurricular') {
          title = 'Boost Extracurricular Participation';
          description =
              'Your extracurricular profile needs strengthening for competitive scholarships.';
          action =
              'Join competitions or activities related to your field of study.';
          moduleId = 'module_extracurricular';
        } else if (category == 'community_service') {
          title = 'Increase Community Service Impact';
          description =
              'Your community service hours or alignment could be improved.';
          action = 'Volunteer for causes aligned with your career goals.';
          moduleId = 'module_community_service';
        } else if (category == 'strategy') {
          title = 'Strengthen Application Strategy';
          description =
              'Your application readiness needs improvement before applying.';
          action = 'Prepare your resume and practice mock interviews.';
          moduleId = 'module_application_strategy';
        }

        recommendations.add(
          Recommendation(
            id: 'post_rec_${category}_improvement',
            title: title,
            description: description,
            category: category,
            priority: RecommendationPriority.high,
            action: action,
            learningModuleId: moduleId,
          ),
        );
      }
    });

    return recommendations;
  }

  String _determineReadinessLevel(int points) {
    if (points >= 25) {
      return "Ready! You're a strong candidate. Start applying now.";
    }
    if (points >= 15) {
      return "Almost There. Focus on weak areas (e.g., GPA, leadership).";
    }
    return "Needs Work. Revisit the coaching lessons and set clear goals.";
  }
}
