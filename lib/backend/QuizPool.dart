
import 'package:flutterquiz/backend/Question.dart';
import 'package:flutterquiz/backend/Quiz.dart';
import 'package:flutterquiz/backend/QuizService.dart' as qs;
import 'dart:math' as math;

List<Quiz> _quizzes = [];

/// The quizzes currently loaded into the pool.
List<Quiz> get quizzes => _quizzes;

/// The total number of quizzes in the pool.
int get numOfQuizzes => _quizzes.length;

/// The total number of questions across all quizzes in the pool.
int get numOfQuestions => _quizzes.fold(0, (sum,q)=> sum += q.numQuestions);

/// The number of multiple-choice questions in the pool.
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

/// The number of fill-in-the-blank questions in the pool.
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

/// Fetches quizzes from the quiz service and replaces the current pool.
Future<void> populatePool() async{
  _quizzes = await qs.fetchQuizzes();
}

/// Clears the pool and fetches the quizzes again.
Future<void> repopulate() async{
  _quizzes = [];
  await populatePool();
}

/// Returns the questions in the quiz identified by [quizNum].
List<Question> getQuestionsFromQuiz(int quizNum){
  var selectedQuiz = _quizzes.firstWhere((q)=> q.quizNo == quizNum);
  return selectedQuiz.questions;
}

/// Picks up to [count] random questions from the whole pool.
///
/// If [type] is provided, limits results to that question type (`multiple
/// choice` or `fill in the blank`). Otherwise `any`. 
/// Returns fewer than [count] questions when
/// fewer matching questions are available.
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
