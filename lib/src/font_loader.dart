import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

///By default, flutter test only uses a single "test" font called Ahem.
///
///This font is designed to show black spaces for every character and icon.
/// This obviously makes goldens much less valuable.
///
///To make the goldens more useful, we will automatically load any fonts
///included in your pubspec.yaml as well as from packages you depend on.
///
///If the project is a library, the fonts can't load correctly if the
///[libraryName] parameter isn't specified.
Future<void> loadAppFonts(String? libraryName) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final dynamic fontManifest = await rootBundle.loadStructuredData<dynamic>(
    'FontManifest.json',
    (string) async => json.decode(string),
  );

  if (fontManifest is List) {
    for (final Map<String, dynamic> font
        in fontManifest.cast<Map<String, dynamic>>()) {
      final String fontFamily = derivedFontFamily(font);
      final fontLoader = FontLoader(
          (fontFamily.startsWith('packages')) || (fontFamily == 'MaterialIcons')
              ? fontFamily
              : libraryName == null
                  ? fontFamily
                  : 'packages/$libraryName/$fontFamily');
      final dynamic fonts = font['fonts'];
      if (fonts is List) {
        for (final Map<String, dynamic> fontType
            in fonts.cast<Map<String, dynamic>>()) {
          fontLoader.addFont(rootBundle.load(fontType['asset'] as String));
        }
        await fontLoader.load();
      }
    }
  }
}

/// There is no way to easily load the Roboto or Cupertino fonts.
/// To make them available in tests, a package needs to include their own copies
/// of them.
///
/// GoldenToolkit supplies Roboto because it is free to use.
///
/// However, when a downstream package includes a font, the font family will be
/// prefixed with /packages/<package name>/<fontFamily> in order to disambiguate
/// when multiple packages include fonts with the same name.
///
/// Ultimately, the font loader will load whatever we tell it, so if we see a
/// font that looks like a Material or Cupertino font family, let's treat it as
/// the main font family.
@visibleForTesting
String derivedFontFamily(Map<String, dynamic> fontDefinition) {
  if (!fontDefinition.containsKey('family')) {
    return '';
  }

  final String fontFamily = fontDefinition['family'] as String;

  if (_overridableFonts.contains(fontFamily)) {
    return fontFamily;
  }

  if (fontFamily.startsWith('packages/')) {
    final fontFamilyName = fontFamily.split('/').last;
    if (_overridableFonts.any((font) => font == fontFamilyName)) {
      return fontFamilyName;
    }
  } else {
    final dynamic fonts = fontDefinition['fonts'];
    if (fonts is List) {
      for (final Map<String, dynamic> fontType
          in fonts.cast<Map<String, dynamic>>()) {
        final String? asset = fontType['asset'] as String?;
        if (asset != null && asset.startsWith('packages')) {
          final packageName = asset.split('/')[1];
          return 'packages/$packageName/$fontFamily';
        }
      }
    }
  }
  return fontFamily;
}

const List<String> _overridableFonts = [
  'Roboto',
  '.SF UI Display',
  '.SF UI Text',
  '.SF Pro Text',
  '.SF Pro Display',
];
