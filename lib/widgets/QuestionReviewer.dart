import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/Question.dart';

class QuestionReviewer extends StatefulWidget {
  final List<Question> _correctQuestions;
  final List<Question> _incorrectQuestions;

  const new({
    super.key,
    required List<Question> correctQuestions,
    required List<Question> incorrectQuestions
  }) : this._correctQuestions = correctQuestions,
       this._incorrectQuestions = incorrectQuestions;

  @override
  State<QuestionReviewer> createState() => _QuestionReviewerState();
}

class _QuestionReviewerState extends State<QuestionReviewer> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}