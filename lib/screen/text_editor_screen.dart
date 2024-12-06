import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';

class TextEditorScreen extends StatefulWidget {
  const TextEditorScreen({
    super.key,
    this.initialValue = '',
  });

  final String initialValue;

  @override
  State<StatefulWidget> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  final _textController = CodeLineEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _textController.text = jsonPrettify(widget.initialValue);
    _textController.addListener(_updateValidState);
    _isValid = checkJson(_textController.text);
  }

  void _updateValidState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isValid = checkJson(_textController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(
        onCloseClick: pop,
        onSaveClick: _isValid ? popAndResult : null,
      ),
      body: Column(
        children: [
          _FormattingBar(
            isValid: _isValid,
            onFormatClick: () {
              _textController.text = jsonPrettify(_textController.text);
            },
          ),
          _Editor(textController: _textController),
        ],
      ),
    );
  }

  void pop() {
    Navigator.maybePop(
      context,
      widget.initialValue,
    );
  }

  void popAndResult() {
    Navigator.maybePop(
      context,
      jsonMinify(_textController.text),
    );
  }

  @override
  void dispose() {
    _textController.removeListener(_updateValidState);
    _textController.dispose();
    super.dispose();
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({this.onCloseClick, this.onSaveClick});

  final void Function()? onCloseClick;
  final void Function()? onSaveClick;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Editor'),
      leading: IconButton(
        tooltip: 'Close',
        onPressed: onCloseClick,
        icon: const Icon(Icons.close),
      ),
      actions: [
        IconButton(
          tooltip: 'Save',
          onPressed: onSaveClick,
          icon: const Icon(Icons.check),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _FormattingBar extends StatelessWidget {
  const _FormattingBar({required this.isValid, this.onFormatClick});

  final bool isValid;
  final Function()? onFormatClick;

  Color get primaryColor {
    return isValid ? Colors.greenAccent : Colors.orangeAccent;
  }

  Color get secondaryColor {
    return isValid
        ? const Color.fromARGB(37, 76, 175, 79)
        : const Color.fromARGB(36, 175, 165, 76);
  }

  Color get actionColor {
    return isValid ? Colors.greenAccent : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        color: secondaryColor,
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: primaryColor,
          ),
          const SizedBox.square(
            dimension: 8,
          ),
          Text(
            'Valid JSON',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: primaryColor),
          ),
          const Spacer(),
          TextButton(
            onPressed: isValid ? onFormatClick : null,
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
                actionColor,
              ),
            ),
            child: const Text('Format'),
          )
        ],
      ),
    );
  }
}

class _Editor extends StatelessWidget {
  const _Editor({required this.textController});

  final CodeLineEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CodeEditor(
        shortcutsActivatorsBuilder:
            const DefaultCodeShortcutsActivatorsBuilder(),
        controller: textController,
        indicatorBuilder:
            (context, editingController, chunkController, notifier) {
          return Row(
            children: [
              DefaultCodeLineNumber(
                controller: editingController,
                notifier: notifier,
              ),
              DefaultCodeChunkIndicator(
                  width: 20, controller: chunkController, notifier: notifier)
            ],
          );
        },
        style: CodeEditorStyle(
          fontSize: 16,
          codeTheme: CodeHighlightTheme(
            languages: {'json': CodeHighlightThemeMode(mode: langJson)},
            theme: atomOneDarkTheme,
          ),
        ),
      ),
    );
  }
}

bool checkJson(String jsonString) {
  try {
    jsonDecode(jsonString);
    return true;
  } on FormatException catch (_) {
    return false;
  }
}

String jsonPrettify(String jsonString) {
  try {
    final json = jsonDecode(jsonString);
    final spaces = ' ' * 4;
    final encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  } on FormatException catch (_) {
    return jsonString;
  }
}

String jsonMinify(String jsonString) {
  try {
    final json = jsonDecode(jsonString);
    var encoder = const JsonEncoder();
    return encoder.convert(json);
  } on FormatException catch (_) {
    return jsonString;
  }
}
