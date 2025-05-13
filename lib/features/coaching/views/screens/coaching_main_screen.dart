import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/coaching_controller.dart';
import '../../models/assessment_result.dart';
import '../../controllers/learning_controller.dart';

class CoachingMainScreen extends StatefulWidget {
  const CoachingMainScreen({Key? key}) : super(key: key);

  @override
  State<CoachingMainScreen> createState() => _CoachingMainScreenState();
}

class _CoachingMainScreenState extends State<CoachingMainScreen>
    with WidgetsBindingObserver {
  late final CoachingController coachingController;
  late final LearningController learningController;
  final RxBool dataLoaded = false.obs;

  @override
  void initState() {
    super.initState();
    coachingController =
        Get.put(CoachingController(), tag: 'CoachingController');
    learningController = Get.put(LearningController());

    // Register for lifecycle events to handle returning to screen
    WidgetsBinding.instance.addObserver(this);

    // Wait until after the first frame is built before initializing controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initControllers();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes to foreground
      _refreshData();
    }
  }

  // Method to refresh all the necessary data
  void _refreshData() {
    if (mounted) {
      coachingController.loadUserData();
      learningController.refreshProgressFromFirestore();
    }
  }

  Future<void> _initControllers() async {
    try {
      // When the screen initializes, if there's a last assessment result,
      // make sure to load the recommended modules for that result
      if (coachingController.lastAssessmentResult.value != null) {
        await learningController.loadRecommendedModules(
            coachingController.lastAssessmentResult.value!);
      }

      dataLoaded.value = true;
    } catch (e) {
      print('Error initializing controllers: $e');
      dataLoaded.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarship Coaching'),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (coachingController.isLoading.value || !dataLoaded.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool allRequiredModulesCompleted =
            _checkRequiredModulesCompleted(learningController);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome card
                _buildWelcomeCard(context),

                const SizedBox(height: 24),

                // Assessment section
                _buildAssessmentSection(
                    context, coachingController, allRequiredModulesCompleted),

                const SizedBox(height: 24),

                // Learning plan section if assessment completed
                if (coachingController.hasCompletedAssessment.value)
                  _buildLearningPlanSection(context, coachingController),

                const SizedBox(height: 24),

                // Tips section
                _buildTipsSection(context),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool _checkRequiredModulesCompleted(LearningController controller) {
    // Use the controller's method to be consistent with the actual unlock logic
    // This ensures the UI check matches what the controller uses
    return coachingController.canTakePostAssessment.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // When returning to the screen, refresh data to ensure module status is updated
    if (mounted && dataLoaded.value) {
      _refreshData();
    }
  }

  Widget _buildWelcomeCard(BuildContext context) {
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
            Text(
              'Scholarship Coaching',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Welcome to your personalized coaching experience. Here you can take assessments, get recommendations, and follow a learning plan to improve your scholarship eligibility.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentSection(BuildContext context,
      CoachingController controller, bool allRequiredModulesCompleted) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.hasCompletedAssessment.value
                  ? 'Your Assessment'
                  : 'Start Your Assessment',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.hasCompletedAssessment.value
                  ? 'View your assessment results or take a reassessment to track your progress.'
                  : 'Take our assessment to identify your scholarship readiness and create a personalized learning plan.',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.startPreAssessment,
                    child: Text(
                      controller.hasCompletedAssessment.value
                          ? 'Retake Assessment'
                          : 'Start Assessment',
                    ),
                  ),
                ),
                if (controller.hasCompletedAssessment.value) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          '/coaching/results',
                          arguments: {
                            'result': controller.lastAssessmentResult.value,
                            'isPostAssessment': false,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      child: const Text('View Results'),
                    ),
                  ),
                ],
              ],
            ),

            // Add post-assessment section if pre-assessment is completed
            if (controller.hasCompletedAssessment.value) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Post-assessment section title
              const Text(
                'Scholarship Readiness Assessment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Obx(() {
                // This uses Obx to always get the latest value from the controller
                final canTakePostAssessment =
                    controller.canTakePostAssessment.value;
                final completedPostAssessment =
                    controller.hasCompletedPostAssessment.value;

                if (completedPostAssessment) {
                  // Show readiness level if post-assessment is completed
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getReadinessColor(controller
                                      .lastPostAssessmentResult
                                      .value
                                      ?.overallScore ??
                                  0)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getReadinessColor(controller
                                        .lastPostAssessmentResult
                                        .value
                                        ?.overallScore ??
                                    0)
                                .withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.emoji_events,
                                  color: _getReadinessColor(controller
                                          .lastPostAssessmentResult
                                          .value
                                          ?.overallScore ??
                                      0),
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Scholarship Readiness',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: _getReadinessColor(controller
                                                  .lastPostAssessmentResult
                                                  .value
                                                  ?.overallScore ??
                                              0),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        controller.lastPostAssessmentResult
                                                .value?.readinessLevel ??
                                            'Not Available',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: controller.startPostAssessment,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retake Assessment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.toNamed(
                                  '/coaching/results',
                                  arguments: {
                                    'result': controller
                                        .lastPostAssessmentResult.value,
                                    'isPostAssessment': true,
                                  },
                                );
                              },
                              icon: const Icon(Icons.visibility),
                              label: const Text('View Details'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (canTakePostAssessment) {
                  // Show button to take post-assessment
                  return ElevatedButton.icon(
                    onPressed: controller.startPostAssessment,
                    icon: const Icon(Icons.assessment),
                    label: const Text('Take Readiness Assessment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                } else {
                  // Show progress toward unlocking post-assessment
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Complete these modules to unlock:',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      _buildRequiredModulesList(context),
                    ],
                  );
                }
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRequiredModulesList(BuildContext context) {
    // Get the learning controller to access module information
    final learningController = Get.find<LearningController>();

    // Get recommended modules from the pre-assessment result
    final recommendedModuleIds = coachingController
            .lastAssessmentResult.value?.recommendations
            .where((rec) =>
                rec.learningModuleId != null &&
                rec.learningModuleId!.isNotEmpty)
            .map((rec) => rec.learningModuleId!)
            .toList() ??
        [];

    // Get related content modules
    final relatedModuleIds = coachingController
            .lastAssessmentResult.value?.recommendations
            .where((rec) => rec.relatedContentIds.isNotEmpty)
            .expand((rec) => rec.relatedContentIds)
            .where((id) => id.isNotEmpty)
            .toList() ??
        [];

    // Create a set to combine and remove duplicates
    final allRequiredModuleIds = <String>{};
    allRequiredModuleIds.addAll(recommendedModuleIds);
    allRequiredModuleIds.addAll(relatedModuleIds);

    // Filter out any empty strings
    allRequiredModuleIds.removeWhere((moduleId) => moduleId.isEmpty);

    // Fall back to default modules if no recommendations exist
    final defaultModuleIds = [
      'module_academic_improvement',
      'module_essay_writing',
      'module_leadership_development'
    ];

    // Use the default modules if no valid recommendations exist
    final requiredModules = allRequiredModuleIds.isEmpty
        ? defaultModuleIds
        : allRequiredModuleIds.toList();

    // Filter to only include modules that actually exist
    final validModules = requiredModules
        .where((moduleId) => learningController.getModuleById(moduleId) != null)
        .toList();

    // If no valid modules found, show a message instead
    if (validModules.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'All learning modules are available to access in the Learning Plan section.',
          style:
              TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      children: validModules.map((moduleId) {
        final module = learningController.getModuleById(moduleId);
        if (module == null) return Container(); // Skip if module doesn't exist

        final isCompleted =
            learningController.completedModules.contains(moduleId);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCompleted
                    ? Colors.green.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
              ),
              color:
                  isCompleted ? Colors.green.withOpacity(0.05) : Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: isCompleted ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: TextStyle(
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted ? Colors.grey : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (module.description != null && !isCompleted)
                        Text(
                          module.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (!isCompleted)
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/coaching/module',
                          arguments: {'module': module});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('Go'),
                  ),
              ],
            ),
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

  Widget _buildLearningPlanSection(
      BuildContext context, CoachingController controller) {
    AssessmentResult? result = controller.lastAssessmentResult.value;

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
            Text(
              'Your Learning Plan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (result != null) ...[
              Text(
                'Based on your assessment, we\'ve created a personalized learning plan for you.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading:
                    Icon(Icons.school, color: Theme.of(context).primaryColor),
                title: const Text('Overall Eligibility Score'),
                trailing: Text(
                  '${result.overallScore.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getScoreColor(result.overallScore),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.viewLearningPlan,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('View Your Learning Plan'),
              ),
            ] else ...[
              Text(
                'Complete an assessment to get your personalized learning plan.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection(BuildContext context) {
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
            Text(
              'Quick Tips',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildTipItem(
              context,
              'Complete your profile to maximize your scholarship matches',
              Icons.person,
            ),
            _buildTipItem(
              context,
              'Set reminders for scholarship deadlines',
              Icons.calendar_today,
            ),
            _buildTipItem(
              context,
              'Review your learning plan regularly to stay on track',
              Icons.psychology,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
