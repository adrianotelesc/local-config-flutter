import 'package:flutter/material.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/models/config_value.dart';
import 'package:local_config/src/presentation/widgets/input_form_field.dart';
import 'package:local_config/src/presentation/widgets/text_editor/text_editor.dart';

/// A value input driven by [ConfigValueType]: a true/false dropdown for
/// booleans, or a text field with a full-screen editor for string/JSON.
class ConfigValueField extends StatelessWidget {
  final ConfigValueType type;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool autofocus;
  final void Function(String)? onFieldSubmitted;

  const ConfigValueField({
    super.key,
    required this.type,
    required this.controller,
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return InputFormField(
      enabled: enabled,
      controller: controller,
      focusNode: focusNode,
      entries: type.allowedValues.map((item) {
        return DropdownMenuEntry(value: item, label: item);
      }).toList(),
      autofocus: autofocus,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) => type.validator(context, value ?? ''),
      textInputAction: TextInputAction.done,
      suffixIcon: type.isTextBased
          ? IconButton(
              onPressed: () async {
                final changedText = await Navigator.of(context).push(
                  MaterialPageRoute<String>(
                    fullscreenDialog: true,
                    builder: (_) {
                      return TextEditor(
                        value: controller.text,
                        title: LocalConfigLocalizations.of(
                          context,
                        )!.editorOf(type.getDisplayName(context)),
                        controller: type.textEditorController,
                        readOnly: !enabled,
                      );
                    },
                  ),
                );
                if (changedText != null) controller.text = changedText;
              },
              icon: const Icon(Icons.open_in_full),
              tooltip: LocalConfigLocalizations.of(context)!.fullScreenEditor,
            )
          : null,
    );
  }
}
