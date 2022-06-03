import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'font_loader.dart';

class TestScreenFont {
  final String family;
  final String fileName;
  const TestScreenFont(this.family, this.fileName);
}

class TestScreenDevice {
  final String name;
  final Size size;
  final EdgeInsets safeArea;

  const TestScreenDevice(
      {required this.name,
      required this.size,
      this.safeArea = const EdgeInsets.all(0)});
}

class TestScreenConfig {
  final List<String> locales;
  final Map<TargetPlatform, List<TestScreenDevice>> devices;
  final Widget Function(
      Widget screen, String locale, TargetPlatform targetPlatform)? wrapper;
  final Future<void> Function(WidgetTester tester, Widget screen)?
      onAfterCreate;
  final Future<void> Function(String locale, TargetPlatform targetPlatform)?
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

TestScreenConfig? defaultTestScreenConfig;

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

List<TestScreenDevice> androidDevicesFromFirebaseTestLab(List<String> lines,
    {bool includeEmulatorForm = false,
    bool includePhysicalForm = true,
    bool includeVirtualForm = true,
    List<String> excludeModels = const []}) {
  List<TestScreenDevice> result = [];
  List<Size> sizes = [];
  // 3 rows header, 1 row footer
  for (int i = 3; i < lines.length - 1; i++) {
    String line = lines[i];
    List<String> columns = line.split('│');
    String form = columns[4].trim();
    if ((includePhysicalForm && form.contains('PHYSICAL')) ||
        (includeVirtualForm && form.contains('VIRTUAL')) ||
        (includeEmulatorForm && form.contains('EMULATOR'))) {
      String model = columns[1].trim();
      if (!excludeModels.contains(model)) {
        List<String> sSize = columns[5].split('x');
        Size size = Size(double.parse(sSize[0]), double.parse(sSize[1]));
        // Only add devices with diferent sizes
        if (!sizes.contains(size)) {
          sizes.add(size);
          result.add(TestScreenDevice(
              name: '${columns[2].trim()} ${columns[3].trim()} ($model)',
              size: size));
        }
      }
    }
  }
  return result;
}
