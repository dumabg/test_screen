// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com.
// All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

/// Extract the filename source that provokes this StackTrace
extension Source on StackTrace {
  File source() {
    final String stack = toString();
    // Example: (file://****/src/test/screen/main/main_screen_test.dart:27:9)
    const String pattern = '(file://';
    final int iStart = stack.indexOf(pattern);
    int iEnd = stack.indexOf(')', iStart);
    iEnd = stack.lastIndexOf(':', iEnd);
    iEnd = stack.lastIndexOf(':', iEnd - 1);
    final String fileName = stack.substring(iStart + pattern.length, iEnd);
    return File(fileName);
  }
}
