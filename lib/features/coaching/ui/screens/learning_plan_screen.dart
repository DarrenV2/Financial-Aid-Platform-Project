import 'package:flutter/material.dart';
import '../../models/assessment_result.dart';
import '../../models/learning_module.dart';
import '../../services/learning_service.dart';
import '../../services/progress_service.dart';
import 'module_detail_screen.dart';

class LearningPlanScreen extends StatefulWidget {
  final AssessmentResult result;

  const LearningPlanScreen({Key? key, required this.result}) : super(key: key);

  @override
  _LearningPlanScreenState createState() => _LearningPlanScreenState();
}

class _LearningPlanScreenState extends State<LearningPlanScreen> {
  final LearningService _learningService = LearningService();
  final ProgressService _progressService = ProgressService();

  late List<LearningModule> recommendedModules;
  late Map<String, double> moduleProgress = {};
  late List<String> completedModules = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Get user progress
    final userProgress = await _progressService.getUserProgress('user123');

    // Get recommended modules
    final modules = _learningService.getRecommendedModules(widget.result);

    setState(() {
      recommendedModules = modules;
      moduleProgress = userProgress.moduleProgress;
      completedModules = userProgress.completedModules;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Learning Plan'),
          elevation: 0,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
        onRefresh: () async {
      await _loadData();
    },
    child: SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    // Plan introduction
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
    Text(
    'Your Personalized Learning Plan',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 8),
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
    ),

    SizedBox(height: 24),

    // Priority modules section
    Text(
    'Recommended Modules',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 8),
    recommendedModules.isEmpty
    ? Center(
    child: Padding(
    padding: const EdgeInsets.all(24.0),
    child: Text(
    'No specific modules recommended at this time. Explore our full catalog below.',
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.grey[600]),
    ),
    ),
    )
        : ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: recommendedModules.length,
    itemBuilder: (context, index) {
    return _buildModuleCard(
    context,
    recommendedModules[index],
    priority: index + 1,
    );
    },
    ),

    SizedBox(height: 24),

    // Full catalog
    Text(
    'Full Module Catalog',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 8),
    ...['academic', 'leadership', 'community_service', 'strategy'].map((category) {
    List<LearningModule> categoryModules = _learningService.getAllModules()
        .where((module) => module.category == category)
        .toList();

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
        ...categoryModules.map((module) => _buildModuleCard(context, module)).toList(),
      ],
    );
    }).toList(),
    ],
    ),
    ),
    ),
        ),
    );
  }

  Widget _buildModuleCard(BuildContext context, LearningModule module, {int? priority}) {
    // Get progress for this module if available
    double progress = moduleProgress[module.id] ?? 0.0;
    bool isCompleted = completedModules.contains(module.id);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: priority != null ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: priority != null
            ? BorderSide(color: _getPriorityColor(priority), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleDetailScreen(module: module),
            ),
          ).then((_) {
            // Refresh data when returning from module screen
            _loadData();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (priority != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Priority ${priority}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (priority != null) SizedBox(width: 8),
                  Chip(
                    label: Text(
                      _formatCategoryName(module.category),
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: _getCategoryColor(module.category).withOpacity(0.1),
                    side: BorderSide(color: _getCategoryColor(module.category)),
                  ),
                  Spacer(),
                  if (isCompleted)
                    Chip(
                      label: Text(
                        'Completed',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    )
                  else
                    _buildDifficultyIndicator(module.difficulty),
                ],
              ),
              SizedBox(height: 8),
              Text(
                module.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                module.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              if (progress > 0 && !isCompleted)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress: ${progress.toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${(module.contents.length * progress / 100).round()}/${module.contents.length} lessons',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Icon(Icons.play_circle_outline, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${module.contents.length} lessons',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.quiz_outlined, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${module.assessmentQuestions.length} assessments',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            Icons.star,
            size: 14,
            color: index < difficulty ? Colors.amber : Colors.grey[300],
          );
        }),
        SizedBox(width: 4),
        Text(
          'Level ${difficulty}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _formatCategoryName(String category) {
    return category.replaceAll('_', ' ').split(' ').map((word) =>
    word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ');
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Colors.blue;
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

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber[700]!;
      default:
        return Colors.blue;
    }
  }
}