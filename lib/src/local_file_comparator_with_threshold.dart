import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Works just like [LocalFileComparator] but includes a [threshold] that, when
/// exceeded, marks the test as a failure.
class LocalFileComparatorWithThreshold extends LocalFileComparator {
  /// Threshold above which tests will be marked as failing.
  /// Ranges from 0 to 1, both inclusive.
  final double threshold;

  LocalFileComparatorWithThreshold(super.testFile, this.threshold)
      : assert((threshold >= 0) && (threshold <= 1));

  /// Copy of [LocalFileComparator]'s [compare] method, except for the fact that
  /// it checks if the [ComparisonResult.diffPercent] is not greater than
  /// [threshold] to decide whether this test is successful or a failure.
  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    final passed = (result.passed) || (result.diffPercent <= threshold);
    if (passed) {
      result.dispose();
      return true;
    } else {
      final error = await generateFailureOutput(result, golden, basedir);
      result.dispose();
      throw FlutterError(error);
    }
  }
}
