import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutterquiz/backend/Quiz.dart';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

const String _quizUrl = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/';
const String _loginUrl = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/login.php';
const String _pictureUrl = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/figure.php?name=';

/// Checks whether the quiz endpoint is reachable and returns a success status.
Future<bool> validateQuizUrl() async{
  try{
    var url = Uri.parse(_quizUrl);
    var response = await http.get(url);

    return response.statusCode == 200;

  }catch(e){
    return false;
  }
}

/// Checks whether the login endpoint is reachable and returns a success status.
Future<bool> validateLoginUrl() async{
  var url = Uri.parse(_loginUrl);
  var response = await http.get(url);

  return response.statusCode == 200;
}

/// Checks whether the server recognizes the quiz identified by [quizNum].
///
/// The returned record contains the server's response flag and reason.
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
    
  }catch(e){
    throw('An Error had Occurred: $e');
  }
}

/// Fetches quizzes sequentially until the server reports one is unavailable.
Future<List<Quiz>> fetchQuizzes() async{
  final quizzes = <Quiz>[];

  for(var quizNum = 1; quizNum <= 99 ; quizNum++){
    final quiz = await _fetchQuiz(quizNum);
    if(quiz == null){
      //break;
      continue;
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

/// Validates the credentials for [username] and [pin].
///
/// Returns the server's response flag and reason. Network and timeout failures
/// are returned as unsuccessful results with an explanatory reason.
Future<({bool response, String reason})> validateUser({required String username, required int pin}) async{
  try{
    var url = Uri.parse('$_loginUrl?user=$username&pin=$pin');
    var response = await http.get(url).timeout(const Duration(seconds: 10));

    var jsonData = jsonDecode(response.body);

    return (
      response: (jsonData['response'] as bool?) ?? false,
      reason: (jsonData['reason'] as String?) ?? 'User Found'
    );
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

/// Fetches an Image from web service provided by using the web service picture url 
Future<http.Response> fetchImage(String figure) async{
  try{
    var url = Uri.parse('$_pictureUrl$figure');
    var response =  await http.get(url);

    return response;
  }catch(e){
    throw('An Error had Occurred trying to retrieve image: $e');
  }
}