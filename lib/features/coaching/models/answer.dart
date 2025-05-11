class Answer {
  final String questionId;
  final dynamic value;
  final DateTime timestamp;

  Answer({
    required this.questionId,
    required this.value,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}