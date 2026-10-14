import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const new({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPage();
}

class _LoadingPage extends State<LoadingPage> {
  bool isDone  = false;

  @override
  void initState() {
    _fetchQuizzes();
    super.initState();
  }

  Future<void> _fetchQuizzes() async{
    
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.transparent,
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 20),
              Text(
                'Fetching Quizzes...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                )
              )
            ],
          ),
        )
    );
  }
}