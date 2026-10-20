import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterquiz/widgets/RandQuiz.dart';

void main() {
  testWidgets('selecting a quiz type does not throw', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RandQuiz())),
    );

    await tester.tap(find.text('Multiple Choice only'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(Slider), findsNothing);
  });

  testWidgets('tapping Take Quiz validates the form without throwing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RandQuiz())),
    );

    final state = tester.state<State<RandQuiz>>(find.byType(RandQuiz));
    expect(state, isNotNull);
    expect(find.byType(Form), findsOneWidget);
    expect(Form.of(tester.element(find.byType(TextFormField))).validate(),
        isFalse);
    expect(tester.takeException(), isNull);
  });
}
