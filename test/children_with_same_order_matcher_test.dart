import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_screen/test_screen.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 20,
        height: 20,
      );
}

class YourWidget extends EmptyWidget {
  const YourWidget({Key? key}) : super(key: key);
}

class AnotherWidget extends EmptyWidget {
  const AnotherWidget({Key? key}) : super(key: key);
}

class Widget1 extends EmptyWidget {
  const Widget1({Key? key}) : super(key: key);
}

class Widget2 extends EmptyWidget {
  const Widget2({Key? key}) : super(key: key);
}

void main() {
  var widget = MaterialApp(
      home: Scaffold(
          body: ListView(
    children: [
      const YourWidget(),
      const AnotherWidget(),
      Container(
        color: const Color.fromARGB(0, 0, 0, 0),
        child: const Text('Hello'),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [Widget1(), Widget2()],
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
