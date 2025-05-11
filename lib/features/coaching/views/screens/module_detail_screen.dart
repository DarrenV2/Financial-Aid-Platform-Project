import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/learning_module.dart';
import '../../controllers/learning_controller.dart';
import '../../models/question.dart';

class ModuleDetailScreen extends StatefulWidget {
  final LearningModule module;

  const ModuleDetailScreen({super.key, required this.module});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  late final LearningController learningController;
  late final RxDouble progress;
  late final RxBool isCompleted;
  late final RxInt currentContentIndex;

  // Map to store checkbox states for checklists
  final Map<String, Set<int>> checklistStates = {};

  // Variables to handle quiz state
  final RxMap<String, dynamic> quizAnswers = <String, dynamic>{}.obs;
  final RxBool quizSubmitted = false.obs;
  final RxInt quizScore = 0.obs;

  @override
  void initState() {
    super.initState();
    learningController = Get.find<LearningController>();

    // Initialize progress from controller's cached data first
    progress = (learningController.moduleProgress[widget.module.id] ?? 0.0).obs;
    isCompleted =
        learningController.completedModules.contains(widget.module.id).obs;
    currentContentIndex = 0.obs;

    // Use post-frame callback to refresh from Firestore after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshFromFirestore();
    });
  }

  // Helper method to refresh progress data from Firestore
  Future<void> _refreshFromFirestore() async {
    await learningController.refreshProgressFromFirestore();

    // Update local Rx variables with the latest data from the controller
    progress.value = learningController.moduleProgress[widget.module.id] ?? 0.0;
    isCompleted.value =
        learningController.completedModules.contains(widget.module.id);
  }

  // Helper method to manage checklist item toggling
  void toggleChecklistItem(String contentId, int itemIndex, bool? checked) {
    if (!checklistStates.containsKey(contentId)) {
      checklistStates[contentId] = {};
    }

    setState(() {
      if (checked == true) {
        checklistStates[contentId]!.add(itemIndex);
      } else {
        checklistStates[contentId]!.remove(itemIndex);
      }
    });
  }

  // Helper method to check if a checklist item is checked
  bool isChecklistItemChecked(String contentId, int itemIndex) {
    return checklistStates.containsKey(contentId) &&
        checklistStates[contentId]!.contains(itemIndex);
  }

  // Helper method to save quiz answer
  void saveQuizAnswer(String questionId, dynamic value) {
    quizAnswers[questionId] = value;
  }

  // Helper method to evaluate quiz results
  void evaluateQuiz(List<Question> questions) {
    int correctAnswers = 0;

    for (var question in questions) {
      if (quizAnswers.containsKey(question.id)) {
        // For this simple implementation, assuming the first option is always correct
        if (question.options.isNotEmpty &&
            quizAnswers[question.id] == question.options[0].value) {
          correctAnswers++;
        }
      }
    }

    quizScore.value = correctAnswers;
    quizSubmitted.value = true;

    // Mark module as completed if quiz is submitted
    if (widget.module.title.contains("Academic Performance")) {
      _completeModule();
    }
  }

  // Helper method to complete the module
  Future<void> _completeModule() async {
    await learningController.updateModuleProgress(widget.module.id, 100.0);
    progress.value = 100.0;
    isCompleted.value = true;

    if (mounted) {
      _showCompletionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module.title),
        elevation: 0,
        actions: [
          // Add refresh button to manually sync with Firestore
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh progress data',
            onPressed: () async {
              await _refreshFromFirestore();
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
      body: Column(
        children: [
          // Progress indicator
          Obx(() => LinearProgressIndicator(
                value: progress.value / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted.value
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                ),
                minHeight: 8,
              )),

          // Module content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Module header
                  _buildModuleHeader(context, widget.module),

                  const SizedBox(height: 16),

                  // Content navigation
                  _buildContentNavigation(
                      context, widget.module, currentContentIndex),

                  const SizedBox(height: 16),

                  // Current content
                  Expanded(
                    child: Obx(() {
                      if (currentContentIndex.value < 0 ||
                          currentContentIndex.value >=
                              widget.module.contents.length) {
                        return const Center(
                            child: Text('No content available'));
                      }

                      final currentContent =
                          widget.module.contents[currentContentIndex.value];
                      return _buildContent(
                        context,
                        currentContent,
                        currentContentIndex.value,
                        widget.module.contents.length,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          // Bottom action buttons
          Obx(() => Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Previous button
                    if (currentContentIndex.value > 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            currentContentIndex.value--;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                          ),
                          child: const Text('Previous'),
                        ),
                      ),

                    if (currentContentIndex.value > 0 &&
                        currentContentIndex.value <
                            widget.module.contents.length - 1)
                      const SizedBox(width: 16),

                    // Next/Complete button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (currentContentIndex.value <
                              widget.module.contents.length - 1) {
                            // Go to next content
                            currentContentIndex.value++;

                            // Update progress
                            double newProgress =
                                ((currentContentIndex.value + 1) /
                                        widget.module.contents.length) *
                                    100;
                            await learningController.updateModuleProgress(
                                widget.module.id, newProgress);
                            progress.value = newProgress;
                          } else {
                            // Don't auto-complete modules with a quiz
                            final hasQuiz = widget.module.contents.any(
                                (content) => content.type == ContentType.quiz);

                            if (!hasQuiz) {
                              await _completeModule();
                            } else if (quizSubmitted.value &&
                                widget.module.title
                                    .contains("Academic Performance")) {
                              await _completeModule();
                            } else {
                              // Prompt to complete the quiz first
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please complete the quiz to finish this module'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          currentContentIndex.value <
                                  widget.module.contents.length - 1
                              ? 'Next'
                              : isCompleted.value
                                  ? 'Completed'
                                  : 'Complete Module',
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildModuleHeader(BuildContext context, LearningModule module) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCategoryName(module.category),
                    style: TextStyle(
                      fontSize: 14,
                      color: _getCategoryColor(module.category),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            _buildDifficultyIndicator(module.difficulty),
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
      ],
    );
  }

  Widget _buildContentNavigation(
    BuildContext context,
    LearningModule module,
    RxInt currentContentIndex,
  ) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: module.contents.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              currentContentIndex.value = index;
            },
            child: Obx(() => Container(
                  width: 60,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: currentContentIndex.value == index
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: currentContentIndex.value == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: currentContentIndex.value == index
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    LearningContent content,
    int currentIndex,
    int totalCount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Content header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              content.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${currentIndex + 1} of $totalCount',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Content type indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getContentTypeColor(content.type).withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _formatContentType(content.type),
            style: TextStyle(
              fontSize: 12,
              color: _getContentTypeColor(content.type),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Content based on type
        Expanded(
          child: _buildContentByType(context, content),
        ),
      ],
    );
  }

  Widget _buildContentByType(BuildContext context, LearningContent content) {
    switch (content.type) {
      case ContentType.text:
        // Enhanced text content with better formatting and styling
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _formatTextContent(content.content),
            ),
          ),
        );

      case ContentType.video:
        // In a real app, this would be a video player widget
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_fill,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                const Text('Video content would play here'),
                const SizedBox(height: 8),
                Text(
                  content.content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );

      case ContentType.quiz:
        return _buildQuizContent(context, content);

      case ContentType.exercise:
        return Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.fitness_center, color: Colors.purple),
                      SizedBox(width: 8),
                      Text(
                        'Exercise',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );

      case ContentType.checklist:
        // Parse checklist items from content
        final items = content.content
            .split('\n')
            .where((item) => item.trim().isNotEmpty)
            .toList();

        return Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.checklist, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Checklist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(items[index]),
                        value: isChecklistItemChecked(content.id, index),
                        onChanged: (value) {
                          toggleChecklistItem(content.id, index, value);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
    }

    // Handle any unexpected content types (this code should never execute if all enum cases are handled)
    return Center(
      child: Text(
        'Unsupported content type: ${content.type}',
        style: TextStyle(color: Colors.grey[700]),
      ),
    );
  }

  // Enhanced text formatting method
  List<Widget> _formatTextContent(String content) {
    final paragraphs = content.split('\n\n');
    List<Widget> formattedContent = [];

    for (var paragraph in paragraphs) {
      // Handling headings (lines starting with #)
      if (paragraph.startsWith('# ')) {
        formattedContent.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              paragraph.substring(2),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      }
      // Handling subheadings (lines starting with ##)
      else if (paragraph.startsWith('## ')) {
        formattedContent.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(
              paragraph.substring(3),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
        );
      }
      // Handle bullet points
      else if (paragraph.startsWith('* ')) {
        final bulletPoints = paragraph
            .split('\n')
            .where((line) => line.startsWith('* '))
            .toList();
        List<Widget> bulletWidgets = [];

        for (var bullet in bulletPoints) {
          bulletWidgets.add(
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bullet.substring(2),
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        formattedContent.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bulletWidgets,
            ),
          ),
        );
      }
      // Regular paragraphs
      else {
        formattedContent.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              paragraph,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        );
      }
    }

    return formattedContent;
  }

  // Build the quiz content
  Widget _buildQuizContent(BuildContext context, LearningContent content) {
    // For this example, we'll create a simple quiz based on the module's assessment questions
    final questions = widget.module.assessmentQuestions;

    if (questions.isEmpty) {
      // Fallback for modules without assessment questions
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.quiz,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quiz Questions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content.content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Obx(() {
      // If quiz is already submitted, show results
      if (quizSubmitted.value) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 60,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Quiz Completed!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Score: ${quizScore.value}/${questions.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Great job! You\'ve completed this module\'s quiz.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Otherwise show the quiz questions
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.quiz, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Quiz: ${content.title}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...questions
                    .map((question) => _buildQuizQuestion(context, question))
                    .toList(),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      evaluateQuiz(questions);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Submit Quiz'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Build a single quiz question
  Widget _buildQuizQuestion(BuildContext context, Question question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...question.options
              .map((option) => RadioListTile<dynamic>(
                    title: Text(option.text),
                    value: option.value,
                    groupValue: quizAnswers[question.id],
                    onChanged: (value) {
                      saveQuizAnswer(question.id, value);
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ))
              .toList(),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Module Completed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Congratulations on completing this module! Your learning progress has been updated.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Continue'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Get.back(); // Return to learning plan
              },
              child: const Text('Back to Learning Plan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDifficultyIndicator(int difficulty) {
    final Color color = difficulty <= 2
        ? Colors.green
        : difficulty <= 4
            ? Colors.orange
            : Colors.red;

    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < difficulty ? Icons.star : Icons.star_border,
          color: index < difficulty ? color : Colors.grey[400],
          size: 18,
        );
      }),
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
        return Colors.grey; // Default fallback color
    }
  }

  String _formatContentType(ContentType type) {
    switch (type) {
      case ContentType.text:
        return 'Reading';
      case ContentType.video:
        return 'Video';
      case ContentType.quiz:
        return 'Quiz';
      case ContentType.exercise:
        return 'Exercise';
      case ContentType.checklist:
        return 'Checklist';
    }
  }

  Color _getContentTypeColor(ContentType type) {
    switch (type) {
      case ContentType.text:
        return Colors.blue;
      case ContentType.video:
        return Colors.red;
      case ContentType.quiz:
        return Colors.orange;
      case ContentType.exercise:
        return Colors.purple;
      case ContentType.checklist:
        return Colors.green;
    }
  }
}
