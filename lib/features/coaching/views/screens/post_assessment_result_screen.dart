import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/assessment_result.dart';
import '../../controllers/coaching_controller.dart';
import '../../controllers/learning_controller.dart';

class PostAssessmentResultScreen extends StatefulWidget {
  final AssessmentResult result;

  const PostAssessmentResultScreen({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  State<PostAssessmentResultScreen> createState() =>
      _PostAssessmentResultScreenState();
}

class _PostAssessmentResultScreenState
    extends State<PostAssessmentResultScreen> {
  late final CoachingController coachingController;

  @override
  void initState() {
    super.initState();
    coachingController = Get.find<CoachingController>();
  }

  // Add a new method to get modules by ID safely
  void _navigateToModule(String? moduleId) {
    if (moduleId == null || moduleId.isEmpty) {
      Get.snackbar(
        'Module Not Found',
        'Sorry, this module is not available at the moment.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final learningController = Get.find<LearningController>();
    final module = learningController.getModuleById(moduleId);

    if (module != null) {
      Get.toNamed('/coaching/module', arguments: {'module': module});
    } else {
      Get.snackbar(
        'Module Not Found',
        'Sorry, the requested module could not be found.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarship Readiness Results'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display readiness level
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Readiness Level',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildScoreIndicator(widget.result.overallScore),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.result.readinessLevel ??
                          'Score: ${widget.result.overallScore.toStringAsFixed(0)} out of 30',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _getReadinessColor(widget.result.overallScore),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'What this means:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildReadinessExplanation(widget.result.overallScore),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Category scores
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category Breakdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...widget.result.categoryScores.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildCategoryScore(entry.key, entry.value),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Recommendations
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Steps & Recommendations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...widget.result.recommendations.map((recommendation) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildRecommendation(recommendation),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Documents checklist
            if (widget.result.isPostAssessment)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Application Documents Checklist',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Make sure you have these documents ready when applying:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDocumentsChecklist(),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // Return to dashboard button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/user-dashboard/coaching');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Return to Dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreIndicator(double score) {
    Color color = _getReadinessColor(score);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          score.toStringAsFixed(0),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildReadinessExplanation(double score) {
    if (score >= 25) {
      return const Text(
        'You appear well-prepared for scholarship applications. Your scores indicate strong readiness in key areas that scholarship committees look for. Start applying for scholarships that match your profile.',
      );
    } else if (score >= 15) {
      return const Text(
        'You\'re making good progress, but have some areas to improve before reaching your full potential. Focus on the categories with lower scores to strengthen your applications.',
      );
    } else {
      return const Text(
        'Your current readiness level suggests you need more preparation before applying to competitive scholarships. Follow the recommended modules to build your profile in key areas.',
      );
    }
  }

  Widget _buildCategoryScore(String category, double score) {
    String formattedCategory = category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formattedCategory,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${score.toStringAsFixed(0)}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getCategoryScoreColor(score),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: score / 100,
          backgroundColor: Colors.grey[300],
          valueColor:
              AlwaysStoppedAnimation<Color>(_getCategoryScoreColor(score)),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildRecommendation(Recommendation recommendation) {
    Color priorityColor;

    switch (recommendation.priority) {
      case RecommendationPriority.high:
        priorityColor = Colors.red;
        break;
      case RecommendationPriority.medium:
        priorityColor = Colors.orange;
        break;
      case RecommendationPriority.low:
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4, right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: priorityColor,
                ),
              ),
              Expanded(
                child: Text(
                  recommendation.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recommendation.description),
                if (recommendation.action != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey.withOpacity(0.1),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            size: 16, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            recommendation.action!,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (recommendation.learningModuleId != null) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Use our safer navigation method
                      _navigateToModule(recommendation.learningModuleId);
                    },
                    icon: const Icon(Icons.school),
                    label: const Text('View Related Module'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsChecklist() {
    final List<String> documents = [
      'Official transcripts (sealed/unopened copies)',
      'Standardized test scores (if required)',
      'Proof of enrollment/acceptance',
      'Financial aid forms (e.g., FAFSA SAR)',
      'Recommendation Letters',
      'Resume/CV (1-page, updated)',
      'Personal statement/essay',
      'Volunteer hour logs',
      'Award certificates',
    ];

    return Column(
      children: documents.map((doc) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(doc)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getReadinessColor(double score) {
    if (score >= 25) return Colors.green;
    if (score >= 15) return Colors.orange;
    return Colors.red;
  }

  Color _getCategoryScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
