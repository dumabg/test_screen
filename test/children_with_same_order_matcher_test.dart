import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_screen/test_screen.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 20,
        height: 20,
      );
}

class YourWidget extends EmptyWidget {
  const YourWidget({super.key});
}

class AnotherWidget extends EmptyWidget {
  const AnotherWidget({super.key});
}

class Widget1 extends EmptyWidget {
  const Widget1({super.key});
}

class Widget2 extends EmptyWidget {
  const Widget2({super.key});
}

void main() {
  final widget = MaterialApp(
      home: Scaffold(
          body: ListView(
    children: [
      const YourWidget(),
      const AnotherWidget(),
      ColoredBox(
        color: Colors.black,
        child: const Text('Hello'),
      ),
      const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [Widget1(), Widget2()],
        ),
      ),
    ],
  )));

  group('Children with same order matcher', () {
    testWidgets('Matches', (widgetTester) async {
      await widgetTester.pumpWidget(widget);
      expect(
          find.byType(ListView),
          ChildrenWithSomeOrderMatcher([
            find.byType(YourWidget),
            find.text('Hello'),
            find.byType(Widget2),
          ]));
    });
    testWidgets('No matches', (widgetTester) async {
      await widgetTester.pumpWidget(widget);
      expect(
          find.byType(ListView),
          isNot(ChildrenWithSomeOrderMatcher([
            find.text('Hello'),
            find.byType(YourWidget),
            find.byType(Widget2),
          ])));
    });
  });
}
