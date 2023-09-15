// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter/widgets.dart';

import '../test_screen.dart';

/// Exception raised by the execution of the [gcloud] command.
class GCloudException implements Exception {
  final String cause;
  GCloudException(this.cause);
}

/// Base class for extract the information from Firebase Test lab about the
/// devices supported in different platforms.
abstract class FirebaseTestLab {
  final List<TestScreenDevice> _devices = [];
  final String _platform;

  /// File path where the cache file with devices information is saved.
  final String cachePath;

  /// If a device is find with the same logical size than another device that
  /// already exists in the devices list, it is ignored.
  final bool excludeSameLogicalSize;

  /// If a device has width greater than height, it's ignored.
  final bool excludeTablets;

  /// Doesn't include in the device list these models.
  final List<String> excludeModels;

  FirebaseTestLab(this._platform, String? cachePath,
      this.excludeSameLogicalSize, this.excludeModels, this.excludeTablets)
      : cachePath =
            cachePath ?? 'test/firebase_test_lab_${_platform}_devices.csv';

  /// List of the devices.
  Future<List<TestScreenDevice>> devices() async {
    if (_devices.isEmpty) {
      await _load();
    }
    return _devices;
  }

  Future<void> _load() async {
    var file = File(cachePath);
    if (await file.exists()) {
      _loadFromCache(file);
    } else {
      await _loadFromFirebaseTestLab();
      _saveToCacheFile();
    }
  }

  void _loadFromCache(File file) {
    List<String> lines = file.readAsLinesSync();
    while (lines.last.isEmpty) {
      lines.removeLast();
    }
    for (String line in lines) {
      List<String> values = line.split('|');

      String id = values[0];
      var size = Size(double.parse(values[3]), double.parse(values[4]));
      var devicePixelRatio = double.parse(values[5]);
      bool canAdd = (!excludeModels.contains(id)) &&
          (((excludeSameLogicalSize) &&
                  (!_existWithLogicalSize(size, devicePixelRatio))) ||
              (!excludeSameLogicalSize)) &&
          ((!excludeTablets) ||
              ((excludeTablets) && (size.height > size.width)));
      if (canAdd) {
        _devices.add(TestScreenDevice(
            id: id,
            manufacturer: values[1],
            name: values[2],
            size: size,
            devicePixelRatio: devicePixelRatio));
      }
    }
  }

  bool _existWithLogicalSize(Size size, double devicePixelRatio) {
    Size logicalSize = size / devicePixelRatio;
    for (TestScreenDevice device in _devices) {
      if (logicalSize == device.size / device.devicePixelRatio) {
        return true;
      }
    }
    return false;
  }

  @protected
  double getDevicePixelRatio(double screenDensity);

  @protected
  String getManufacturer(String modelDesc);

  Future<void> _loadFromFirebaseTestLab() async {
    List<String> gcloudModels = (await _gCloudModelsList()).split('\n');
    // ignore: avoid_print
    print(gcloudModels);
    // ignore: avoid_print
    print('-------------------------------------');
    int indexEnd = gcloudModels.length - 1;
    while (!gcloudModels[indexEnd].contains('──')) {
      indexEnd--;
    }
    // 3 rows header
    for (int i = 3; i < indexEnd; i++) {
      String line = gcloudModels[i];
      String modelId = line.substring(2, line.indexOf(' ', 3));
      var modelDesc = await _gCloudModelsDescribe(modelId);
      // ignore: avoid_print
      print(modelDesc);
      try {
        final screenX = double.parse(getProperty(modelDesc, 'screenX'));
        final screenY = double.parse(getProperty(modelDesc, 'screenY'));
        final devicePixelRatio = getDevicePixelRatio(
            double.parse(getProperty(modelDesc, 'screenDensity')));
        _devices.add(TestScreenDevice(
            id: getProperty(modelDesc, 'id'),
            manufacturer: getManufacturer(modelDesc),
            name: getProperty(modelDesc, '\nname'),
            size: Size(screenX, screenY),
            devicePixelRatio: devicePixelRatio));
      } catch (e) {
        // ignore: avoid_print
        print(e);
      } finally {
        // ignore: avoid_print
        print('-------------------------------------');
      }
    }
  }

  @protected
  String getProperty(String modelDesc, String property) {
    int i = modelDesc.indexOf('$property: ') + property.length + 2;
    int j = modelDesc.indexOf('\n', i);
    return modelDesc.substring(i, j);
  }

  void _saveToCacheFile() {
    File file = File(cachePath);
    file.openWrite();
    for (TestScreenDevice device in _devices) {
      file.writeAsStringSync(
          '${device.id}|${device.manufacturer}|${device.name}|${device.size.width.toInt()}|${device.size.height.toInt()}|${device.devicePixelRatio}\n',
          mode: FileMode.append);
    }
  }

  Future<String> _gCloudModelsList() async {
    ProcessResult result = await Process.run(
        'gcloud', ['firebase', 'test', _platform, 'models', 'list']);
    if (result.exitCode == 0) {
      return result.stdout as String;
    } else {
      throw GCloudException(result.stderr.toString());
    }
  }

  Future<String> _gCloudModelsDescribe(String modelId) async {
    ProcessResult result = await Process.run('gcloud',
        ['firebase', 'test', _platform, 'models', 'describe', modelId]);
    if (result.exitCode == 0) {
      return result.stdout as String;
    } else {
      throw GCloudException(result.stderr.toString());
    }
  }
}

class _AndroidFirebaseTestLab extends FirebaseTestLab {
  _AndroidFirebaseTestLab(
      {String? cachePath,
      required bool excludeSameLogicalSize,
      required bool excludeTablets,
      List<String> excludeModels = const []})
      : super('android', cachePath, excludeSameLogicalSize, excludeModels,
            excludeTablets);

  @override
  double getDevicePixelRatio(double screenDensity) => screenDensity / 160.0;

  @override
  String getManufacturer(String modelDesc) =>
      getProperty(modelDesc, 'manufacturer');
}

class _IosFirebaseTestLab extends FirebaseTestLab {
  _IosFirebaseTestLab(
      {String? cachePath,
      required bool excludeSameLogicalSize,
      required bool excludeTablets,
      List<String> excludeModels = const []})
      : super('ios', cachePath, excludeSameLogicalSize, excludeModels,
            excludeTablets);

  @override
  double getDevicePixelRatio(double screenDensity) =>
      (screenDensity / 160.0).roundToDouble();

  @override
  String getManufacturer(String modelDesc) => 'Apple';
}

/// Recover the list of Android devices that are defined in Firebase Test Lab.
class AndroidFirebaseTestLab {
  final _AndroidFirebaseTestLab _instance;

  /// [cachePath] File path where the cache file with devices information is saved.
  /// [excludeSameLogicalSize] If a device is find with the same logical size than another device that
  /// already exists in the devices list, it is ignored.
  /// [excludeModels] Doesn't include in the device list these models.
  AndroidFirebaseTestLab(
      {String? cachePath,
      bool excludeSameLogicalSize = true,
      bool excludeTablets = true,
      List<String> excludeModels = const []})
      : _instance = _AndroidFirebaseTestLab(
            cachePath: cachePath,
            excludeModels: excludeModels,
            excludeTablets: excludeTablets,
            excludeSameLogicalSize: excludeSameLogicalSize);

  /// The list of Android devices defined in Firebase Test labs.
  Future<List<TestScreenDevice>> devices() async => _instance.devices();
}

/// Recover the list of iOS devices that are defined in Firebase Test Lab.
class IosFirebaseTestLab {
  final _IosFirebaseTestLab _instance;

  /// [cachePath] File path where the cache file with devices information is saved.
  /// [excludeSameLogicalSize] If a device is find with the same logical size than another device that
  /// already exists in the devices list, it is ignored.
  /// [excludeModels] Doesn't include in the device list these models.
  IosFirebaseTestLab(
      {String? cachePath,
      bool excludeSameLogicalSize = true,
      bool excludeTablets = true,
      List<String> excludeModels = const []})
      : _instance = _IosFirebaseTestLab(
            cachePath: cachePath,
            excludeModels: excludeModels,
            excludeTablets: excludeTablets,
            excludeSameLogicalSize: excludeSameLogicalSize);

  /// The list of iOS devices defined in Firebase Test labs.
  Future<List<TestScreenDevice>> devices() async => _instance.devices();
}
