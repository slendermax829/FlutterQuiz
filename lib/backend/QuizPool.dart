
import 'package:flutterquiz/backend/Question.dart';
import 'package:flutterquiz/backend/Quiz.dart';
import 'package:flutterquiz/backend/QuizService.dart' as qs;
import 'dart:math' as math;

List<Quiz> _quizzes = [];

List<Quiz> get quizzes => _quizzes;

int get numOfQuizzes => _quizzes.length;
int get numOfQuestions => _quizzes.fold(0, (sum,q)=> sum += q.numQuestions);

int get numMCQuestions{
  return _quizzes.fold(0, (sum,q){
    var questions = q.questions;
    for(var qu in questions){
      if(qu.type == 'multiple choice'){
        sum += 1;
      }else{
        continue;
      }
    }
    return sum;
  });
}

int get numFIBQuestions{
  return _quizzes.fold(0, (sum,q){
    var questions = q.questions;
    for(var qu in questions){
      if(qu.type == 'fill in the blank'){
        sum += 1;
      }else{
        continue;
      }
    }
    return sum;
  });
}

Future<void> populatePool() async{
  _quizzes = await qs.fetchQuizzes();
}

Future<void> repopulate() async{
  _quizzes = [];
  await populatePool();
}

List<Question> getQuestionsFromQuiz(int quizNum){
  var selectedQuiz = _quizzes.firstWhere((q)=> q.quizNo == quizNum);
  return selectedQuiz.questions;
}

/// Picks up to [count] distinct random questions from the whole pool.
/// [type] optionally restricts the pool to 'multiple choice' or 'fill in the blank'.
/// Returns fewer than [count] questions if the pool is smaller.
List<Question> getRandomQuestions(int count, {String? type}){
  if(count <= 0){
    return [];
  }

  var candidates = [
    for(var quiz in _quizzes)
      for(var question in quiz.questions)
        if(type == null || question.type == type) question,
  ];

  candidates.shuffle(math.Random());
  
  return candidates.take(count).toList();
}
