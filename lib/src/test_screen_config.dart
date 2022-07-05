// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

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
      required this.devicePixelRatio});
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
/// The screen widget to test is created in this order: first [onBeforeCreate] is called. 
/// Next is called the [createScreen] callback defined on the test. Next is
/// called [wrapper] for wrapping the created screen and finally [onAfterCreate] is called.
class TestScreenConfig {

  /// List of locales to test
  final List<String> locales;

  /// List of [TestScreenDevice] to test by platform.
  final Map<TargetPlatform, List<TestScreenDevice>> devices;

  /// Wrapper widget for the screen created.
  final Widget Function(Widget screen)? wrapper;

  /// Callback called after the screen widget creation.
  final Future<void> Function(WidgetTester tester, Widget screen)?
      onAfterCreate;

  /// Callback called before the screen widget creation.
  final Future<void> Function(WidgetTester tester)?
      onBeforeCreate;

  TestScreenConfig(
      {required this.locales,
      required this.devices,
      this.wrapper,
      this.onBeforeCreate,
      this.onAfterCreate})
      : assert(locales.isNotEmpty),
        assert(devices.isNotEmpty);
}

/// Default [TestScreenConfig] for all the screen tests.
TestScreenConfig? defaultTestScreenConfig;

/// Initialize the default configuration for all the screen tests.
/// [fonts] are a list of fonts to use in the screen test.
/// [loadDefaultFonts] loads all the fonts that you have on your project,
/// aditionally test_screen have a Roboto font for Android and a SFProDisplay-Regular
/// and  SFProText-Regular for iOS.
Future<void> initializeDefaultTestScreenConfig(TestScreenConfig config,
    {List<TestScreenFont> fonts = const [],
    bool loadDefaultFonts = true}) async {
  defaultTestScreenConfig = config;
  if (loadDefaultFonts) {
    await loadAppFonts();
  }
  for (TestScreenFont font in fonts) {
    _loadTestFont(font.family, font.fileName);
  }
}

Future<void> _loadTestFont(String family, String fileName) async {
  var fontLoader = FontLoader(family);
  // var file = File(fileName);
  // var data = (await file.readAsBytes()).buffer;
  // fontLoader.addFont(Future.value(ByteData.view(data)));
  fontLoader.addFont(rootBundle.load(fileName));
  await fontLoader.load();
}
