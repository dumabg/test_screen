import 'package:flutter_test/flutter_test.dart';
import 'package:test_screen/test_screen.dart';
import 'package:test_screen_sample/screens/multi_platform/multi_platform_screen.dart';

void main() {
  group('MultiPlatform Screen', () {
    testScreenUI('Init state', () async => const MultiPlatformScreen());  
  });
}