// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com.
// All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_screen/test_screen.dart';

import 'font_loader.dart';

/// A font used in the test.
class TestScreenFont {
  final String family;
  final String fileName;
  const TestScreenFont(this.family, this.fileName);
}

/// Definition of a device for testing.
class TestScreenDevice {
  /// Device id
  final String id;

  /// Manufacturer name
  final String manufacturer;

  /// Device model name
  final String name;

  /// Physical device size
  final Size size;

  /// Device pixel ratio
  final double devicePixelRatio;

  const TestScreenDevice(
      {required this.id,
      required this.manufacturer,
      required this.name,
      required this.size,
      this.devicePixelRatio = 1.0});

  /// Returns a TestScreenDevice for a web screen.
  /// The defaults values are:
  /// id: 'web_${width}x${height}'
  /// manufacturer: 'web'
  /// name: '${width}x${height}'
  /// devicePixelRatio: 1.0
  factory TestScreenDevice.forWeb(double width, double height) =>
      TestScreenDevice.forWebWithSize(Size(width, height));

  /// Returns a TestScreenDevice for a web screen.
  /// The defaults values are:
  /// id: 'web_${size.width}x${size.height}'
  /// manufacturer: 'web'
  /// name: '${size.width}x${size.height}'
  /// devicePixelRatio: 1.0
  factory TestScreenDevice.forWebWithSize(Size size) {
    final sizeDesc = '${size.width.toInt()}x${size.height.toInt()}';
    return TestScreenDevice(
        id: 'web_$sizeDesc', manufacturer: 'web', name: sizeDesc, size: size);
  }
}

/// Configuration for screen tests.
/// [locales] a list of locales to test.
///
/// [devices] a list of [TestScreenDevice] to test by platform.
///
/// [wrapper] is a parent widget needed for the screen to run.
/// For example, a [MaterialApp]:
/// ```dart
///   wrapper: (Widget screen) =>
///      MaterialApp(
///        debugShowCheckedModeBanner: false,
///        home: screen,
///        localizationsDelegates: AppLocalizations.localizationsDelegates,
///        supportedLocales: AppLocalizations.supportedLocales,
/// )));
/// ```
///
/// The screen widget to test is created in this order: first [onBeforeCreate]
/// is called.
/// Next is called the [createScreen] callback defined on the test.
/// Next is called [wrapper] for wrapping the created screen and
/// finally [onAfterCreate] is called.
class TestScreenConfig {
  /// List of locales to test
  final List<String> locales;

  /// List of [TestScreenDevice] to test by platform.
  final Map<UITargetPlatform, List<TestScreenDevice>> devices;

  /// Wrapper widget for the screen created.
  final Widget Function(Widget screen)? wrapper;

  /// Callback called after the screen widget creation.
  final Future<void> Function(WidgetTester tester, Widget screen)?
      onAfterCreate;

  /// Callback called before the screen widget creation.
  final Future<void> Function(WidgetTester tester)? onBeforeCreate;

  TestScreenConfig(
      {required this.locales,
      required this.devices,
      this.wrapper,
      this.onBeforeCreate,
      this.onAfterCreate})
      : assert(locales.isNotEmpty),
        assert(devices.isNotEmpty);

  factory TestScreenConfig.defaultConfigCopy() {
    final Map<UITargetPlatform, List<TestScreenDevice>> clonedDevices = {};
    final Map<UITargetPlatform, List<TestScreenDevice>> devices =
        defaultTestScreenConfig!.devices;
    for (final UITargetPlatform key in devices.keys) {
      clonedDevices[key] = devices[key]!.where((element) => true).toList();
    }
    return TestScreenConfig(
        onAfterCreate: defaultTestScreenConfig!.onAfterCreate,
        onBeforeCreate: defaultTestScreenConfig!.onBeforeCreate,
        wrapper: defaultTestScreenConfig!.wrapper,
        locales:
            defaultTestScreenConfig!.locales.where((element) => true).toList(),
        devices: clonedDevices);
  }
}

/// Default [TestScreenConfig] for all the screen tests.
TestScreenConfig? defaultTestScreenConfig;

/// Initialize the default configuration for all the screen tests.
/// [fonts] are a list of fonts to use in the screen test.
/// [loadDefaultFonts] loads all the fonts that you have on your project,
/// additionally test_screen have Roboto font for Android and
/// SFProDisplay-Regular and SFProText-Regular for iOS.
Future<void> initializeDefaultTestScreenConfig(TestScreenConfig config,
    {List<TestScreenFont> fonts = const [],
    bool loadDefaultFonts = true,
    String? libraryName}) async {
  defaultTestScreenConfig = config;
  if (loadDefaultFonts) {
    await loadAppFonts(libraryName);
  }
  for (final TestScreenFont font in fonts) {
    await _loadTestFont(font.family, font.fileName);
  }
}

Future<void> _loadTestFont(String family, String fileName) async {
  final fontLoader = FontLoader(family)..addFont(rootBundle.load(fileName));
  await fontLoader.load();
}
