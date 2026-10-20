import 'package:flutterquiz/backend/Question.dart';
import 'dart:io';
import 'dart:convert';

final _resultsFile = File('flutterquiz/results.json');
const  Map<String,dynamic> _userResults = {};

class QuizResult{
  final String _user;
  final DateTime _date;

  final String _quizName;

  final int _finalScore;
  final List<Question> _correctQuestions;
  final List<Question> _incorrectQuestions;

  Map<String, dynamic> toJson(){
    return{
      'user': _user,
      'quiz name': _quizName,
      'final score': _finalScore,
      'correct questions': _correctQuestions,
      'incorrect questions': _incorrectQuestions,
      'date': _date.toString()
    };
  }

  QuizResult(
    this._user,
    this._quizName,
    this._finalScore,
    this._correctQuestions,
    this._incorrectQuestions
  ): _date = DateTime.now();

}

Future<bool> get _checkFile async => await _resultsFile.exists();

void _createJsonFile() async{
  try{
    await _resultsFile.create(recursive: true);
    print('File ready at ${_resultsFile.path}');
  }catch(e){
    print('An error occured: $e');
  }
}

void writeToJsonFile(QuizResult result) async{

  try{
    if(!(await _checkFile)){
      return;
    }

    const encoder = JsonEncoder.withIndent('  ');

  }catch(e){

  }

}