import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_progress.dart';
import '../models/assessment_result.dart';

abstract class IProgressRepository {
  Future<UserProgress> getUserProgress(String userId);
  Future<void> updateModuleProgress(
      String userId, String moduleId, double progress);
  Future<void> markModuleCompleted(String userId, String moduleId);
  Future<void> saveAssessmentResult(String userId, AssessmentResult result);
}

class FirestoreProgressRepository implements IProgressRepository {
  final FirebaseFirestore _firestore;

  FirestoreProgressRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserProgress> getUserProgress(String userId) async {
    try {
      final doc =
          await _firestore.collection('user_progress').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        // Convert moduleProgress from map
        Map<String, double> moduleProgress = {};
        if (data['moduleProgress'] != null) {
          (data['moduleProgress'] as Map<String, dynamic>)
              .forEach((key, value) {
            moduleProgress[key] = (value as num).toDouble();
          });
        }

        // Convert completedModules from list
        List<String> completedModules = [];
        if (data['completedModules'] != null) {
          completedModules = List<String>.from(data['completedModules']);
        }

        // Convert assessmentResults from list of maps
        List<AssessmentResult> assessmentResults = [];
        if (data['assessmentResults'] != null) {
          for (var resultMap in data['assessmentResults'] as List) {
            try {
              final Map<String, dynamic> typedMap =
                  Map<String, dynamic>.from(resultMap as Map);
              final double overallScore =
                  (typedMap['overallScore'] as num).toDouble();
              final DateTime timestamp = typedMap['timestamp'] != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      typedMap['timestamp'] as int)
                  : DateTime.now();

              // Extract category scores
              Map<String, double> categoryScores = {'overall': overallScore};
              if (typedMap['categoryScores'] != null) {
                final Map<String, dynamic> scores = Map<String, dynamic>.from(
                    typedMap['categoryScores'] as Map);
                scores.forEach((key, value) {
                  categoryScores[key] = (value as num).toDouble();
                });
              }

              // Extract recommendations
              List<Recommendation> recommendations = [];

              // Try loading full recommendation data first
              if (typedMap['recommendations'] != null &&
                  (typedMap['recommendations'] as List).isNotEmpty) {
                final List<dynamic> recsData =
                    typedMap['recommendations'] as List;
                for (var recData in recsData) {
                  if (recData is Map) {
                    final Map<String, dynamic> recMap =
                        Map<String, dynamic>.from(recData as Map);
                    try {
                      List<String> relatedContentIds = [];
                      if (recMap['relatedContentIds'] != null) {
                        relatedContentIds = List<String>.from(
                            recMap['relatedContentIds'] as List);
                      }

                      recommendations.add(Recommendation(
                        id: recMap['id'].toString(),
                        title: recMap['title'].toString(),
                        description: recMap['description'].toString(),
                        category: recMap['category'].toString(),
                        priority: _intToPriorityEnum(
                            (recMap['priority'] as num).toInt()),
                        relatedContentIds: relatedContentIds,
                      ));
                    } catch (e) {
                      // Silently handle errors
                    }
                  }
                }
              }
              // Fall back to ID-based recommendations if full data not available
              else if (typedMap['recommendationIds'] != null) {
                final List<dynamic> recIds =
                    typedMap['recommendationIds'] as List;
                for (var id in recIds) {
                  String recId = id.toString();
                  // Create related content IDs based on category
                  List<String> relatedContentIds = [];

                  // Map recommendation IDs to specific module IDs based on category
                  if (recId.contains('academic')) {
                    relatedContentIds.add('module_academic_improvement');
                    relatedContentIds.add('module_essay_writing');
                  } else if (recId.contains('financial')) {
                    relatedContentIds.add('module_essay_writing');
                    relatedContentIds.add('module_application_strategy');
                  } else if (recId.contains('leadership')) {
                    relatedContentIds.add('module_leadership_development');
                    relatedContentIds.add('module_community_service');
                  } else if (recId.contains('personal')) {
                    relatedContentIds.add('module_personal_statement');
                    relatedContentIds.add('module_personal_branding');
                  }

                  // Create basic recommendations
                  recommendations.add(Recommendation(
                    id: recId,
                    title: 'Recommendation: ${recId}',
                    description: 'Improve your score in this area',
                    category: recId.contains('academic')
                        ? 'academic'
                        : recId.contains('financial')
                            ? 'financial'
                            : recId.contains('leadership')
                                ? 'leadership'
                                : recId.contains('personal')
                                    ? 'personal'
                                    : 'general',
                    priority: RecommendationPriority.medium,
                    relatedContentIds: relatedContentIds,
                  ));
                }
              }

              // Extract eligibility
              ScholarshipEligibility eligibility = ScholarshipEligibility(
                meritBased: false,
                needBased: false,
                eligibilityScore: overallScore,
                strengthAreas: {},
                improvementAreas: {},
              );

              if (typedMap['eligibility'] != null) {
                final Map<String, dynamic> eligibilityMap =
                    Map<String, dynamic>.from(typedMap['eligibility'] as Map);
                eligibility = ScholarshipEligibility(
                  meritBased: eligibilityMap['meritBased'] as bool? ?? false,
                  needBased: eligibilityMap['needBased'] as bool? ?? false,
                  eligibilityScore: eligibilityMap['eligibilityScore'] != null
                      ? (eligibilityMap['eligibilityScore'] as num).toDouble()
                      : overallScore,
                  strengthAreas: eligibilityMap['strengthAreas'] != null
                      ? Map<String, String>.from(
                          eligibilityMap['strengthAreas'] as Map)
                      : {},
                  improvementAreas: eligibilityMap['improvementAreas'] != null
                      ? Map<String, String>.from(
                          eligibilityMap['improvementAreas'] as Map)
                      : {},
                );
              }

              // Read post-assessment specific fields
              bool isPostAssessment =
                  typedMap['isPostAssessment'] as bool? ?? false;
              String? readinessLevel = typedMap['readinessLevel'] as String?;

              // Create full AssessmentResult
              assessmentResults.add(AssessmentResult(
                timestamp: timestamp,
                overallScore: overallScore,
                categoryScores: categoryScores,
                recommendations: recommendations,
                eligibility: eligibility,
                isPostAssessment: isPostAssessment,
                readinessLevel: readinessLevel,
              ));
            } catch (e) {
              // Silently handle errors
            }
          }
        }

        return UserProgress(
          userId: userId,
          moduleProgress: moduleProgress,
          completedModules: completedModules,
          assessmentResults: assessmentResults,
          lastUpdated:
              (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      } else {
        // Return empty progress if no document exists
        return UserProgress(
          userId: userId,
          moduleProgress: {},
          completedModules: [],
          assessmentResults: [],
          lastUpdated: DateTime.now(),
        );
      }
    } catch (e) {
      // Return empty progress on error
      return UserProgress(
        userId: userId,
        moduleProgress: {},
        completedModules: [],
        assessmentResults: [],
        lastUpdated: DateTime.now(),
      );
    }
  }

  @override
  Future<void> updateModuleProgress(
      String userId, String moduleId, double progress) async {
    try {
      // First check if document exists
      final userDoc =
          await _firestore.collection('user_progress').doc(userId).get();

      if (userDoc.exists) {
        // Update existing document
        await _firestore.collection('user_progress').doc(userId).update({
          'moduleProgress.$moduleId': progress,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new document with initial progress
        await _firestore.collection('user_progress').doc(userId).set({
          'moduleProgress': {moduleId: progress},
          'completedModules': [],
          'assessmentResults': [],
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markModuleCompleted(String userId, String moduleId) async {
    try {
      // First check if document exists
      final userDoc =
          await _firestore.collection('user_progress').doc(userId).get();

      if (userDoc.exists) {
        // Update existing document with arrayUnion
        await _firestore.collection('user_progress').doc(userId).update({
          'completedModules': FieldValue.arrayUnion([moduleId]),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new document with initial completed module
        await _firestore.collection('user_progress').doc(userId).set({
          'moduleProgress': {},
          'completedModules': [moduleId],
          'assessmentResults': [],
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveAssessmentResult(
      String userId, AssessmentResult result) async {
    try {
      // Convert recommendations to a format suitable for Firestore
      List<Map<String, dynamic>> recommendationsData = [];
      for (var rec in result.recommendations) {
        recommendationsData.add({
          'id': rec.id,
          'title': rec.title,
          'description': rec.description,
          'category': rec.category,
          'priority': rec.priority.value,
          'relatedContentIds': rec.relatedContentIds,
        });
      }

      // Convert AssessmentResult to map for Firestore
      Map<String, dynamic> resultMap = {
        'overallScore': result.overallScore,
        'timestamp': result.timestamp.millisecondsSinceEpoch,
        'categoryScores': result.categoryScores,
        // Add isPostAssessment flag and readinessLevel
        'isPostAssessment': result.isPostAssessment,
        'readinessLevel': result.readinessLevel,
        // Store full recommendations data
        'recommendations': recommendationsData,
        // Also keep recommendation IDs for backward compatibility
        'recommendationIds': result.recommendations.map((r) => r.id).toList(),
        // Converting complex objects to simple maps
        'eligibility': {
          'meritBased': result.eligibility.meritBased,
          'needBased': result.eligibility.needBased,
          'eligibilityScore': result.eligibility.eligibilityScore,
          'strengthAreas': result.eligibility.strengthAreas,
          'improvementAreas': result.eligibility.improvementAreas,
        },
      };

      // First get the user document
      final userDoc =
          await _firestore.collection('user_progress').doc(userId).get();

      if (userDoc.exists) {
        // Update existing document with arrayUnion for assessment results
        await _firestore.collection('user_progress').doc(userId).update({
          'assessmentResults': FieldValue.arrayUnion([resultMap]),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new document with initial array for assessment results
        await _firestore.collection('user_progress').doc(userId).set({
          'assessmentResults': [resultMap],
          'moduleProgress': {},
          'completedModules': [],
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // Silently handle errors
    }
  }

  RecommendationPriority _intToPriorityEnum(int value) {
    switch (value) {
      case 5:
        return RecommendationPriority.high;
      case 3:
        return RecommendationPriority.medium;
      case 1:
        return RecommendationPriority.low;
      default:
        // For any other value, map to medium by default
        return RecommendationPriority.medium;
    }
  }
}
