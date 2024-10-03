// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com.
// All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:test_screen/src/test_screen_config.dart';

/// Wraps a widget with the wrapper configured on
/// [initializeDefaultTestScreenConfig]
Widget wrapWidget(Widget widget) {
  return defaultTestScreenConfig?.wrapper?.call(widget) ?? widget;
}
