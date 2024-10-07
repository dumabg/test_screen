import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_screen/src/test_screen_config.dart';
import 'package:test_screen/test_screen.dart';

void main() {
  group('TestScreenConfig', () {
    test('defaultConfigCopy', () async {
      final testScreenConfig = TestScreenConfig(
          locales: [
            'pt',
            'en'
          ],
          devices: {
            UITargetPlatform.webLinux: [TestScreenDevice.forWeb(1024, 768)]
          },
          wrapper: (WidgetTester tester, Widget screen) => const MaterialApp(
                debugShowCheckedModeBanner: false,
                showSemanticsDebugger: true,
                home: Text('Hola'),
              ));
      await initializeDefaultTestScreenConfig(testScreenConfig);
      expect(testScreenConfig, equals(defaultTestScreenConfig));
      var testScreenConfigCopied = TestScreenConfig.defaultConfigCopy();
      expect(defaultTestScreenConfig, isNot(testScreenConfigCopied));
      testScreenConfigCopied.devices.addAll({
        UITargetPlatform.webAndroid: [TestScreenDevice.forWeb(1024, 768)],
      });
      expect(testScreenConfig.devices, isNot(testScreenConfigCopied.devices));
      testScreenConfigCopied = TestScreenConfig.defaultConfigCopy();
      testScreenConfigCopied.locales.add('es');
      expect(testScreenConfig.locales, isNot(testScreenConfigCopied.locales));
    });
  });
}
