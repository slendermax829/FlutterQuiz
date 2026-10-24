import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutterquiz/backend/Quiz.dart';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

const String _quizUrl = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/';
const String _loginUrl = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/login.php';

class QuizServerException implements Exception{
    final String message;
    final int statusCode;
    final String url;

    const QuizServerException({
      required this.message,
      required this.statusCode,
      required this.url
    });

    void quizLog(){
      dev.log(
        this.toString(),
        name: 'httpError',
        level: 100,
        error: bool
      );
    }

    @override
    String toString() => 'QuizServerException($statusCode) at $url: $message';
}

Future<bool> validateQuizUrl() async{
  try{
    var url = Uri.parse(_quizUrl);
    var response = await http.get(url);

    return response.statusCode == 200;

  }on QuizServerException catch(e){
    e.quizLog();
    return false;
  }
}

Future<bool> validateLoginUrl() async{
  var url = Uri.parse(_loginUrl);
  var response = await http.get(url);

  return response.statusCode == 200;
}

Future<({bool response,String reason})> validateQuiz(int quizNum) async{
  try{
    var number = quizNum.toString().padLeft(2,'0');
    var url = Uri.parse('$_quizUrl?quiz=quiz$number');
    var response = await http.get(url);

    var jsonData = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as Map<String,dynamic>;

    return (
      response: (jsonData['response'] as bool?) ?? false,
      reason: (jsonData['reason'] as String?) ?? 'Quiz $quizNum Found'
    );
    
  }on QuizServerException catch(e){
    return (response: false, reason: 'An Error had occurred');
  }
}

Future<List<Quiz>> fetchQuizzes() async{
  final quizzes = <Quiz>[];

  for(var quizNum = 1; ; quizNum++){
    final quiz = await _fetchQuiz(quizNum);
    if(quiz == null){
      break;
    }
    quizzes.add(quiz);
  }

  return quizzes;
}

// Returns null once the server reports the quiz does not exist.
Future<Quiz?> _fetchQuiz(int quizNum) async{
  final number = quizNum.toString().padLeft(2,'0');
  final url = Uri.parse('$_quizUrl?quiz=quiz$number');
  final response = await http.get(url);

  final jsonData = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as Map<String, dynamic>;

  if(jsonData['response'] != true){
    return null;
  }
  return Quiz.fromJson(jsonData['quiz'] as Map<String, dynamic>);
}

Future<({bool response, String reason})> validateUser({required String username, required int pin}) async{
  try{
    var url = Uri.parse('$_loginUrl?user=$username&pin=$pin');
    var response = await http.get(url).timeout(const Duration(seconds: 10));

    var jsonData = jsonDecode(response.body);

    return (
      response: (jsonData['response'] as bool?) ?? false,
      reason: (jsonData['reason'] as String?) ?? 'User Found'
    );
  }on QuizServerException catch(e){
    return (response: false, reason: 'An Error had occurred');
  }on TimeoutException{
    return (response: false, reason: 'The server took too long to respond');
  }on SocketException{
    return (response: false, reason: 'Unable to reach the server');
  }on http.ClientException{
    return (response: false, reason: 'Unable to reach the server');
  }on FormatException{
    return (response: false, reason: 'Unexpected response from the server');
  }
}