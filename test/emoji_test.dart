import 'package:flutter/widgets.dart';
import 'package:test_screen/test_screen.dart';

void main() {
  testScreenUI(
      'emoji',
      config: TestScreenConfig.defaultConfigCopy(
          withLoadSimulatedPlatformFonts: {
            SimulatedPlatformFonts.notoColorEmoji
          }),
      () async => Center(
            child: Text('Hola: 😀🤡'),
          ));
}
