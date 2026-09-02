enum DiffLineType { unchanged, added, removed }

class DiffLine {
  final DiffLineType type;
  final String text;

  const DiffLine(this.type, this.text);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffLine && type == other.type && text == other.text;

  @override
  int get hashCode => Object.hash(type, text);
}

/// Computes a line-by-line diff between [oldText] and [newText] using their
/// longest common subsequence of lines.
List<DiffLine> computeLineDiff(String oldText, String newText) {
  final oldLines = oldText.split('\n');
  final newLines = newText.split('\n');

  final m = oldLines.length;
  final n = newLines.length;

  final lcs = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
  for (var i = m - 1; i >= 0; i--) {
    for (var j = n - 1; j >= 0; j--) {
      lcs[i][j] = oldLines[i] == newLines[j]
          ? lcs[i + 1][j + 1] + 1
          : (lcs[i + 1][j] >= lcs[i][j + 1] ? lcs[i + 1][j] : lcs[i][j + 1]);
    }
  }

  final result = <DiffLine>[];
  var i = 0;
  var j = 0;

  while (i < m && j < n) {
    if (oldLines[i] == newLines[j]) {
      result.add(DiffLine(DiffLineType.unchanged, oldLines[i]));
      i++;
      j++;
    } else if (lcs[i + 1][j] >= lcs[i][j + 1]) {
      result.add(DiffLine(DiffLineType.removed, oldLines[i]));
      i++;
    } else {
      result.add(DiffLine(DiffLineType.added, newLines[j]));
      j++;
    }
  }
  while (i < m) {
    result.add(DiffLine(DiffLineType.removed, oldLines[i]));
    i++;
  }
  while (j < n) {
    result.add(DiffLine(DiffLineType.added, newLines[j]));
    j++;
  }

  return result;
}
