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

class _CoachingMainScreenState extends State<CoachingMainScreen> {
  late final CoachingController coachingController;
  late final LearningController learningController;
  final RxBool dataLoaded = false.obs;

  @override
  void initState() {
    super.initState();
    coachingController = Get.put(CoachingController());
    learningController = Get.put(LearningController());

    // Wait until after the first frame is built before initializing controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initControllers();
    });
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
    final requiredModules = [
      'module_academic_profile',
      'module_essay_writing',
      'module_leadership'
    ];

    return requiredModules
        .every((moduleId) => controller.completedModules.contains(moduleId));
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
            if (controller.hasCompletedAssessment.value &&
                allRequiredModulesCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Progress Tracking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You\'ve completed all required modules!',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
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
