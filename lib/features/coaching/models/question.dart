class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<Option> options;
  final bool required;
  final String? category; // financial, academic, personal, etc.
  final String? description;

  Question({
    required this.id,
    required this.text,
    required this.type,
    this.options = const [],
    this.required = true,
    this.category,
    this.description,
  });
}

enum QuestionType {
  text,
  number,
  boolean,
  singleChoice,
  multipleChoice,
  dropdown,
  slider,
  date,
}

class Option {
  final String id;
  final String text;
  final dynamic value;

  Option({
    required this.id,
    required this.text,
    required this.value,
  });
}