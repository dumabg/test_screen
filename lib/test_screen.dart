// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library test_screen;

export 'src/children_with_same_order_matcher.dart'
    show ChildrenWithSomeOrderMatcher;
export 'src/test_screen.dart' show testScreenUI, testScreen;
export 'src/test_screen_config.dart'
    show
        TestScreenDevice,
        TestScreenConfig,
        TestScreenFont,
        initializeDefaultTestScreenConfig;
export 'src/firebase_test_lab.dart'
    show AndroidFirebaseTestLab, IosFirebaseTestLab;
export 'src/widget_tester_extension.dart' show WidgetTesterExtension;
export 'src/ui_target_platform.dart' show UITargetPlatform;
export 'src/wrap_widget.dart' show wrapWidget;
