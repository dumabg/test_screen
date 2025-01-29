import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_screen/test_screen.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await initializeDefaultTestScreenConfig(TestScreenConfig(
    locales: ['en'],
    devices: {
      UITargetPlatform.android: [
        const TestScreenDevice(
          id: 'test',
          manufacturer: 'test',
          name: 'phone test',
          size: Size(800, 600),
        ),
      ],
    },
    wrapper: (tester, screen) => MaterialApp(
      home: screen,
    ),
  ));
  return testMain();
}
