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
