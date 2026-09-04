import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local_config/src/common/utils/type_converters.dart';
import 'package:local_config/src/presentation/widgets/text_editor/controller/text_editor_controller.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';
import 'package:re_highlight/styles/atom-one-light.dart';

class JsonEditorController implements TextEditorController {
  JsonEditorController();

  @override
  CodeEditorStyle editorStyle(Brightness brightness) => CodeEditorStyle(
    codeTheme: CodeHighlightTheme(
      languages: {'json': CodeHighlightThemeMode(mode: langJson)},
      theme: brightness == Brightness.dark
          ? atomOneDarkTheme
          : atomOneLightTheme,
    ),
  );

  @override
  String minify(String value) {
    try {
      final json = jsonDecode(value);
      var encoder = const JsonEncoder();
      return encoder.convert(json);
    } on FormatException catch (_) {
      return value;
    }
  }

  @override
  String prettify(String value) {
    try {
      final json = jsonDecode(value);
      final spaces = ' ' * 4;
      final encoder = JsonEncoder.withIndent(spaces);
      return encoder.convert(json);
    } on FormatException catch (_) {
      return value;
    }
  }

  @override
  bool? validate(String value) {
    return RegExp(r'\{.*\}|\[.*\]', dotAll: true).hasMatch(value) &&
        tryJsonDecode(value) != null;
  }
}
