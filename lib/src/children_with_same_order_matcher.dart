// Copyright 2022 Miguel Angel Besalduch Garcia, mabg.dev@gmail.com.
// All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Compare the Actual finder children with the [finders] sequentially.
///
/// ## Sample code
///
/// This Widget:
/// ```dart
///  ListView(
///   children: [
///     const YourWidget(),
///     AnotherWidget(),
///     Container(
///       child: Text('Hello'),
///     ),
///     Padding(
///       padding: const EdgeInsets.all(8.0),
///       child: Column(
///         children: [Widget1(),
///                   Widget2()],
///       ),
///     ),
///   ],
/// );
/// ```
/// Match:
/// ```dart
/// expect(
///   find.byType(ListView),
///   ChildrenWithSomeOrderMatcher([
///     find.byType(YourWidget),
///     find.text('Hello'),
///     find.byType(Widget2),
/// ]));
/// ```
/// No match:
/// ```dart
/// expect(
///   find.byType(ListView),
///   ChildrenWithSomeOrderMatcher([
///     find.text('Hello'),
///     find.byType(YourWidget),
///     find.byType(Widget2),
/// ]));
/// ```
///
class ChildrenWithSomeOrderMatcher extends Matcher {
  final List<Finder> finders;
  ChildrenWithSomeOrderMatcher(this.finders) : assert(finders.isNotEmpty);

  @override
  Description describe(Description description) {
    return description.add(
        'every finder must match with the children of Actual sequentially');
  }

  @override
  bool matches(covariant Finder item, Map<dynamic, dynamic> matchState) {
    final Finder childrenFinder = find.descendant(
      of: item.first,
      matching: find.byType(KeyedSubtree),
    );
    final Iterable<Element> subtrees = childrenFinder.evaluate();
    if (subtrees.length < finders.length) {
      matchState['error_length'] = true;
      return false;
    }

    int i = 0;
    Finder finder = finders[i];
    for (final Element subtree in subtrees) {
      final Iterable<Element> eFinder = find
          .descendant(of: find.byWidget(subtree.widget), matching: finder)
          .evaluate();
      if (eFinder.isNotEmpty) {
        i = i + 1;
        if (i == finders.length) {
          return true;
        }
        finder = finders[i];
      }
    }
    matchState['last'] = i;
    return false;
  }

  @override
  Description describeMismatch(
      covariant Finder item,
      Description mismatchDescription,
      Map<dynamic, dynamic> matchState,
      bool verbose) {
    final String description =
        item.evaluate().elementAt(0).widget.runtimeType.toString();
    if (matchState.containsKey('error_length')) {
      return mismatchDescription
          .add('$description has less children than finders to match');
    } else {
      final int last = matchState['last'] as int;
      if (last == 0) {
        return mismatchDescription
            .add('$description children not matches with any finder');
      } else {
        final String finderDesc =
            finders[last - 1].describeMatch(Plurality.zero);
        return mismatchDescription
            .add('$description children matches until the $last finder: '
                '$finderDesc');
      }
    }
  }
}
