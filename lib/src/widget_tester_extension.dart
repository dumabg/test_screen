import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExtension on WidgetTester {
  Locale locale() => binding.window.locale;
  List<Locale> locales() => binding.window.locales;
  double devicePixelRatio() => binding.window.devicePixelRatio;
  Size size() => binding.window.physicalSize;
}
