import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/main.dart';

void main() {
testWidgets('finds a specific instance', (WidgetTester tester) async {
  const childWidget = Padding(padding: EdgeInsets.only());

  // Provide the childWidget to the Container.
  await tester.pumpWidget(Container(child: childWidget));

  // Search for the childWidget in the tree and verify it exists.
  expect(find.byWidget(childWidget), findsOneWidget);
});
}
