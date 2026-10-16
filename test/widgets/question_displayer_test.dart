import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterquiz/backend/Question.dart';
import 'package:flutterquiz/widgets/QuestionDisplayer.dart';

void main() {
  testWidgets('question navigation fits a narrow screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final questions = List<Question>.generate(
      20,
      (index) => FillInBlank('Question ${index + 1}', ['answer']),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: QuestionDisplayer(questions: questions)),
      ),
    );

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('forward and back buttons change the displayed question', (
    WidgetTester tester,
  ) async {
    final questions = <Question>[
      FillInBlank('Question 1', ['answer']),
      FillInBlank('Question 2', ['answer']),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: QuestionDisplayer(questions: questions)),
      ),
    );

    expect(find.text('Question 1 of 2'), findsOneWidget);
    expect(find.text('Question 1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    expect(find.text('Question 2 of 2'), findsOneWidget);
    expect(find.text('Question 2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Question 1 of 2'), findsOneWidget);
    expect(find.text('Question 1'), findsOneWidget);
  });
}
