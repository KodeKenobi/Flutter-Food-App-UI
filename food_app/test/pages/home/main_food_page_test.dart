import 'package:flutter/cupertino.dart';
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

  testWidgets('test iOS page transition (LTR)', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) {
              final String pageNumber = settings.name == '/' ? '1' : '2';
              return Center(child: Text('Page $pageNumber'));
            },
          );
        },
      ),
    );
    final Offset widget1InitialTopLeft = tester.getTopLeft(find.text('Page 1'));
    tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/next');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    Offset widget1TransientTopLeft = tester.getTopLeft(find.text('Page 1'));
    Offset widget2TopLeft = tester.getTopLeft(find.text('Page 2'));
    // Page 1 is moving to the left.
    expect(widget1TransientTopLeft.dx, lessThan(widget1InitialTopLeft.dx));
    // Page 1 isn't moving vertically.
    expect(widget1TransientTopLeft.dy, equals(widget1InitialTopLeft.dy));
    // iOS transition is horizontal only.
    expect(widget1InitialTopLeft.dy, equals(widget2TopLeft.dy));
    // Page 2 is coming in from the right.
    expect(widget2TopLeft.dx, greaterThan(widget1InitialTopLeft.dx));
    // Will need to be changed if the animation curve or duration changes.
    expect(widget1TransientTopLeft.dx, closeTo(130, 1.0));
    await tester.pumpAndSettle();
    // Page 2 covers page 1.
    expect(find.text('Page 1'), findsNothing);
    expect(find.text('Page 2'), isOnstage);
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    widget1TransientTopLeft = tester.getTopLeft(find.text('Page 1'));
    widget2TopLeft = tester.getTopLeft(find.text('Page 2'));
    // Page 1 is coming back from the left.
    expect(widget1TransientTopLeft.dx, lessThan(widget1InitialTopLeft.dx));
    // Page 1 isn't moving vertically.
    expect(widget1TransientTopLeft.dy, equals(widget1InitialTopLeft.dy));
    // iOS transition is horizontal only.
    expect(widget1InitialTopLeft.dy, equals(widget2TopLeft.dy));
    // Page 2 is leaving towards the right.
    expect(widget2TopLeft.dx, greaterThan(widget1InitialTopLeft.dx));
    // Will need to be changed if the animation curve or duration changes.
    expect(widget1TransientTopLeft.dx, closeTo(249, 1.0));
    await tester.pumpAndSettle();
    expect(find.text('Page 1'), isOnstage);
    expect(find.text('Page 2'), findsNothing);
    widget1TransientTopLeft = tester.getTopLeft(find.text('Page 1'));
    // Page 1 is back where it started.
    expect(widget1InitialTopLeft, equals(widget1TransientTopLeft));
  });
  testWidgets('test iOS page transition (RTL)', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          RtlOverrideWidgetsDelegate(),
        ],
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) {
              final String pageNumber = settings.name == '/' ? '1' : '2';
              return Center(child: Text('Page $pageNumber'));
            },
          );
        },
      ),
    );
    await tester
        .pump(); // to load the localization, since it doesn't use a synchronous future
    final Offset widget1InitialTopLeft = tester.getTopLeft(find.text('Page 1'));
    tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/next');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    Offset widget1TransientTopLeft = tester.getTopLeft(find.text('Page 1'));
    Offset widget2TopLeft = tester.getTopLeft(find.text('Page 2'));
    // Page 1 is moving to the right.
    expect(widget1TransientTopLeft.dx, greaterThan(widget1InitialTopLeft.dx));
    // Page 1 isn't moving vertically.
    expect(widget1TransientTopLeft.dy, equals(widget1InitialTopLeft.dy));
    // iOS transition is horizontal only.
    expect(widget1InitialTopLeft.dy, equals(widget2TopLeft.dy));
    // Page 2 is coming in from the left.
    expect(widget2TopLeft.dx, lessThan(widget1InitialTopLeft.dx));
    await tester.pumpAndSettle();
    // Page 2 covers page 1.
    expect(find.text('Page 1'), findsNothing);
    expect(find.text('Page 2'), isOnstage);
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    widget1TransientTopLeft = tester.getTopLeft(find.text('Page 1'));
    widget2TopLeft = tester.getTopLeft(find.text('Page 2'));
    // Page 1 is coming back from the right.
    expect(widget1TransientTopLeft.dx, greaterThan(widget1InitialTopLeft.dx));
    // Page 1 isn't moving vertically.
    expect(widget1TransientTopLeft.dy, equals(widget1InitialTopLeft.dy));
    // iOS transition is horizontal only.
    expect(widget1InitialTopLeft.dy, equals(widget2TopLeft.dy));
    // Page 2 is leaving towards the left.
    expect(widget2TopLeft.dx, lessThan(widget1InitialTopLeft.dx));
    await tester.pumpAndSettle();
    expect(find.text('Page 1'), isOnstage);
    expect(find.text('Page 2'), findsNothing);
    widget1TransientTopLeft = tester.getTopLeft(find.text('Page 1'));
    // Page 1 is back where it started.
    expect(widget1InitialTopLeft, equals(widget1TransientTopLeft));
  });
  testWidgets('test iOS fullscreen dialog transition',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const CupertinoApp(
        home: Center(child: Text('Page 1')),
      ),
    );
    final Offset widget1InitialTopLeft = tester.getTopLeft(find.text('Page 1'));
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(CupertinoPageRoute<void>(
          builder: (BuildContext context) {
            return const Center(child: Text('Page 2'));
          },
          fullscreenDialog: true,
        ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    Offset widget1TransientTopLeft = tester.getTopLeft(find.text('Page 1'));
    Offset widget2TopLeft = tester.getTopLeft(find.text('Page 2'));
    // Page 1 doesn't move.
    expect(widget1TransientTopLeft, equals(widget1InitialTopLeft));
    // Fullscreen dialogs transitions vertically only.
    expect(widget1InitialTopLeft.dx, equals(widget2TopLeft.dx));
    // Page 2 is coming in from the bottom.
    expect(widget2TopLeft.dy, greaterThan(widget1InitialTopLeft.dy));
    await tester.pumpAndSettle();
    // Page 2 covers page 1.
    expect(find.text('Page 1'), findsNothing);
    expect(find.text('Page 2'), isOnstage);
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    widget1TransientTopLeft = tester.getTopLeft(find.text('Page 1'));
    widget2TopLeft = tester.getTopLeft(find.text('Page 2'));
    // Page 1 doesn't move.
    expect(widget1TransientTopLeft, equals(widget1InitialTopLeft));
    // Fullscreen dialogs transitions vertically only.
    expect(widget1InitialTopLeft.dx, equals(widget2TopLeft.dx));
    // Page 2 is leaving towards the bottom.
    expect(widget2TopLeft.dy, greaterThan(widget1InitialTopLeft.dy));
    await tester.pumpAndSettle();
    expect(find.text('Page 1'), isOnstage);
    expect(find.text('Page 2'), findsNothing);
    widget1TransientTopLeft = tester.getTopLeft(find.text('Page 1'));
    // Page 1 is back where it started.
    expect(widget1InitialTopLeft, equals(widget1TransientTopLeft));
  });
  testWidgets('test only edge swipes work (LTR)', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) {
              final String pageNumber = settings.name == '/' ? '1' : '2';
              return Center(child: Text('Page $pageNumber'));
            },
          );
        },
      ),
    );
    tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/next');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    // Page 2 covers page 1.
    expect(find.text('Page 1'), findsNothing);
    expect(find.text('Page 2'), isOnstage);
    // Drag from the middle to the right.
    TestGesture gesture = await tester.startGesture(const Offset(200.0, 200.0));
    await gesture.moveBy(const Offset(300.0, 0.0));
    await tester.pump();
    // Nothing should happen.
    expect(find.text('Page 1'), findsNothing);
    expect(find.text('Page 2'), isOnstage);
    // Drag from the right to the left.
    gesture = await tester.startGesture(const Offset(795.0, 200.0));
    await gesture.moveBy(const Offset(-300.0, 0.0));
    await tester.pump();
    // Nothing should happen.
    expect(find.text('Page 1'), findsNothing);
    expect(find.text('Page 2'), isOnstage);
    // Drag from the right to the further right.
    gesture = await tester.startGesture(const Offset(795.0, 200.0));
    await gesture.moveBy(const Offset(300.0, 0.0));
    await tester.pump();
    // Nothing should happen.
    expect(find.text('Page 1'), findsNothing);
    expect(find.text('Page 2'), isOnstage);
    // Now drag from the left edge.
    gesture = await tester.startGesture(const Offset(5.0, 200.0));
    await gesture.moveBy(const Offset(300.0, 0.0));
    await tester.pump();
    // Page 1 is now visible.
    expect(find.text('Page 1'), isOnstage);
    expect(find.text('Page 2'), isOnstage);
  });

  testWidgets('test edge swipe then drop back at starting point works',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) {
              final String pageNumber = settings.name == '/' ? '1' : '2';
              return Center(child: Text('Page $pageNumber'));
            },
          );
        },
      ),
    );
    tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/next');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Page 1'), findsNothing);
    expect(find.text('Page 2'), isOnstage);
    final TestGesture gesture = await tester.startGesture(const Offset(5, 200));
    await gesture.moveBy(const Offset(300, 0));
    await tester.pump();
    // Bring it exactly back such that there's nothing to animate when releasing.
    await gesture.moveBy(const Offset(-300, 0));
    await gesture.up();
    await tester.pump();
    expect(find.text('Page 1'), findsNothing);
    expect(find.text('Page 2'), isOnstage);
  });
}

class RtlOverrideWidgetsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const RtlOverrideWidgetsDelegate();
  @override
  bool isSupported(Locale locale) => true;
  @override
  Future<WidgetsLocalizations> load(Locale locale) async =>
      const RtlOverrideWidgetsLocalization();
  @override
  bool shouldReload(LocalizationsDelegate<WidgetsLocalizations> oldDelegate) =>
      false;
}

class RtlOverrideWidgetsLocalization implements WidgetsLocalizations {
  const RtlOverrideWidgetsLocalization();
  @override
  TextDirection get textDirection => TextDirection.rtl;
}
