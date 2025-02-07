// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com.
// All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:test_screen/src/font_loader.dart';
import 'package:test_screen/test_screen.dart';

import 'local_file_comparator_with_threshold.dart';
import 'test_screen_config.dart';
import 'ui_target_platform.dart';

/// It does exactly the same than [testScreenUI], but doesn't do the
/// golden files bitmap comparison.
///
/// Every time the test is executed, the screen created by the test is compared
/// with the png file of the golden dir. This consumes a lot of time.
/// [testScreen] doesn't do this comparison.
/// [description] is a test description.
/// [createScreen] is a callback function that creates the screen to test.
/// [onTest] is a callback function called after the screen creation.
/// Use it to change the state of your screen.
/// [onMatchesGoldenFinder] is a callback function for returning the Finder
/// that is used for creating and matching the golden image.
/// If is null, the widget created in [createScreen] is used.
/// [goldenDir] is the name of the subdirectory created inside the screens
/// directory when the golden files are created.
/// [config] use this config instead of the global configuration defined by
/// [initializeDefaultTestScreenConfig].
/// [onlyPlatform] execute the tests only for the platform specified, ignoring
/// the specified on [config] or [initializeDefaultTestScreenConfig].
/// [setup] Registers a function to be run before tests.
/// [tearDown] Registers a function to be run after tests.
/// [setupAll] Registers a function to be run once before all tests.
/// [tearDownAll] Registers a function to be run after all tests.
@isTestGroup
void testScreen(Object description, Future<Widget> Function() createScreen,
    Future<void> Function(WidgetTester tester) onTest,
    {Future<Finder> Function()? onMatchesGoldenFinder,
    TestScreenConfig? config,
    UITargetPlatform? onlyPlatform,
    dynamic Function()? setUp,
    dynamic Function()? tearDown,
    dynamic Function()? setUpAll,
    dynamic Function()? tearDownAll}) {
  _internalTestScreen(description, createScreen, onTest, onMatchesGoldenFinder,
      config: config,
      onlyPlatform: onlyPlatform,
      testUI: false,
      fSetUp: setUp,
      fTearDown: tearDown,
      fSetUpAll: setUpAll,
      fTearDownAll: tearDownAll);
}

/// Use this function for testing custom [StatelessWidget]s and
/// [StatefulWidget]s that represent screens.
///
/// [description] is a test description.
/// [createScreen] is a callback function that creates the screen to test.
/// [onTest] is a callback function called after the screen creation.
/// Use it to change the state of your screen.
/// [onMatchesGoldenFinder] is a callback function for returning the Finder
/// that is used for creating and matching the golden image.
/// If is null, the widget created in [createScreen] is used.
/// [goldenDir] is the name of the subdirectory created inside the screens
/// directory when the golden files are created.
/// [config] use this config instead of the global configuration defined by
/// [initializeDefaultTestScreenConfig].
/// [onlyPlatform] execute the tests only for the platform specified, ignoring
/// the specified on [config] or [initializeDefaultTestScreenConfig].
/// [setup] Registers a function to be run before tests.
/// [tearDown] Registers a function to be run after tests.
/// [setupAll] Registers a function to be run once before all tests.
/// [tearDownAll] Registers a function to be run after all tests.
@isTestGroup
void testScreenUI(Object description, Future<Widget> Function() createScreen,
    {Future<void> Function(WidgetTester tester)? onTest,
    Future<Finder> Function()? onMatchesGoldenFinder,
    String? goldenDir,
    TestScreenConfig? config,
    UITargetPlatform? onlyPlatform,
    dynamic Function()? setUp,
    dynamic Function()? tearDown,
    dynamic Function()? setUpAll,
    dynamic Function()? tearDownAll}) async {
  _internalTestScreen(description, createScreen, onTest, onMatchesGoldenFinder,
      config: config,
      onlyPlatform: onlyPlatform,
      testUI: true,
      uiGolderDir: goldenDir,
      fSetUpAll: setUpAll,
      fTearDownAll: tearDownAll,
      fSetUp: setUp,
      fTearDown: tearDown);
}

@isTestGroup
void _internalTestScreen(
    Object description,
    Future<Widget> Function() createScreen,
    Future<void> Function(WidgetTester tester)? onTest,
    Future<Finder> Function()? onMatchesGoldenFinder,
    {required bool testUI,
    TestScreenConfig? config,
    UITargetPlatform? onlyPlatform,
    String? uiGolderDir,
    dynamic Function()? fSetUp,
    dynamic Function()? fTearDown,
    dynamic Function()? fSetUpAll,
    dynamic Function()? fTearDownAll}) async {
  config = config ?? defaultTestScreenConfig;
  assert(config != null);
  final Map<UITargetPlatform, List<TestScreenDevice>> platformDevices =
      config!.devices;
  final Iterable<UITargetPlatform> platforms =
      onlyPlatform == null ? platformDevices.keys : [onlyPlatform];
  final String pathSeparator = Platform.pathSeparator;
  String rootGoldenDir = 'screens$pathSeparator';
  if (uiGolderDir != null) {
    rootGoldenDir += uiGolderDir;
    if (!rootGoldenDir.endsWith(pathSeparator)) {
      rootGoldenDir += pathSeparator;
    }
  }
  group(description, () {
    GoldenFileComparator? previousGoldenFileComparator;
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      previousGoldenFileComparator = goldenFileComparator;
      final testUrl = (goldenFileComparator as LocalFileComparator).basedir;
      goldenFileComparator = LocalFileComparatorWithThreshold(
        // flutter_test's LocalFileComparator expects the test's URI as an
        // argument, but it only uses it to parse the baseDir in order to
        // obtain the directory where the golden tests will be placed.
        // As such, we use the default `testUrl`, which is only the `baseDir`
        // and append a generically named `test.dart` so that the `baseDir` is
        // properly extracted.
        Uri.parse('$testUrl/test.dart'),
        config!.threshold,
      );

      if (config != defaultTestScreenConfig) {
        await loadAppFonts(config);
      }
      fSetUpAll?.call();
    });
    tearDownAll(() {
      if (previousGoldenFileComparator != null) {
        goldenFileComparator = previousGoldenFileComparator!;
      }
      fTearDownAll?.call();
    });
    if (fSetUp != null) {
      setUp(fSetUp);
    }
    if (fTearDown != null) {
      tearDown(fTearDown);
    }
    for (final UITargetPlatform platform in platforms) {
      final List<TestScreenDevice>? devices = platformDevices[platform];
      if ((devices == null) || (devices.isEmpty)) {
        // ignore: avoid_print
        print('No devices for $platform');
      } else {
        final String platformString =
            platform.toString().substring('UITargetPlatform.'.length);
        group(platformString, () {
          TextStyle? defaultTextStyle;
          setUpAll(() {
            defaultTextStyle = _defaultTextStyle(platform);
          });
          for (final String localeName in config!.locales) {
            for (final TestScreenDevice device in devices) {
              group(localeName, () {
                String name =
                    '${device.id}: ${device.manufacturer} ${device.name}';
                if (uiGolderDir != null) {
                  name = '$name ¬$uiGolderDir';
                }
                testWidgets(name, (WidgetTester tester) async {
                  _initializeTargetPlatform(platform);
                  final TestFlutterView view = tester.view
                    ..physicalSize = device.size
                    ..devicePixelRatio = device.devicePixelRatio;
                  final locale = Locale(localeName);
                  final TestPlatformDispatcher platformDispatcher =
                      tester.platformDispatcher
                        ..localesTestValue = [locale]
                        ..localeTestValue = locale;
                  Intl.defaultLocale = localeName;
                  Intl.systemLocale = localeName;
                  await config!.onBeforeCreate?.call(tester);
                  final Widget screen = await createScreen();
                  final Widget screenWithDefaultTextStyle =
                      defaultTextStyle == null
                          ? screen
                          : DefaultTextStyle(
                              style: defaultTextStyle!, child: screen);
                  final Widget screenWrapped = config.wrapper
                          ?.call(tester, screenWithDefaultTextStyle) ??
                      screenWithDefaultTextStyle;
                  await tester.pumpWidget(screenWrapped);
                  await config.onAfterCreate?.call(tester, screen);
                  await _loadImages(tester);
                  try {
                    await onTest?.call(tester);
                  } catch (e) {
                    // ignore: avoid_print
                    print('Platform: $platformString. Locale: $localeName. '
                        'Device: ${device.name}.');
                    final String which = '${platformString}_${localeName}_'
                        '${device.id}';
                    String path = '';
                    if (uiGolderDir != null) {
                      path += uiGolderDir;
                      if (!rootGoldenDir.endsWith(pathSeparator)) {
                        path += pathSeparator;
                      }
                    }
                    await _testFailure(tester, screenWrapped, path, which);
                    rethrow;
                  }
                  if (testUI) {
                    final String goldenFileName =
                        '$rootGoldenDir${platformString}_${localeName}_'
                        '${device.id}.png';
                    await expectLater(
                        onMatchesGoldenFinder == null
                            ? find.byWidget(screen)
                            : await onMatchesGoldenFinder.call(),
                        matchesGoldenFile(goldenFileName));
                  }
                  platformDispatcher.clearLocaleTestValue();
                  view
                    ..resetPhysicalSize()
                    ..resetDevicePixelRatio();
                  debugDefaultTargetPlatformOverride = null;
                  debugDefaultUITargetPlatformIsWeb = false;
                }, tags: [testUI ? 'screen_ui' : 'screen']);
              });
            }
          }
        });
      }
    }
  });
}

TextStyle? _defaultTextStyle(UITargetPlatform platform) {
  return TextStyle(
      fontFamily: switch (platform) {
        UITargetPlatform.iOS => '.SF Pro Text',
        _ => 'Roboto'
      },
      fontFamilyFallback: ['packages/test_screen/NotoColorEmoji']);
}

void _initializeTargetPlatform(UITargetPlatform platform) {
  final platformIndex = platform.index;
  final firstWebPlatformIndex = UITargetPlatform.webAndroid.index;
  debugDefaultUITargetPlatformIsWeb = platformIndex >= firstWebPlatformIndex;
  debugDefaultTargetPlatformOverride = debugDefaultUITargetPlatformIsWeb
      ? TargetPlatform.values[platformIndex - firstWebPlatformIndex]
      : TargetPlatform.values[platformIndex];
}

Future<void> _testFailure(
    WidgetTester tester, Widget screen, String goldenPath, String which) async {
  await tester.pump();
  await tester.runAsync(() async {
    final Element element = tester.firstElement(find.byWidget(screen));
    final ui.Image image = await _captureImage(element);
    final ByteData data =
        await image.toByteData(format: ui.ImageByteFormat.png) ?? ByteData(0);
    final buffer = data.buffer;
    final String pathSeparator = Platform.pathSeparator;
    final dir = Directory(
        '${(goldenFileComparator as LocalFileComparator).basedir.toFilePath()}'
        'failures$pathSeparator$goldenPath')
      ..createSync(recursive: true);
    final dateNow = DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now());
    final File fileName =
        File('${dir.path}$pathSeparator${dateNow}_$which.png');
    // ignore: avoid_print
    print('UI failure snapshot on ${fileName.path}');
    fileName.writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  });
}

Future<ui.Image> _captureImage(Element element) {
  assert(element.renderObject != null);
  RenderObject renderObject = element.renderObject!;
  while (!renderObject.isRepaintBoundary) {
    renderObject = renderObject.parent!;
  }
  assert(!renderObject.debugNeedsPaint);
  final OffsetLayer layer = renderObject.debugLayer! as OffsetLayer;
  return layer.toImage(renderObject.paintBounds);
}

Future<void> _loadImages(WidgetTester tester) async {
  await tester.runAsync(() async {
    final imageElements = find.byType(Image, skipOffstage: false).evaluate();
    final containerElements =
        find.byType(DecoratedBox, skipOffstage: false).evaluate();
    for (final imageElement in imageElements) {
      final widget = imageElement.widget;
      if (widget is Image) {
        await precacheImage(widget.image, imageElement);
        await tester.pump();
      }
    }
    for (final container in containerElements) {
      final widget = container.widget as DecoratedBox;
      final decoration = widget.decoration;
      if (decoration is BoxDecoration) {
        if (decoration.image != null) {
          await precacheImage(decoration.image!.image, container);
          await tester.pump();
        }
      }
    }
  });
}
