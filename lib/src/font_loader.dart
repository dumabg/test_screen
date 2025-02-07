import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as $path;
import 'package:test_screen/fonts/roboto_regular.dart';
import 'package:test_screen/fonts/sf_pro_display_regular.dart';
import 'package:test_screen/fonts/sf_pro_text_regular.dart';
import 'package:test_screen/src/test_screen_config.dart';

import '../fonts/notocoloremoji_regular_parts/notocoloremoji_regular.dart';
import 'simulated_platform_fonts.dart';

class _FontLoaderService {
  final List<String> _loaded = [];

  bool isLoaded(String family) => _loaded.contains(family);

  Future<void> load(String family, Uint8List font) async {
    final fontLoader = FontLoader(family)
      ..addFont(Future.value(ByteData.sublistView(font)));
    await fontLoader.load();
    _loaded.add(family);
  }

  Future<void> loadBundleFonts(String family, List<String> fonts) async {
    final fontLoader = FontLoader(family);
    for (final String font in fonts) {
      fontLoader.addFont(rootBundle.load(font));
    }
    await fontLoader.load();
    _loaded.add(family);
  }
}

final _fontLoaderService = _FontLoaderService();

/// By default, flutter test only uses a single "test" font called Ahem.
///
/// This font is designed to show black spaces for every character and icon.
/// This obviously makes goldens much less valuable.
///
/// Loads app and emulated system fonts
Future<void> loadAppFonts(TestScreenConfig config) async {
  if (config.loadDefaultFonts) {
    final dynamic fontManifest = await rootBundle.loadStructuredData<dynamic>(
      'FontManifest.json',
      (string) async => json.decode(string),
    );

    if (fontManifest is List) {
      for (final Map<String, dynamic> font
          in fontManifest.cast<Map<String, dynamic>>()) {
        final String manifestFamily = font['family'] as String? ?? '';
        final String family = (manifestFamily.startsWith('packages')) ||
                (manifestFamily == 'MaterialIcons')
            ? manifestFamily
            : projectLibraryName == null
                ? manifestFamily
                : 'packages/$projectLibraryName/$manifestFamily';
        if (!_fontLoaderService.isLoaded(family)) {
          final dynamic manifestFonts = font['fonts'];
          if (manifestFonts is List) {
            final List<String> fonts = [];
            for (final Map<String, dynamic> fontType
                in manifestFonts.cast<Map<String, dynamic>>()) {
              fonts.add(fontType['asset'] as String);
            }
            await _fontLoaderService.loadBundleFonts(family, fonts);
          }
        }
      }
    }
  }

  final Set<SimulatedPlatformFonts> loadSimulatedPlatformFonts =
      config.loadSimulatedPlatformFonts;
  if (loadSimulatedPlatformFonts.isNotEmpty) {
    await _loadSimulatedPlatformFonts(loadSimulatedPlatformFonts);
  }
}

Uint8List _getFont(String fontFileName, Uint8List Function() fontLoader) {
  if (fontCacheDirectory != null) {
    final file = File($path.join(fontCacheDirectory!.path, fontFileName));
    if (file.existsSync()) {
      return file.readAsBytesSync();
    } else {
      final Uint8List font = fontLoader();
      file.writeAsBytesSync(font);
      return font;
    }
  } else {
    return fontLoader();
  }
}

Future<void> _loadSimulatedPlatformFonts(
    Set<SimulatedPlatformFonts> simulatedPlatformFonts) async {
  for (final simulatedPlatformFont in simulatedPlatformFonts) {
    switch (simulatedPlatformFont) {
      case SimulatedPlatformFonts.roboto:
        final family = 'Roboto';
        if (!_fontLoaderService.isLoaded(family)) {
          final Uint8List font =
              _getFont('Roboto-Regular.ttf', fontRobotoRegular);
          await _fontLoaderService.load(family, font);
        }
      case SimulatedPlatformFonts.sfProText:
        final family = '.SF Pro Text';
        if (!_fontLoaderService.isLoaded(family)) {
          final Uint8List font =
              _getFont('SFProText-Regular.ttf', fontSfProTextRegular);
          await _fontLoaderService.load(family, font);
        }
      case SimulatedPlatformFonts.sfProDisplay:
        final family = '.SF Pro Display';
        if (!_fontLoaderService.isLoaded(family)) {
          final Uint8List font =
              _getFont('SFProDisplay-Regular.ttf', fontSfProDisplayRegular);
          await _fontLoaderService.load(family, font);
        }
      case SimulatedPlatformFonts.sfUIText:
        final family = '.SF UI Text';
        if (!_fontLoaderService.isLoaded(family)) {
          final Uint8List font =
              _getFont('SFProText-Regular.ttf', fontSfProTextRegular);
          await _fontLoaderService.load(family, font);
        }
      case SimulatedPlatformFonts.sfUIDisplay:
        final family = '.SF UI Display';
        if (!_fontLoaderService.isLoaded(family)) {
          final Uint8List font =
              _getFont('SFProDisplay-Regular.ttf', fontSfProDisplayRegular);
          await _fontLoaderService.load(family, font);
        }
      case SimulatedPlatformFonts.notoColorEmoji:
        final family = 'packages/test_screen/NotoColorEmoji';
        if (!_fontLoaderService.isLoaded(family)) {
          final Uint8List font =
              _getFont('NotoColorEmoji-Regular.ttf', fontNotocoloremojiRegular);
          await _fontLoaderService.load(family, font);
        }
    }
  }
}
