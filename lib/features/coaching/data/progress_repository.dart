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
      print("FirestoreProgressRepository: Getting progress for user $userId");
      final doc =
          await _firestore.collection('user_progress').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        print("FirestoreProgressRepository: Found user progress document");

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
          print(
              "FirestoreProgressRepository: Found assessment results: ${(data['assessmentResults'] as List).length}");
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
                print(
                    "FirestoreProgressRepository: Found full recommendations data");
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
                        priority: (recMap['priority'] as num).toInt(),
                        relatedContentIds: relatedContentIds,
                      ));
                    } catch (e) {
                      print("Error parsing recommendation: $e");
                    }
                  }
                }
              }
              // Fall back to ID-based recommendations if full data not available
              else if (typedMap['recommendationIds'] != null) {
                print(
                    "FirestoreProgressRepository: Using recommendationIds fallback");
                final List<dynamic> recIds =
                    typedMap['recommendationIds'] as List;
                for (var id in recIds) {
                  String recId = id.toString();
                  // Create related content IDs based on category
                  List<String> relatedContentIds = [];

                  // Map recommendation IDs to specific module IDs based on category
                  if (recId.contains('academic')) {
                    relatedContentIds.add('module_academic_profile');
                    relatedContentIds.add('module_essay_writing');
                  } else if (recId.contains('financial')) {
                    relatedContentIds.add('module_financial_aid');
                    relatedContentIds.add('module_scholarships_101');
                  } else if (recId.contains('leadership')) {
                    relatedContentIds.add('module_leadership');
                    relatedContentIds.add('module_community_service');
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
                            : 'leadership',
                    priority: 3, // Default medium priority
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

              // Create full AssessmentResult
              assessmentResults.add(AssessmentResult(
                timestamp: timestamp,
                overallScore: overallScore,
                categoryScores: categoryScores,
                recommendations: recommendations,
                eligibility: eligibility,
              ));

              print(
                  "FirestoreProgressRepository: Loaded assessment result with score $overallScore and ${recommendations.length} recommendations");
            } catch (e) {
              print("Error parsing assessment result: $e");
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
        print("FirestoreProgressRepository: No user progress document found");
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
      print('Error getting user progress from Firestore: $e');
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
      print('Error updating module progress in Firestore: $e');
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
      print('Error marking module as completed in Firestore: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveAssessmentResult(
      String userId, AssessmentResult result) async {
    try {
      print(
          "FirestoreProgressRepository: Saving assessment result for user $userId with score ${result.overallScore}");

      // Convert recommendations to a format suitable for Firestore
      List<Map<String, dynamic>> recommendationsData = [];
      for (var rec in result.recommendations) {
        recommendationsData.add({
          'id': rec.id,
          'title': rec.title,
          'description': rec.description,
          'category': rec.category,
          'priority': rec.priority,
          'relatedContentIds': rec.relatedContentIds,
        });
      }

      // Convert AssessmentResult to map for Firestore
      Map<String, dynamic> resultMap = {
        'overallScore': result.overallScore,
        'timestamp': result.timestamp.millisecondsSinceEpoch,
        'categoryScores': result.categoryScores,
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
        print(
            "FirestoreProgressRepository: Updating existing user progress document");
        // Update existing document with arrayUnion for assessment results
        await _firestore.collection('user_progress').doc(userId).update({
          'assessmentResults': FieldValue.arrayUnion([resultMap]),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        print(
            "FirestoreProgressRepository: Creating new user progress document");
        // Create new document with initial array for assessment results
        await _firestore.collection('user_progress').doc(userId).set({
          'assessmentResults': [resultMap],
          'moduleProgress': {},
          'completedModules': [],
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }

      print(
          "FirestoreProgressRepository: Successfully saved assessment result");
    } catch (e) {
      print('Error saving assessment result in Firestore: $e');
      rethrow;
    }
  }
}
