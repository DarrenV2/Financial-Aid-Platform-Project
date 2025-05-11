import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/assessment_result.dart';
import '../../models/learning_module.dart';
import '../../controllers/learning_controller.dart';

class RecommendationDetailScreen extends StatefulWidget {
  final Recommendation recommendation;

  const RecommendationDetailScreen({super.key, required this.recommendation});

  @override
  State<RecommendationDetailScreen> createState() =>
      _RecommendationDetailScreenState();
}

class _RecommendationDetailScreenState
    extends State<RecommendationDetailScreen> {
  late final LearningController learningController;
  // Convert to RxList for proper reactivity
  final RxList<LearningModule> relatedModules = <LearningModule>[].obs;

  @override
  void initState() {
    super.initState();
    // Find learning controller
    learningController = Get.find<LearningController>();

    // Load related modules
    _loadRelatedModules();
  }

  void _loadRelatedModules() {
    for (String moduleId in widget.recommendation.relatedContentIds) {
      LearningModule? module = learningController.getModuleById(moduleId);
      if (module != null) {
        relatedModules.add(module);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendation Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and priority
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getPriorityColor(widget.recommendation.priority)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getPriorityColor(widget.recommendation.priority),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(
                                widget.recommendation.priority),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getPriorityLabel(widget.recommendation.priority),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            _formatCategoryName(widget.recommendation.category),
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor:
                              _getCategoryColor(widget.recommendation.category)
                                  .withOpacity(0.1),
                          side: BorderSide(
                              color: _getCategoryColor(
                                  widget.recommendation.category)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.recommendation.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.recommendation.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Detailed explanation
              const Text(
                'Why This Matters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getDetailedExplanation(widget.recommendation),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              // Action steps
              const Text(
                'Recommended Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ..._getActionSteps(widget.recommendation).map((step) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Related modules
              const Text(
                'Recommended Learning Modules',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Module list with Obx for reactivity
              Obx(() {
                if (relatedModules.isEmpty) {
                  return Text(
                    'No specific modules found for this recommendation.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  );
                }

                return Column(
                  children: relatedModules.map((module) {
                    // Get progress for this module if available - using Rx variables from the controller
                    double progress =
                        learningController.moduleProgress[module.id] ?? 0.0;
                    bool isCompleted =
                        learningController.completedModules.contains(module.id);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(
                            '/coaching/module',
                            arguments: {'module': module},
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(module.category)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(module.category),
                                      color: _getCategoryColor(module.category),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          module.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Difficulty: ${_getDifficultyLabel(module.difficulty)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isCompleted)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                module.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: progress / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isCompleted
                                      ? Colors.green
                                      : Theme.of(context).primaryColor,
                                ),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Progress: ${progress.toInt()}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  if (isCompleted)
                                    const Text(
                                      'Completed',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 5:
        return Colors.red;
      case 4:
        return Colors.deepOrange;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.amber;
      case 1:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 5:
        return 'High Priority';
      case 4:
        return 'Important';
      case 3:
        return 'Medium Priority';
      case 2:
        return 'Recommended';
      case 1:
        return 'Optional';
      default:
        return 'Priority $priority';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Colors.blue;
      case 'financial':
        return Colors.green;
      case 'leadership':
        return Colors.purple;
      case 'extracurricular':
        return Colors.orange;
      case 'strategy':
        return Colors.teal;
      case 'community_service':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Icons.school;
      case 'financial':
        return Icons.attach_money;
      case 'leadership':
        return Icons.people;
      case 'extracurricular':
        return Icons.sports_soccer;
      case 'strategy':
        return Icons.lightbulb;
      case 'community_service':
        return Icons.volunteer_activism;
      default:
        return Icons.category;
    }
  }

  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Easy';
      case 3:
        return 'Intermediate';
      case 4:
        return 'Advanced';
      case 5:
        return 'Expert';
      default:
        return 'Level $difficulty';
    }
  }

  String _getDetailedExplanation(Recommendation recommendation) {
    // In a real app, this would fetch detailed content from a database
    // Using placeholder text for demonstration
    switch (recommendation.category) {
      case 'academic':
        return 'Strong academic achievements demonstrate your commitment to excellence and your ability to manage responsibilities. Scholarship committees look for students who have proven themselves capable of succeeding in challenging academic environments.';
      case 'financial':
        return 'Understanding and communicating your financial need effectively is crucial for need-based scholarships. Being transparent about your financial situation helps scholarship committees determine how their support can make the most difference.';
      case 'leadership':
        return 'Leadership experience demonstrates your ability to guide, inspire, and work with others. These qualities are highly valued by scholarship committees as they indicate your potential to make significant contributions in your field and community.';
      case 'extracurricular':
        return 'Extracurricular involvement shows that you\'re well-rounded and able to balance multiple commitments. Scholarship committees look for students who contribute to their communities and develop diverse skills beyond the classroom.';
      case 'community_service':
        return 'Community service demonstrates your commitment to helping others and making a positive impact. Many scholarships are specifically designed for students who show dedication to serving their communities and addressing important social issues.';
      case 'strategy':
        return 'A strategic approach to scholarship applications can significantly increase your chances of success. Being organized, thorough, and thoughtful in your applications helps you stand out in a competitive field.';
      default:
        return 'This recommendation is designed to help you improve your scholarship eligibility and application quality. Following these steps will strengthen your overall profile and increase your chances of success.';
    }
  }

  List<String> _getActionSteps(Recommendation recommendation) {
    // In a real app, this would fetch detailed content from a database
    // Using placeholder actions for demonstration
    switch (recommendation.category) {
      case 'academic':
        return [
          'Review your current GPA and identify areas for improvement',
          'Schedule a meeting with your academic advisor to discuss your goals',
          'Create a study plan to maintain or improve your academic performance',
          'Consider enrolling in honors courses or pursuing advanced certifications',
          'Document all academic achievements for your scholarship applications'
        ];
      case 'financial':
        return [
          'Gather all necessary financial documents for scholarship applications',
          'Prepare a detailed budget showing your educational expenses',
          'Research specific need-based scholarships that match your situation',
          'Practice articulating your financial need clearly and effectively',
          'Explore additional financial aid options through your school\'s financial aid office'
        ];
      case 'leadership':
        return [
          'Identify leadership opportunities in your school or community',
          'Take initiative in a current organization or start a new project',
          'Document your leadership experiences and the impact you\'ve made',
          'Seek mentorship from experienced leaders in your field',
          'Reflect on your leadership experiences and areas for growth'
        ];
      case 'extracurricular':
        return [
          'Choose extracurricular activities that align with your interests and career goals',
          'Aim for depth of involvement rather than breadth in key activities',
          'Take on increasing responsibilities in your organizations',
          'Document your contributions and achievements',
          'Connect your extracurricular experiences to your scholarship goals'
        ];
      case 'community_service':
        return [
          'Find volunteer opportunities related to your interests or field of study',
          'Commit to regular service hours with an organization',
          'Track your service hours and the impact of your contributions',
          'Take on leadership roles in service projects',
          'Reflect on how your service experiences have shaped your goals'
        ];
      case 'strategy':
        return [
          'Create a scholarship application calendar with all deadlines',
          'Gather and organize all required documents in advance',
          'Personalize each application to match the scholarship criteria',
          'Have multiple people review your applications before submission',
          'Follow up appropriately after submitting applications'
        ];
      default:
        return [
          'Review the specific recommendation details',
          'Create an action plan with specific, measurable goals',
          'Set deadlines for completing each action item',
          'Track your progress and adjust your approach as needed',
          'Seek support from advisors or mentors as you implement these changes'
        ];
    }
  }
}
