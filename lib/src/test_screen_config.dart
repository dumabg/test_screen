// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com.
// All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

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
  final Widget Function(WidgetTester tester, Widget screen)? wrapper;

  /// Callback called after the screen widget creation.
  final Future<void> Function(WidgetTester tester, Widget screen)?
      onAfterCreate;

  /// Callback called before the screen widget creation.
  final Future<void> Function(WidgetTester tester)? onBeforeCreate;

  /// List of fonts for using in the screen test.
  final List<TestScreenFont> fonts;

  /// Loads all the fonts that you have on your project,
  final bool loadDefaultFonts;

  /// Specify which simulated fonts are loaded for target platforms:
  ///   Android: Roboto font.
  ///   iOS: SFProDisplay-Regular and SFProText-Regular fonts.
  ///   Other: Roboto font.
  /// For all the platforms, font family fallback is NotoColorEmoji-Regular.
  /// This allows to use emojis.
  final Set<SimulatedPlatformFonts> loadSimulatedPlatformFonts;

  /// Threshold in golden tests:
  /// https://rows.com/blog/post/writing-a-localfilecomparator-with-threshold-for-flutter-golden-tests
  /// Default to 2%.
  final double threshold;

  TestScreenConfig(
      {required this.locales,
      required this.devices,
      this.wrapper,
      this.onBeforeCreate,
      this.onAfterCreate,
      this.fonts = const [],
      this.loadDefaultFonts = true,
      this.loadSimulatedPlatformFonts = const {
        SimulatedPlatformFonts.roboto,
        SimulatedPlatformFonts.sfProText,
      },
      this.threshold = 0.02 / 100}) // 2%
      : assert(locales.isNotEmpty),
        assert(devices.isNotEmpty);

  factory TestScreenConfig.defaultConfigCopy(
      {List<String>? withLocales,
      Map<UITargetPlatform, List<TestScreenDevice>>? withDevices,
      List<TestScreenFont>? withFonts,
      bool? withLoadDefaultFonts,
      Set<SimulatedPlatformFonts>? withLoadSimulatedPlatformFonts}) {
    final Map<UITargetPlatform, List<TestScreenDevice>> clonedDevices = {};
    final Map<UITargetPlatform, List<TestScreenDevice>> devices =
        withDevices ?? defaultTestScreenConfig!.devices;
    for (final UITargetPlatform key in devices.keys) {
      clonedDevices[key] = devices[key]!.toList();
    }
    return TestScreenConfig(
        onAfterCreate: defaultTestScreenConfig!.onAfterCreate,
        onBeforeCreate: defaultTestScreenConfig!.onBeforeCreate,
        wrapper: defaultTestScreenConfig!.wrapper,
        locales: withLocales ?? defaultTestScreenConfig!.locales.toList(),
        devices: clonedDevices,
        fonts: withFonts ?? defaultTestScreenConfig!.fonts,
        loadDefaultFonts:
            withLoadDefaultFonts ?? defaultTestScreenConfig!.loadDefaultFonts,
        loadSimulatedPlatformFonts: withLoadSimulatedPlatformFonts ??
            defaultTestScreenConfig!.loadSimulatedPlatformFonts);
  }
}

/// Default [TestScreenConfig] for all the screen tests.
TestScreenConfig? defaultTestScreenConfig;

String? projectLibraryName;

Directory? fontCacheDirectory;

/// Initialize the default configuration for all the screen tests.
/// [libraryName] If the project is a library, the name of the library.
/// Fonts can't load correctly if isn't specified.
Future<void> initializeDefaultTestScreenConfig(TestScreenConfig config,
    {String? libraryName,
    Directory? simulatedPlatformFontsCacheDirectory}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  projectLibraryName = libraryName;
  fontCacheDirectory = simulatedPlatformFontsCacheDirectory;
  defaultTestScreenConfig = config;
  await loadAppFonts(config);
  for (final TestScreenFont font in config.fonts) {
    await _loadTestFont(font.family, font.fileName);
  }
}

Future<void> _loadTestFont(String family, String fileName) async {
  final file = File(fileName);
  Future<ByteData> fontData;
  if (file.existsSync()) {
    final Uint8List fontBytes = file.readAsBytesSync();
    fontData = Future.value(fontBytes.buffer.asByteData());
  } else {
    fontData = rootBundle.load(fileName);
  }
  final fontLoader = FontLoader(family)..addFont(fontData);
  await fontLoader.load();
}
