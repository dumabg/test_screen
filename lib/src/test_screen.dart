import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
//import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'test_screen_config.dart';
import 'stack_trace_source.dart';
import 'package:meta/meta.dart';

@isTestGroup
void testScreen(String description, Future<Widget> Function() createScreen,
    Future<void> Function(WidgetTester tester) onTest,
    {TestScreenConfig? config, TargetPlatform? onlyPlatform}) {
  _internalTestScreen(description, createScreen, onTest,
      config: config, onlyPlatform: onlyPlatform, testUI: false);
}

@isTestGroup
void testScreenUI(String description, Future<Widget> Function() createScreen,
    {Future<void> Function(WidgetTester tester)? onTest,
    String? goldenDir,
    TestScreenConfig? config,
    TargetPlatform? onlyPlatform}) async {
  _internalTestScreen(description, createScreen, onTest,
      config: config,
      onlyPlatform: onlyPlatform,
      testUI: true,
      uiGolderDir: goldenDir);
}

void _internalTestScreen(
    String description,
    Future<Widget> Function() createScreen,
    Future<void> Function(WidgetTester tester)? onTest,
    {TestScreenConfig? config,
    TargetPlatform? onlyPlatform,
    required bool testUI,
    String? uiGolderDir}) async {
  config = config ?? defaultTestScreenConfig;
  assert(config != null);
  final Map<TargetPlatform, List<TestScreenDevice>> platformDevices =
      config!.devices;
  final Iterable<TargetPlatform> platforms =
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
  group(description, () {
    for (final TargetPlatform platform in platforms) {
      final String platformString =
          platform.toString().substring('TargetPlatform.'.length);
      group(platformString, () {
        final List<TestScreenDevice>? devices = platformDevices[platform];
        if (devices != null) {
          for (final String locale in config!.locales) {
            for (final TestScreenDevice device in devices) {
              group(locale, () {
                String name = device.name;
                testWidgets(name, (WidgetTester tester) async {
                  Intl.defaultLocale = locale;
                  await tester.binding.setSurfaceSize(device.size);
                  await tester.binding.setLocale(locale, '');

                  await config!.onBeforeCreate?.call(locale, platform);
                  final Widget screen = await createScreen();
                  await tester.pumpWidget(
                      config.wrapper?.call(screen, locale, platform) ?? screen);
                  await config.onAfterCreate?.call(tester, screen);
                  await tester.pumpAndSettle();
                  await _loadImages(tester);
                  await tester.pumpAndSettle();
                  if (testUI) {
                    final String goldenFileName =
                        '$rootGoldenDir${platformString}_${locale}_$name.png';
                    await expectLater(find.byWidget(screen),
                        matchesGoldenFile(goldenFileName));
                  }
                  try {
                    await onTest?.call(tester);
                  } catch (e, stack) {
                    // ignore: avoid_print
                    print(
                        'Platform: $platformString. Locale: $locale. Device: ${device.name}.');
                    await _testFailure(tester, screen, stack);
                    rethrow;
                  }
                }, tags: [testUI ? 'screen_ui' : 'screen']);
              });
            }
          }
        }
      });
    }
  });
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
