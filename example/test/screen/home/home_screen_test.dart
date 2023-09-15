import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_screen/test_screen.dart';
import 'package:test_screen_sample/screens/home/home_screen.dart';

void main() {
  group('Home Screen', () {

    testScreenUI('Init state', () async => const HomeScreen(),
      goldenDir: 'init_state');
  
    testScreenUI('Pushed button 3 times', () async => const HomeScreen(),
      goldenDir: 'pushed_3',
      onTest: (WidgetTester tester) async {
        for (int i = 0; i < 3; i++) {
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pump();
        }
      });
  });
}