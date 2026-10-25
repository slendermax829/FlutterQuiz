import 'package:flutterquiz/backend/Question.dart';

/// Represents a quiz and the questions it contains.
class Quiz {
  static final List<Quiz> _quizCache = <Quiz>[];

  final String _name;
  final List<Question> _questions;

  /// The quiz's display name.
  String get name => _name;

  /// The quiz number parsed from the second word of its name.
  int get quizNo => int.parse(_name.split(' ')[1]);

  /// The questions in this quiz.
  List<Question> get questions => _questions;

  /// A shuffled copy of this quiz's questions.
  List<Question> get randQuestions => List.from(_questions)..shuffle();
  
  /// The number of questions in this quiz.
  int get numQuestions => _questions.length;
  
  /// Creates a quiz from its name and questions.
  const Quiz.internal(this._name, this._questions);

  /// Creates a quiz from JSON data, reusing a cached quiz with the same name.
  ///
  /// The data must include a `questions` list whose entries can be parsed by
  /// [Question.fromData]. The quiz name defaults to an empty string if omitted.
  factory Quiz.fromJson(Map<String, dynamic> data) {
    final String name = data['name'] as String? ?? '';

    for (final Quiz quiz in _quizCache) {
      if (quiz._name == name) {
        return quiz;
      }
    }

    final List<Question> questions = (data['questions'] as List).map((e) => Question.fromData(e as Map<String, dynamic>)).toList();

    final Quiz newQuiz = Quiz.internal(name, questions);
    _quizCache.add(newQuiz);

    return newQuiz;
  }
}