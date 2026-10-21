import 'dart:math' show pow;

import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/Question.dart';
import 'package:flutterquiz/backend/QuizResults.dart';
import 'package:flutterquiz/widgets/Background.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:flutterquiz/widgets/QuestionReviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension Trimmer on double{
  
  double trim(int digits){
    num mod = pow(10, digits);
    return (this * mod).truncate() / mod;
  }
}

class ResultsScreen extends StatefulWidget {

  final String _quizName;
  final int _finalScore;
  final List<(String, Question)> _correctQuestions;
  final List<(String, Question)> _incorrectQuestions;

  ResultsScreen({
    super.key,
    required String quizName,
    required int finalScore,
    required List<(String, Question)> correctQuestions,
    required List<(String, Question)> incorrectQuestions,
  }) : _quizName = quizName,
       _finalScore = finalScore,
       _correctQuestions = correctQuestions,
       _incorrectQuestions = incorrectQuestions;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final GlobalKey<QuestionReviewerState> _reviewerKey = GlobalKey();

  bool isSaved = false;

  int get _totalQuestions => [...widget._correctQuestions, ...widget._incorrectQuestions].length;

  double get _correctPercent => (widget._correctQuestions.length/_totalQuestions);

  double get _incorrectPercent => (widget._incorrectQuestions.length/_totalQuestions);

  void _saveResults() async{
    //debugPrint('...saving results');

    final SharedPreferences prefs = await SharedPreferences.getInstance(); // get current user *username
    try{
      final username = prefs.getString('saved_username') ?? '';
      await saveQuizResult(QuizResult(
        username: username,
        quizName: widget._quizName,
        score: widget._finalScore,
        correct: widget._correctQuestions.length,
        incorrect: widget._incorrectQuestions.length,
        total: _totalQuestions,
        takenAt: DateTime.now(),
      ));
      _displaySubmitMessage(message: 'Results Saved', displayColor: Colors.green);
    }catch(e){
      _displaySubmitMessage(message: 'Error saving quiz $e');
    }
  }

  void _displaySubmitMessage({String message = '', Color displayColor = Colors.amberAccent}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.black)),
        duration: const Duration(seconds: 3),
        backgroundColor: displayColor,
      ),
    );
  }

  void _backToHomePage(BuildContext screenContext) {
    WidgetsBinding.instance.addPostFrameCallback((_)=>changeBackGround(bg: CustomBackgrounds.DEFAULT));
    Navigator.pop(screenContext);
  }

  @override
  Widget build(BuildContext context) {
    final screenContext = context;
    WidgetsBinding.instance.addPostFrameCallback((_){
      widget._finalScore < 70 ? changeBackGround(bg: CustomBackgrounds.FAILED) : changeBackGround(bg: CustomBackgrounds.PASSED);
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Results'),
        backgroundColor: const Color.fromARGB(139, 46, 45, 45),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder:(context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.save),
                        title: Text('Save Results'),
                        onTap: () {
                          if(!isSaved){
                            _saveResults();
                            isSaved = true;
                          }else{
                            _displaySubmitMessage(message: 'Quiz already saved');
                          }
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Return to home'),
                        onTap: () {
                          Navigator.pop(context);
                          _backToHomePage(screenContext);
                        },
                      ),
                    ],
                  )
                );
              },
            ), 
            icon: const Icon(Icons.more_vert),
            tooltip: 'Result Actions',
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(17),
        child: Container(
          margin: EdgeInsetsGeometry.all(20),
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(84, 0, 0, 0),
                    border: BoxBorder.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget._finalScore >= 70 ? 
                      Text('PASSED',style: TextStyle(color: const Color.fromARGB(255, 28, 242, 0),fontSize: 25,fontWeight: FontWeight.bold),):
                      Text('FAILED',style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.bold)),
                      Text('Quiz: ${widget._quizName}',style: TextStyle(color: Colors.white, fontSize: 18),),
                      Text('Score: ${widget._finalScore}%',style: TextStyle(color: Colors.white, fontSize: 18)),
                      Text('Total number of Questions: $_totalQuestions',style: TextStyle(color: Colors.white),),
                      Text('Correct Questions: ${widget._correctQuestions.length}',style: TextStyle(color: Colors.white)),
                      Text('Incorrect Questions: ${widget._incorrectQuestions.length}',style: TextStyle(color: Colors.white),)
                    ],
                  )
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(84, 0, 0, 0),
                    border: BoxBorder.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularPercentIndicator(
                        radius: 35,
                        lineWidth: 5,
                        percent: _correctPercent,
                        header: Text('CORRECT ANSWERS',style: TextStyle(color: Colors.white, fontSize: 12)),
                        center: Text('${(_correctPercent.trim(2)*100).toString()}%',style: TextStyle(color: Colors.white, fontSize: 14),),
                        animation: true,
                        animationDuration: 1000,
                        progressColor: Colors.lightGreenAccent,
                        backgroundColor: Colors.transparent,
                      ),
                      CircularPercentIndicator(
                        radius: 35,
                        lineWidth: 5,
                        percent: _incorrectPercent,
                        header: Text('INCORRECT ANSWERS',style: TextStyle(color: Colors.white, fontSize: 12)),
                        center: Text('${(_incorrectPercent.trim(2)*100).toString()}%',style: TextStyle(color: Colors.white, fontSize: 14),),
                        animation: true,
                        animationDuration: 1000,
                        progressColor: const Color.fromARGB(255, 247, 6, 2),
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
                QuestionReviewer(correctQuestions: widget._correctQuestions, incorrectQuestions: widget._incorrectQuestions)
              ],
            ),
          ),
        ), 
      ),
    );
  }
}