// Question Model
class Questionmodel {
  String type;
  String difficulty;
  String category;
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

  Questionmodel({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory Questionmodel.fromJson(Map<String, dynamic> json) {
    return Questionmodel(
      type: json['type'] ?? '',
      difficulty: json['difficulty'] ?? '',
      category: json['category'] ?? '',
      question: json['question'] ?? '',
      correctAnswer: json['correct_answer'] ?? '',
      incorrectAnswers: List<String>.from(json['incorrect_answers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'difficulty': difficulty,
      'category': category,
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
    };
  }
}