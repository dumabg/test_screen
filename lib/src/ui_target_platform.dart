// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// This override is only useful for tests.
/// In general, therefore, this property should not be used in release builds.
bool debugDefaultUITargetPlatformIsWeb = false;

/// The platform that user interaction should adapt to target.
/// This is the same enum than `TargetPlatform` on foundation/platform.dart,
/// but web options are added. The web options means that it's a web application
/// running in a browser that is executed in the target platform.
enum UITargetPlatform {
  /// Android: <https://www.android.com/>
  android,

  /// Fuchsia: <https://fuchsia.dev/fuchsia-src/concepts>
  fuchsia,

  /// iOS: <https://www.apple.com/ios/>
  iOS,

  /// Linux: <https://www.linux.org>
  linux,

  /// macOS: <https://www.apple.com/macos>
  macOS,

  /// Windows: <https://www.windows.com>
  windows,

  /// web application on android
  webAndroid,

  /// web application on fucsia
  webFuchsia,

  /// web application on ios
  webIos,

  /// web application on linux
  webLinux,

  /// web application on macOs
  webMacOS,

  /// web application on windows
  webWindows,
}
