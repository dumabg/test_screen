import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_screen/test_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  initializeDefaultTestScreenConfig(TestScreenConfig(
      locales: [
        'es',
        'pt',
        'en'
      ],
      devices: {
        UITargetPlatform.android: await AndroidFirebaseTestLab().devices(),
        UITargetPlatform.iOS: await IosFirebaseTestLab().devices(),
        UITargetPlatform.webLinux: [
          TestScreenDevice.forWeb(1024, 768),
          TestScreenDevice.forWeb(1280, 1024)
        ]
      },
      wrapper: (WidgetTester tester, Widget screen) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'test_screen Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: screen,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          )));
  return testMain();
}
