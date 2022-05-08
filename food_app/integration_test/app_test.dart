import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

testWidgets('finds a Text widget', (WidgetTester tester) async {
  // Build an App with a Text widget that displays the letter 'H'.
  await tester.pumpWidget(const MaterialApp(
    home: Scaffold(
      body: Text('South Africa'),
    ),
  ));

  // Find a widget that displays the letter 'H'.
  expect(find.text('South Africa'), findsOneWidget);
});

  testWidgets('finds a child widget', (WidgetTester tester) async {
    const childWidget = Padding(padding: EdgeInsets.only());

    // Provide the childWidget to the Container.
    await tester.pumpWidget(Container(child: childWidget));

    // Search for the childWidget in the tree and verify it exists.
    expect(find.byWidget(childWidget), findsOneWidget);
  });



}

