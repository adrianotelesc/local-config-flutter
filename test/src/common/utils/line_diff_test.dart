import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/utils/line_diff.dart';

void main() {
  group('computeLineDiff', () {
    test('should mark every line as unchanged when texts are identical', () {
      final diff = computeLineDiff('a\nb\nc', 'a\nb\nc');

      expect(diff, [
        const DiffLine(DiffLineType.unchanged, 'a'),
        const DiffLine(DiffLineType.unchanged, 'b'),
        const DiffLine(DiffLineType.unchanged, 'c'),
      ]);
    });

    test('should mark a changed single line as removed and added', () {
      final diff = computeLineDiff('old', 'new');

      expect(diff, [
        const DiffLine(DiffLineType.removed, 'old'),
        const DiffLine(DiffLineType.added, 'new'),
      ]);
    });

    test('should detect an appended line', () {
      final diff = computeLineDiff('a\nb', 'a\nb\nc');

      expect(diff, [
        const DiffLine(DiffLineType.unchanged, 'a'),
        const DiffLine(DiffLineType.unchanged, 'b'),
        const DiffLine(DiffLineType.added, 'c'),
      ]);
    });

    test('should detect a removed line', () {
      final diff = computeLineDiff('a\nb\nc', 'a\nc');

      expect(diff, [
        const DiffLine(DiffLineType.unchanged, 'a'),
        const DiffLine(DiffLineType.removed, 'b'),
        const DiffLine(DiffLineType.unchanged, 'c'),
      ]);
    });

    test('should detect a line changed in the middle', () {
      final diff = computeLineDiff('a\nb\nc', 'a\nx\nc');

      expect(diff, [
        const DiffLine(DiffLineType.unchanged, 'a'),
        const DiffLine(DiffLineType.removed, 'b'),
        const DiffLine(DiffLineType.added, 'x'),
        const DiffLine(DiffLineType.unchanged, 'c'),
      ]);
    });

    test('should handle empty strings', () {
      expect(computeLineDiff('', ''), [
        const DiffLine(DiffLineType.unchanged, ''),
      ]);
    });

    test('should handle old text empty', () {
      final diff = computeLineDiff('', 'a');

      expect(diff, [
        const DiffLine(DiffLineType.removed, ''),
        const DiffLine(DiffLineType.added, 'a'),
      ]);
    });
  });
}
