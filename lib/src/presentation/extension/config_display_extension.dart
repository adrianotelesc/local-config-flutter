import 'package:flutter/material.dart';
import 'package:local_config/src/common/utils/type_converters.dart';
import 'package:local_config/src/domain/entity/local_config_value.dart';
import 'package:local_config/src/presentation/l10n/local_config_localizations.dart';
import 'package:local_config/src/presentation/widget/text_editor/controller/text_editor_controller.dart';
import 'package:local_config/src/presentation/widget/text_editor/controller/json_editor_controller.dart';
import 'package:local_config/src/presentation/widget/text_editor/controller/string_editor_controller.dart';

extension ConfigDisplayExtension on LocalConfigValue {
  String getDisplayText(BuildContext context) {
    return type == LocalConfigType.string && raw.isEmpty
        ? LocalConfigLocalizations.of(context)!.emptyString
        : raw.toString();
  }
}

extension ConfigTypeExtension on LocalConfigType {
  List<String> get presets {
    return this == LocalConfigType.boolean ? ['false', 'true'] : [];
  }

  String getDisplayName(BuildContext context) {
    return switch (this) {
      LocalConfigType.boolean => LocalConfigLocalizations.of(context)!.boolean,
      LocalConfigType.number => LocalConfigLocalizations.of(context)!.number,
      LocalConfigType.string => 'String',
      LocalConfigType.json => 'JSON',
    };
  }

  IconData get icon {
    return switch (this) {
      LocalConfigType.boolean => Icons.toggle_on,
      LocalConfigType.number => Icons.onetwothree,
      LocalConfigType.string => Icons.abc,
      LocalConfigType.json => Icons.data_object,
    };
  }

  String? validator(BuildContext context, String value) {
    if (this == LocalConfigType.boolean && bool.tryParse(value) == null) {
      return LocalConfigLocalizations.of(context)!.invalidBoolean;
    }
    if (this == LocalConfigType.number && num.tryParse(value) == null) {
      return LocalConfigLocalizations.of(context)!.invalidNumber;
    }
    if (this == LocalConfigType.json && tryJsonDecode(value) == null) {
      return LocalConfigLocalizations.of(context)!.invalidJson;
    }
    return null;
  }

  // TODO: Refactor this.
  TextEditorController get textEditorController {
    return switch (this) {
      LocalConfigType.json => JsonEditorController(),
      _ => StringEditorController(),
    };
  }

  TextSpan help(BuildContext context, {String name = 'name'}) {
    final suffixes = switch (this) {
      LocalConfigType.boolean => ['Boolean'],
      LocalConfigType.number => ['Int', 'Double'],
      LocalConfigType.string || LocalConfigType.json => ['String'],
    };

    return TextSpan(
      children: [
        TextSpan(text: LocalConfigLocalizations.of(context)!.help),
        ...suffixes.map((suffix) {
          return TextSpan(
            children: [
              TextSpan(
                text: '\nconfig.get$suffix("',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'GoogleSansCode',
                  color: ColorScheme.of(context).surface,
                ),
              ),
              TextSpan(
                text: name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'GoogleSansCode',
                  fontWeight: FontWeight.bold,
                  color: ColorScheme.of(context).surface,
                ),
              ),
              TextSpan(
                text: '");',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'GoogleSansCode',
                  color: ColorScheme.of(context).surface,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
