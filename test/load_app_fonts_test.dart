import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_screen/fonts/notocoloremoji_regular_parts/notocoloremoji_regular.dart';
import 'package:test_screen/src/font_loader.dart';
import 'package:test_screen/src/simulated_platform_fonts.dart';
import 'package:test_screen/src/test_screen_config.dart';
import 'package:test_screen/test_screen.dart';

void main() {
  defaultTestScreenConfig = TestScreenConfig(locales: [
    'en'
  ], devices: {
    UITargetPlatform.android: [
      const TestScreenDevice(
        id: 'test',
        manufacturer: 'test',
        name: 'phone test',
        size: Size(800, 600),
      ),
    ],
  });
  test('Load app fonts emoji', () async {
    await loadAppFonts(TestScreenConfig.defaultConfigCopy(
        withLoadSimulatedPlatformFonts: {
          SimulatedPlatformFonts.notoColorEmoji
        }));
  });
  test('Load app fonts roboto', () async {
    await loadAppFonts(TestScreenConfig.defaultConfigCopy(
        withLoadSimulatedPlatformFonts: {SimulatedPlatformFonts.roboto}));
  });
  test('Load app fonts sfProDisplay', () async {
    await loadAppFonts(TestScreenConfig.defaultConfigCopy(
        withLoadSimulatedPlatformFonts: {SimulatedPlatformFonts.sfProDisplay}));
  });
  test('Load app fonts sfProText', () async {
    await loadAppFonts(TestScreenConfig.defaultConfigCopy(
        withLoadSimulatedPlatformFonts: {SimulatedPlatformFonts.sfProText}));
  });
  test('Load app fonts sfUIDisplay', () async {
    await loadAppFonts(TestScreenConfig.defaultConfigCopy(
        withLoadSimulatedPlatformFonts: {SimulatedPlatformFonts.sfUIDisplay}));
  });
  test('Load app fonts sfUIText', () async {
    await loadAppFonts(TestScreenConfig.defaultConfigCopy(
        withLoadSimulatedPlatformFonts: {SimulatedPlatformFonts.sfUIText}));
  });

  test(
    'emoji',
    () async {
      final fileBytes =
          await File('lib/fonts/NotoColorEmoji-Regular.ttf').readAsBytes();
      final fontCreated = font_notocoloremoji_regular();
      expect(listEquals(fileBytes, fontCreated), true);
    },
  );
}
