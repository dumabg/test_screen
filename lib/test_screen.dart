// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com.
//All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library;

export 'src/children_with_same_order_matcher.dart'
    show ChildrenWithSomeOrderMatcher;
export 'src/firebase_test_lab.dart'
    show AndroidFirebaseTestLab, IosFirebaseTestLab;
export 'src/simulated_platform_fonts.dart' show SimulatedPlatformFonts;
export 'src/test_screen.dart' show testScreen, testScreenUI;
export 'src/test_screen_config.dart'
    show
        TestScreenConfig,
        TestScreenDevice,
        TestScreenFont,
        initializeDefaultTestScreenConfig;
export 'src/ui_target_platform.dart' show UITargetPlatform;
export 'src/widget_tester_extension.dart' show WidgetTesterExtension;
export 'src/wrap_widget.dart' show wrapWidget;
