import 'package:flutter/material.dart';
import 'package:local_config/src/presentation/widgets/text_editor/controller/text_editor_controller.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/plaintext.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';
import 'package:re_highlight/styles/atom-one-light.dart';

class StringEditorController implements TextEditorController {
  StringEditorController();

  @override
  CodeEditorStyle editorStyle(Brightness brightness) => CodeEditorStyle(
    codeTheme: CodeHighlightTheme(
      languages: {'plaintext': CodeHighlightThemeMode(mode: langPlaintext)},
      theme: brightness == Brightness.dark
          ? atomOneDarkTheme
          : atomOneLightTheme,
    ),
  );

  @override
  String minify(String value) => value;

  @override
  String prettify(String value) => value;

  @override
  bool? validate(String value) => null;
}
