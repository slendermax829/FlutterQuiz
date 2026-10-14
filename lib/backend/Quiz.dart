import 'package:flutterquiz/backend/Question.dart';

class Quiz {
  static final List<Quiz> _quizCache = <Quiz>[];

  final String _name;
  final List<Question> _questions;

  String get name => _name;
  int get quizNo => int.parse(_name.split(' ')[1]);

  List<Question> get questions => _questions;
  List<Question> get randQuestions => List.from(_questions)..shuffle();
  int get numQuestions => _questions.length;
  
  const Quiz.internal(this._name, this._questions);

  factory Quiz.fromJson(Map<String, dynamic> data) {
    final String name = data['name'] as String? ?? '';

    for (final Quiz quiz in _quizCache) {
      if (quiz._name == name) {
        return quiz;
      }
    }

    var dataQuestions = data['questions'];

    List<Question> questions = dataQuestions.map((e) {
      return Question.fromData(data[e]);
    });

    final Quiz newQuiz = Quiz.internal(name, questions);
    _quizCache.add(newQuiz);

    return newQuiz;
  }
}