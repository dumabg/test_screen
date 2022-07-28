// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:ui_target_platform/ui_target_platform.dart';
import 'dart:ui' as ui;
import 'test_screen_config.dart';
import 'stack_trace_source.dart';

/// It does exactly the same than [testScreenUI], but doesn't do the
/// golden files bitmap comparison.
///
/// Every time the test is executed, the screen created by the test
/// is compared with the png file of the golden dir. This consumes a lot of time.
/// [testScreen] doesn't do this comparison.
@isTestGroup
void testScreen(Object description, Future<Widget> Function() createScreen,
    Future<void> Function(WidgetTester tester) onTest,
    {TestScreenConfig? config, UITargetPlatform? onlyPlatform}) {
  _internalTestScreen(description, createScreen, onTest,
      config: config, onlyPlatform: onlyPlatform, testUI: false);
}

/// Use this function for testing custom [StatelessWidget]s and
/// [StatefulWidget]s that represent screens.
///
/// [description] is a test description.
/// [createScreen] is a callback function that creates the screen to test.
/// [onTest] is a callback function called after the screen creation.
/// Use it to change the state of your screen.
/// [goldenDir] is the name of the subdirectory created inside the screens directory
/// when the golden files are created.
/// [config] use this config instead of the global configuration defined by [initializeDefaultTestScreenConfig].
/// [onlyPlatform] execute the tests only for the platform specified, ignoring the specified
/// on [config] or [initializeDefaultTestScreenConfig].
@isTestGroup
void testScreenUI(Object description, Future<Widget> Function() createScreen,
    {Future<void> Function(WidgetTester tester)? onTest,
    String? goldenDir,
    TestScreenConfig? config,
    UITargetPlatform? onlyPlatform}) async {
  _internalTestScreen(description, createScreen, onTest,
      config: config,
      onlyPlatform: onlyPlatform,
      testUI: true,
      uiGolderDir: goldenDir);
}

@isTestGroup
void _internalTestScreen(
    Object description,
    Future<Widget> Function() createScreen,
    Future<void> Function(WidgetTester tester)? onTest,
    {TestScreenConfig? config,
    UITargetPlatform? onlyPlatform,
    required bool testUI,
    String? uiGolderDir}) async {
  config = config ?? defaultTestScreenConfig;
  assert(config != null);
  final Map<UITargetPlatform, List<TestScreenDevice>> platformDevices =
      config!.devices;
  final Iterable<UITargetPlatform> platforms =
      onlyPlatform == null ? platformDevices.keys : [onlyPlatform];
  String pathSeparator = Platform.pathSeparator;
  String rootGoldenDir = 'screens$pathSeparator';
  if (uiGolderDir != null) {
    rootGoldenDir += uiGolderDir;
    if (!rootGoldenDir.endsWith(pathSeparator)) {
      rootGoldenDir += pathSeparator;
    }
  }
  TestWidgetsFlutterBinding.ensureInitialized();
  bool oldDebugDisableShadows = debugDisableShadows;
  group(description, () {
    for (final UITargetPlatform platform in platforms) {
      final List<TestScreenDevice>? devices = platformDevices[platform];
      if ((devices == null) || (devices.isEmpty)) {
        // ignore: avoid_print
        print('No devices for $platform');
      } else {
        final String platformString =
            platform.toString().substring('UITargetPlatform.'.length);
        group(platformString, () {
          for (final String localeName in config!.locales) {
            for (final TestScreenDevice device in devices) {
              group(localeName, () {
                String name =
                    '${device.id}: ${device.manufacturer} ${device.name}';
                testWidgets(name, (WidgetTester tester) async {
                  _initializeTargetPlatform(platform);
                  TestWindow testWindow = tester.binding.window;
                  testWindow.physicalSizeTestValue =
                      device.size / device.devicePixelRatio;
                  testWindow.devicePixelRatioTestValue = 1.0;
                  var locale = Locale(localeName);
                  testWindow.platformDispatcher.localesTestValue = [locale];
                  testWindow.platformDispatcher.localeTestValue = locale;

                  await config!.onBeforeCreate?.call(tester);
                  final Widget screen = await createScreen();
                  await tester
                      .pumpWidget(config.wrapper?.call(screen) ?? screen);
                  await config.onAfterCreate?.call(tester, screen);
                  await tester.pumpAndSettle();
                  await _loadImages(tester);
                  await tester.pumpAndSettle();
                  try {
                    await onTest?.call(tester);
                  } catch (e, stack) {
                    // ignore: avoid_print
                    print(
                        'Platform: $platformString. Locale: $localeName. Device: ${device.name}.');
                    await _testFailure(tester, screen, stack);
                    rethrow;
                  }
                  if (testUI) {
                    final String filenamePrefix =
                        uiGolderDir == null ? '' : '${uiGolderDir}_';
                    final String goldenFileName =
                        '$rootGoldenDir$filenamePrefix${platformString}_${localeName}_${device.id}.png';
                    await expectLater(find.byWidget(screen),
                        matchesGoldenFile(goldenFileName));
                  }
                  testWindow.platformDispatcher.clearLocaleTestValue();
                  testWindow.clearPhysicalSizeTestValue();
                  testWindow.clearDevicePixelRatioTestValue();
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
  debugDisableShadows = oldDebugDisableShadows;
}

void _initializeTargetPlatform(UITargetPlatform platform) {
  if (platform == UITargetPlatform.web) {
    debugDefaultTargetPlatformOverride = null;
    debugDefaultUITargetPlatformIsWeb = true;
  } else {
    debugDefaultTargetPlatformOverride = TargetPlatform.values[platform.index];
    debugDefaultUITargetPlatformIsWeb = false;
  }
}

Future<void> _testFailure(
    WidgetTester tester, Widget screen, StackTrace stack) async {
  await tester.pump();
  await tester.runAsync(() async {
    final Element element = tester.firstElement(find.byWidget(screen));
    final ui.Image image = await _captureImage(element);
    final ByteData data =
        await image.toByteData(format: ui.ImageByteFormat.png) ?? ByteData(0);
    final buffer = data.buffer;
    final File file = stack.source();
    final File fileName = File(
        '${file.parent.path}${Platform.pathSeparator}failures/${DateTime.now().millisecondsSinceEpoch}.png');
    await fileName.create(recursive: true);
    // ignore: avoid_print
    print('UI snapshot on ${fileName.path}');
    await fileName.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  });
}

Future<ui.Image> _captureImage(Element element) {
  assert(element.renderObject != null);
  RenderObject renderObject = element.renderObject!;
  while (!renderObject.isRepaintBoundary) {
    renderObject = renderObject.parent! as RenderObject;
  }
  assert(!renderObject.debugNeedsPaint);
  final OffsetLayer layer = renderObject.debugLayer! as OffsetLayer;
  return layer.toImage(renderObject.paintBounds);
}

Future<void> _loadImages(WidgetTester tester) async {
  final imageElements = find.byType(Image, skipOffstage: false).evaluate();
  final containerElements =
      find.byType(DecoratedBox, skipOffstage: false).evaluate();
  await tester.runAsync(() async {
    for (final imageElement in imageElements) {
      final widget = imageElement.widget;
      if (widget is Image) {
        await precacheImage(widget.image, imageElement);
      }
    }
    for (final container in containerElements) {
      final widget = container.widget as DecoratedBox;
      final decoration = widget.decoration;
      if (decoration is BoxDecoration) {
        if (decoration.image != null) {
          await precacheImage(decoration.image!.image, container);
        }
      }
    }
  });
}
