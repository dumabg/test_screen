// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com.
// All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extension on WidgetTester for recovering some useful information
extension WidgetTesterExtension on WidgetTester {
  Locale locale() => binding.platformDispatcher.locale;
  List<Locale> locales() => binding.platformDispatcher.locales;
  double devicePixelRatio() => view.devicePixelRatio;
  Size size() => view.physicalSize;
}
