import 'package:flutter_test/flutter_test.dart';
import 'package:flutterquiz/backend/QuizService.dart' as qs;

void main(){
  test('Validate quizUrl', () async {
    var response = await qs.validateQuizUrl();
    
    expect(response, true, reason: "url for quizzes is not valid");
  });

  test('Validate loginUrl', () async{
    var response = await qs.validateLoginUrl();

    expect(response, true, reason: "url for login is not valid");
  });

  test('Validate quiz', () async{
    var q1 = await qs.validateQuiz(1);
    var q2 = await qs.validateQuiz(100); // no Quiz 100

    expect(q1.response, true, reason: q1.reason);
    expect(q2.response, false, reason: 'QuizNo 100 does not exist.');
  });

  test('Validate Login User', () async{
    var u1 = await qs.validateUser(username: 'mdpacheco', pin: 1354);
    var u2 = await qs.validateUser(username: 'Kenny', pin: 1999);

    expect(u1.response, true, reason: u1.reason);
    expect(u2.response, false, reason: 'User 2 \'Kenny\', does not exist.');
  });
}