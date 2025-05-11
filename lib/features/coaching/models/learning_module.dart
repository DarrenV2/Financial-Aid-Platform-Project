import 'package:financial_aid_project/features/coaching/models/question.dart';

class LearningModule {
  final String id;
  final String title;
  final String description;
  final String category;
  final int difficulty; // 1-5
  final List<LearningContent> contents;
  final List<Question> assessmentQuestions;

  LearningModule({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.contents,
    this.assessmentQuestions = const [],
  });
}

class LearningContent {
  final String id;
  final String title;
  final ContentType type;
  final String content;
  final int ordinalPosition;
  final List<String> tags;

  LearningContent({
    required this.id,
    required this.title,
    required this.type,
    required this.content,
    required this.ordinalPosition,
    this.tags = const [],
  });
}

enum ContentType {
  text,
  video,
  quiz,
  exercise,
  checklist,
}
