import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'finds appBar',
    (WidgetTester tester) async {
      // Write your test here

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(),
          ),
        ),
      );
    },
  );

  testWidgets('finds a Text widget written South Africa',
      (WidgetTester tester) async {
    // Build an App with a Text widget that displays the letter 'South Africa'.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('South Africa'),
      ),
    ));

    // Find a widget that displays the letter 'South Africa'.
    expect(find.text('South Africa'), findsOneWidget);
  });

  testWidgets('finds a Text widget written Johannesburg',
      (WidgetTester tester) async {
    // Build an App with a Text widget that displays the letter 'Johannesburg'.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('Johannesburg'),
      ),
    ));

    // Find a widget that displays the letter 'Johannesburg'.
    expect(find.text('Johannesburg'), findsOneWidget);
  });

  testWidgets('finds a Container with padding EdgeInsets',
      (WidgetTester tester) async {
    const childWidget = Padding(padding: EdgeInsets.only());

    // Provide the childWidget to the Container.
    await tester.pumpWidget(Container(child: childWidget));

    // Search for the childWidget in the tree and verify it exists.
    expect(find.byWidget(childWidget), findsOneWidget);
  });

  testWidgets('finds a widget with a dropdown icon',
      (WidgetTester tester) async {
    const Icon(Icons.arrow_drop_down_rounded);

    // Build an App with a widget that has the drop down search icon.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Icon(Icons.arrow_drop_down_rounded),
      ),
    ));

    // Search for the childWidget in the tree and verify it exists.
    expect(find.byIcon(Icons.arrow_drop_down_rounded), findsOneWidget);
  });

  testWidgets('finds a widget with a search icon', (WidgetTester tester) async {
    const Icon(Icons.search);

    // Build an App with a widget that has the drop down search icon.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Icon(Icons.search),
      ),
    ));

    // Search for the childWidget in the tree and verify it exists.
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
