import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/assessment_result.dart';
import '../../controllers/coaching_controller.dart';

class AssessmentResultScreen extends StatefulWidget {
  final AssessmentResult result;

  const AssessmentResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<AssessmentResultScreen> createState() => _AssessmentResultScreenState();
}

class _AssessmentResultScreenState extends State<AssessmentResultScreen> {
  late final CoachingController coachingController;

  @override
  void initState() {
    super.initState();
    // Get the coaching controller
    coachingController = Get.find<CoachingController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessment Results'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Overall score card
              _buildOverallScoreCard(context),

              const SizedBox(height: 24),

              // Category scores
              _buildCategoryScoresCard(context),

              const SizedBox(height: 24),

              // Eligibility section
              _buildEligibilityCard(context),

              const SizedBox(height: 24),

              // Recommendations
              _buildRecommendationsCard(context),

              const SizedBox(height: 32),

              // Next steps
              ElevatedButton(
                onPressed: () {
                  coachingController.viewLearningPlan();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('View My Learning Plan'),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Get.offAllNamed('/user-dashboard/coaching');
                },
                child: const Text('Back to Coaching Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Your Overall Eligibility Score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildScoreIndicator(widget.result.overallScore),
            const SizedBox(height: 16),
            Text(
              _getOverallScoreDescription(widget.result.overallScore),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreIndicator(double score) {
    final Color scoreColor = _getScoreColor(score);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 12,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
          ),
        ),
        Column(
          children: [
            Text(
              '${score.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
            Text(
              _getScoreLabel(score),
              style: TextStyle(
                fontSize: 16,
                color: scoreColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryScoresCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Scores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...widget.result.categoryScores.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatCategoryName(entry.key),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${entry.value.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(entry.value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: entry.value / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          _getScoreColor(entry.value)),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEligibilityCard(BuildContext context) {
    final eligibility = widget.result.eligibility;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scholarship Eligibility',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildEligibilityItem(
              'Merit-Based Scholarships',
              eligibility.meritBased,
              eligibility.meritBased
                  ? 'You meet the basic criteria for merit-based scholarships.'
                  : 'Your academic or extracurricular scores need improvement for merit-based eligibility.',
            ),
            const Divider(),
            _buildEligibilityItem(
              'Need-Based Scholarships',
              eligibility.needBased,
              eligibility.needBased
                  ? 'You meet the basic criteria for need-based financial aid.'
                  : 'Your financial need assessment needs additional documentation.',
            ),

            const SizedBox(height: 16),

            // Strengths
            if (eligibility.strengthAreas.isNotEmpty) ...[
              const Text(
                'Your Strengths',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ...eligibility.strengthAreas.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_formatCategoryName(entry.key)}: ${entry.value}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],

            const SizedBox(height: 16),

            // Improvement areas
            if (eligibility.improvementAreas.isNotEmpty) ...[
              const Text(
                'Areas for Improvement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ...eligibility.improvementAreas.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_circle_up,
                        color: const Color.fromARGB(255, 221, 138, 4),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_formatCategoryName(entry.key)}: ${entry.value}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEligibilityItem(
      String title, bool isEligible, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isEligible ? Icons.check_circle : Icons.info,
            color: isEligible ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Based on your assessment, we recommend the following:',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ...widget.result.recommendations.map((recommendation) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildRecommendationItem(context, recommendation),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(
      BuildContext context, Recommendation recommendation) {
    final Color priorityColor = _getPriorityColor(recommendation.priority);
    return InkWell(
      onTap: () {
        Get.toNamed(
          '/coaching/recommendation',
          arguments: {'recommendation': recommendation},
        );
      },
      borderRadius: BorderRadius.circular(12),
      splashColor: priorityColor.withAlpha(26),
      highlightColor: priorityColor.withAlpha(13),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(51),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getPriorityLabel(recommendation.priority),
                    style: TextStyle(
                      color: priorityColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recommendation.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    recommendation.description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: priorityColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          color: priorityColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: priorityColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCategoryName(String? category) {
    if (category == null) return 'General';

    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }

  String _getOverallScoreDescription(double score) {
    if (score >= 80) {
      return 'You have a strong scholarship profile. Focus on applying to scholarships that match your strengths.';
    } else if (score >= 60) {
      return 'You have a good foundation. Follow your learning plan to strengthen your application and eligibility.';
    } else if (score >= 40) {
      return 'Your profile needs improvement in several areas. Your learning plan will help you identify key opportunities.';
    } else {
      return 'Start with the basics in your learning plan to build a stronger scholarship profile.';
    }
  }

  Color _getPriorityColor(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.high:
        return Colors.red;
      case RecommendationPriority.medium:
        return Colors.orange;
      case RecommendationPriority.low:
        return Colors.blue;
    }
  }

  String _getPriorityLabel(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.high:
        return 'High Priority';
      case RecommendationPriority.medium:
        return 'Medium Priority';
      case RecommendationPriority.low:
        return 'Recommended';
    }
  }

  Color _getCategoryColor(String? category) {
    if (category == null) return Colors.grey;

    switch (category.toLowerCase()) {
      case 'academic':
        return Colors.blue;
      case 'financial':
        return Colors.green;
      case 'leadership':
        return Colors.purple;
      case 'extracurricular':
        return Colors.orange;
      case 'community_service':
        return Colors.red;
      case 'strategy':
        return Colors.teal;
      case 'personal':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }
}
