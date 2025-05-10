// lib/features/coaching/ui/screens/recommendation_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/assessment_result.dart';
import '../../models/learning_module.dart';
import '../../services/learning_service.dart';
import '../../services/progress_service.dart';
import 'module_detail_screen.dart';

class RecommendationDetailScreen extends StatefulWidget {
  final Recommendation recommendation;

  const RecommendationDetailScreen({Key? key, required this.recommendation}) : super(key: key);

  @override
  _RecommendationDetailScreenState createState() => _RecommendationDetailScreenState();
}

class _RecommendationDetailScreenState extends State<RecommendationDetailScreen> {
  final LearningService _learningService = LearningService();
  final ProgressService _progressService = ProgressService();

  List<LearningModule> relatedModules = [];
  Map<String, double> moduleProgress = {};
  List<String> completedModules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Get user progress
      final userProgress = await _progressService.getUserProgress('user123');

      // Get related modules
      final modules = <LearningModule>[];
      for (String moduleId in widget.recommendation.relatedContentIds) {
        LearningModule? module = _learningService.getModuleById(moduleId);
        if (module != null) {
          modules.add(module);
        }
      }

      setState(() {
        relatedModules = modules;
        moduleProgress = userProgress.moduleProgress;
        completedModules = userProgress.completedModules;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading recommendation data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Recommendation Details'),
          elevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendation Details'),
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
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getPriorityColor(widget.recommendation.priority).withOpacity(0.1),
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
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(widget.recommendation.priority),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getPriorityLabel(widget.recommendation.priority),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Chip(
                          label: Text(
                            _formatCategoryName(widget.recommendation.category),
                            style: TextStyle(fontSize: 12),
                          ),
                          backgroundColor: _getCategoryColor(widget.recommendation.category).withOpacity(0.1),
                          side: BorderSide(color: _getCategoryColor(widget.recommendation.category)),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      widget.recommendation.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
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

              SizedBox(height: 24),

              // Detailed explanation
              Text(
                'Why This Matters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _getDetailedExplanation(widget.recommendation),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 24),

              // Action steps
              Text(
                'Recommended Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              ..._getActionSteps(widget.recommendation).map((step) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              SizedBox(height: 24),

              // Related modules
              Text(
                'Recommended Learning Modules',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              relatedModules.isEmpty
                  ? Text(
                'No specific modules found for this recommendation.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              )
                  : Column(
                children: relatedModules.map((module) {
                  // Get progress for this module if available
                  double progress = moduleProgress[module.id] ?? 0.0;
                  bool isCompleted = completedModules.contains(module.id);

                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModuleDetailScreen(module: module),
                          ),
                        ).then((_) {
                          // Refresh data when returning from module
                          _loadData();
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    module.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isCompleted)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Completed',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              module.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
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
                                          color: Colors.blue,
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
                            else if (!isCompleted)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
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
                                    ],
                                  ),
                                  Text(
                                    'Start Learning',
                                    style: TextStyle(
                                      color: Colors.blue,
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
              ),
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

  String _formatCategoryName(String category) {
    return category.replaceAll('_', ' ').split(' ').map((word) =>
    word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ');
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Colors.blue;
      case 'financial':
        return Colors.green;
      case 'extracurricular':
        return Colors.teal;
      case 'leadership':
        return Colors.orange;
      case 'community_service':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDetailedExplanation(Recommendation recommendation) {
    // This would typically come from a database, but for now we'll use hardcoded explanations
    switch (recommendation.id) {
      case 'academic_high':
        return 'Your GPA is one of the most important factors scholarship committees consider. A strong academic record demonstrates your ability to succeed in higher education and your commitment to excellence. By improving your GPA, you significantly increase your eligibility for merit-based scholarships.\n\nMany prestigious scholarships have minimum GPA requirements, typically 3.0 or higher, with the most competitive opportunities requiring 3.5 or above. By focusing on your academic performance now, you\'ll open doors to more scholarship opportunities later.';

      case 'academic_low':
        return 'You already have a strong academic foundation, which puts you in an excellent position for scholarship consideration. Maintaining your current performance while seeking additional academic challenges can help you stand out even further among other high-achieving applicants.\n\nScholarship committees look for students who not only excel in standard coursework but also demonstrate intellectual curiosity and a willingness to push beyond requirements. By continuing your academic excellence while embracing new challenges, you\'ll strengthen your scholarship profile even further.';

      case 'leadership_rec':
        return 'Leadership experience is highly valued by scholarship committees as it demonstrates your ability to take initiative, work with others, and create positive change. Developing strong leadership skills and experiences can make your application stand out, even among academically strong candidates.\n\nMany major scholarships include leadership as a key selection criterion, looking beyond formal titles to assess your actual impact and growth. Building a portfolio of meaningful leadership experiences now will significantly strengthen your scholarship applications.';

      default:
        return 'This recommendation is designed to help you improve a key aspect of your scholarship profile. By following the suggested actions, you\'ll strengthen your applications and increase your chances of receiving scholarship funding.\n\nScholarship committees look for well-rounded candidates who demonstrate excellence across multiple dimensions. This recommendation addresses an area where targeted improvement could significantly enhance your overall competitiveness.';
    }
  }

  List<String> _getActionSteps(Recommendation recommendation) {
    // This would typically come from a database, but for now we'll use hardcoded steps
    switch (recommendation.id) {
      case 'academic_high':
        return [
          'Create a study schedule with dedicated time for each subject',
          'Meet with professors during office hours for subjects where you need improvement',
          'Form or join study groups for difficult courses',
          'Utilize campus academic support resources like tutoring centers',
          'Review past exams and assignments to identify patterns in areas for improvement',
          'Consider lightening your course load if it would help maintain higher grades',
        ];

      case 'academic_low':
        return [
          'Explore honors courses or advanced electives in your field',
          'Pursue undergraduate research opportunities with faculty',
          'Apply for academic competitions related to your major',
          'Consider presenting your work at student research conferences',
          'Mentor other students in subjects where you excel',
          'Document your academic achievements for inclusion in applications',
        ];

      case 'leadership_rec':
        return [
          'Identify organizations aligned with your interests and goals',
          'Start with committee or project team roles before pursuing executive positions',
          'Volunteer to lead specific projects or initiatives within groups you\'re already part of',
          'Develop a specific leadership skill each semester (public speaking, conflict resolution, etc.)',
          'Seek a mentor who has leadership experience in your field of interest',
          'Document both your leadership responsibilities and their impact',
        ];

      default:
        return [
          'Complete the recommended learning modules in this area',
          'Set specific, measurable goals for improvement in this category',
          'Create a timeline with milestones to track your progress',
          'Seek feedback from mentors, professors, or advisors',
          'Document your growth and achievements for scholarship applications',
        ];
    }
  }
}