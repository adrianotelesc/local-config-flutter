import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';

abstract class TextEditorController {
  bool? validate(String value);

  String prettify(String value);

  String minify(String value);

  /// Builds the editor style for the given [brightness], so syntax
  /// highlighting colors stay legible on both light and dark surfaces.
  CodeEditorStyle? editorStyle(Brightness brightness);
}
