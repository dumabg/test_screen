import 'dart:async';

import 'package:flutter/material.dart';
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
        TargetPlatform.android: await AndroidFirebaseTestLab().devices(),
        TargetPlatform.iOS: await IosFirebaseTestLab().devices(),
      },
      wrapper: (Widget screen) =>
          MaterialApp(
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
