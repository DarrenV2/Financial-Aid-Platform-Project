import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/assessment_result.dart';
import '../../models/learning_module.dart';
import '../../controllers/learning_controller.dart';

class LearningPlanScreen extends StatefulWidget {
  final AssessmentResult result;

  const LearningPlanScreen({Key? key, required this.result}) : super(key: key);

  @override
  State<LearningPlanScreen> createState() => _LearningPlanScreenState();
}

class _LearningPlanScreenState extends State<LearningPlanScreen> {
  late final LearningController learningController;
  final RxBool dataLoaded = false.obs;

  @override
  void initState() {
    super.initState();
    // Initialize controller
    learningController = Get.put(LearningController());

    // Wait until after the first frame is built before loading data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      await learningController.loadRecommendedModules(widget.result);
      dataLoaded.value = true;
    } catch (e) {
      print('Error loading data: $e');
      dataLoaded.value = true; // Set to true anyway to show error state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Learning Plan'),
        elevation: 0,
        actions: [
          // Add refresh button to manually sync with Firestore
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh progress data',
            onPressed: () async {
              await learningController.refreshProgressFromFirestore();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Progress data refreshed from database'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (learningController.isLoading.value || !dataLoaded.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Plan introduction
                  _buildPlanIntroCard(context),

                  const SizedBox(height: 24),

                  // Recommended modules section
                  const Text(
                    'Recommended Modules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (learningController.recommendedModules.isEmpty)
                    _buildEmptyRecommendationsMessage(context)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: learningController.recommendedModules.length,
                      itemBuilder: (context, index) {
                        return _buildModuleCard(
                          context,
                          learningController,
                          learningController.recommendedModules[index],
                          priority: index + 1,
                        );
                      },
                    ),

                  const SizedBox(height: 24),

                  // Full module catalog by category
                  const Text(
                    'Full Module Catalog',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ..._buildCategoryModules(context, learningController),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPlanIntroCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Personalized Learning Plan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Based on your assessment results, we\'ve created a customized learning plan to help you maximize your scholarship opportunities. Complete these modules to improve your eligibility and application strength.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRecommendationsMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          'No specific modules recommended at this time. Explore our full catalog below.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  List<Widget> _buildCategoryModules(
      BuildContext context, LearningController controller) {
    final categories = [
      'academic',
      'leadership',
      'community_service',
      'strategy'
    ];

    return categories.map((category) {
      final categoryModules = controller.getModulesByCategory(category);

      if (categoryModules.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 8.0),
            child: Text(
              _formatCategoryName(category),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getCategoryColor(category),
              ),
            ),
          ),
          ...categoryModules
              .map((module) => _buildModuleCard(context, controller, module)),
        ],
      );
    }).toList();
  }

  Widget _buildModuleCard(
    BuildContext context,
    LearningController controller,
    LearningModule module, {
    int? priority,
  }) {
    // Get progress for this module if available
    double progress = controller.moduleProgress[module.id] ?? 0.0;
    bool isCompleted = controller.completedModules.contains(module.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: priority != null ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: priority != null
            ? BorderSide(color: _getPriorityColor(priority), width: 2)
            : BorderSide.none,
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
              // Module header with title and difficulty
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      module.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (priority != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(priority).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Priority $priority',
                            style: TextStyle(
                              fontSize: 12,
                              color: _getPriorityColor(priority),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      _buildDifficultyIndicator(module.difficulty),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Module description
              Text(
                module.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 12),

              // Category chip
              Chip(
                label: Text(
                  _formatCategoryName(module.category),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getCategoryColor(module.category),
                  ),
                ),
                backgroundColor:
                    _getCategoryColor(module.category).withOpacity(0.2),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),

              const SizedBox(height: 12),

              // Progress indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isCompleted ? 'Completed' : 'Progress',
                        style: TextStyle(
                          fontSize: 14,
                          color: isCompleted ? Colors.green : Colors.grey[700],
                          fontWeight:
                              isCompleted ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                      Text(
                        '${progress.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isCompleted ? Colors.green : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted
                          ? Colors.green
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator(int difficulty) {
    final color = difficulty <= 2
        ? Colors.green
        : difficulty <= 4
            ? Colors.orange
            : Colors.red;

    return Row(
      children: [
        Text(
          'Difficulty:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 4),
        ...List.generate(5, (index) {
          return Icon(
            index < difficulty ? Icons.star : Icons.star_border,
            color: index < difficulty ? color : Colors.grey[400],
            size: 14,
          );
        }),
      ],
    );
  }

  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'academic':
        return Colors.blue;
      case 'financial':
        return Colors.green;
      case 'leadership':
        return Colors.orange;
      case 'community_service':
        return Colors.red;
      case 'strategy':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(int? priority) {
    if (priority == null) return Colors.grey;
    if (priority == 1) return Colors.red;
    if (priority == 2) return Colors.orange;
    return Colors.blue;
  }
}
