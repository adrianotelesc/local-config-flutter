import 'package:flutter/material.dart';
import 'package:local_config/src/common/utils/line_diff.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/local_config_theme.dart';

/// A full-screen, line-by-line diff between [oldValue] and [newValue].
class DiffViewer extends StatelessWidget {
  final String title;
  final String oldValue;
  final String newValue;

  const DiffViewer({
    super.key,
    required this.title,
    required this.oldValue,
    required this.newValue,
  });

  @override
  Widget build(BuildContext context) {
    final lines = computeLineDiff(oldValue, newValue);
    final hasDifferences = lines.any(
      (line) => line.type != DiffLineType.unchanged,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: Text(title),
        leading: IconButton(
          tooltip: LocalConfigLocalizations.of(context)!.close,
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: hasDifferences
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: lines.length,
              itemBuilder: (_, index) => _DiffLineTile(line: lines[index]),
            )
          : Center(
              child: Text(LocalConfigLocalizations.of(context)!.noDifferences),
            ),
    );
  }
}

class _DiffLineTile extends StatelessWidget {
  final DiffLine line;

  const _DiffLineTile({required this.line});

  @override
  Widget build(BuildContext context) {
    final extendedColors = context.extendedColorScheme;

    final (background, marker) = switch (line.type) {
      DiffLineType.added => (extendedColors.successContainer, '+ '),
      DiffLineType.removed => (extendedColors.warningContainer, '- '),
      DiffLineType.unchanged => (null, '  '),
    };

    return Container(
      width: double.infinity,
      color: background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Text(
        '$marker${line.text}',
        style: context.extendedTextTheme.codeBodyMedium,
      ),
    );
  }
}
