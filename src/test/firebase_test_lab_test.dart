import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_screen/src/firebase_test_lab.dart';
import 'package:test_screen/src/test_screen_config.dart';

void main() {
  group('Android devices from Firebase Test Lab', () {
    test('Default devices', () async {
      AndroidFirebaseTestLab androidFirebaseTestLab = AndroidFirebaseTestLab();
      List<TestScreenDevice> devices = await androidFirebaseTestLab.devices();
      List<Size> sizes = devices
          .map<Size>((TestScreenDevice device) =>
              device.size / device.devicePixelRatio)
          .toList();
      for (Size size in sizes) {
        int num = sizes.fold<int>(
            0,
            (int previousValue, Size element) =>
                size == element ? previousValue + 1 : previousValue);
        expect(num, 1);
      }
    });

    test('Include same logical size', () async {
      AndroidFirebaseTestLab androidFirebaseTestLab =
          AndroidFirebaseTestLab(excludeSameLogicalSize: false);
      List<TestScreenDevice> devices = await androidFirebaseTestLab.devices();
      List<Size> sizes = devices
          .map<Size>((TestScreenDevice device) =>
              device.size / device.devicePixelRatio)
          .toList();
      bool numGreaterThanOne = false;
      for (Size size in sizes) {
        int num = sizes.fold<int>(
            0,
            (int previousValue, Size element) =>
                size == element ? previousValue + 1 : previousValue);
        numGreaterThanOne = numGreaterThanOne || (num > 1);
        if (numGreaterThanOne) {
          break;
        }
      }
      expect(numGreaterThanOne, true);
    });

    test('Exclude models', () async {
      AndroidFirebaseTestLab androidFirebaseTestLab = AndroidFirebaseTestLab(
          excludeSameLogicalSize: false,
          excludeTablets: false,
          excludeModels: ['\'1610\'', 'x1q']);
      List<TestScreenDevice> devices = await androidFirebaseTestLab.devices();
      int index = devices
          .indexWhere((TestScreenDevice device) => device.id == '\'1610\'');
      expect(index, -1);
      index =
          devices.indexWhere((TestScreenDevice device) => device.id == 'x1q');
      expect(index, -1);
    });

    test('Exclude tablets', () async {
      AndroidFirebaseTestLab androidFirebaseTestLab = AndroidFirebaseTestLab(
        excludeSameLogicalSize: false,
      );
      List<TestScreenDevice> devices = await androidFirebaseTestLab.devices();
      expect(devices.length, greaterThan(0));
      for (TestScreenDevice device in devices) {
        final Size size = device.size;
        expect(size.height, greaterThan(size.width), reason: device.name);
      }
    });
  });
}
