import 'package:flutter/widgets.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations_en.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations_pt.dart';
import 'package:provider/provider.dart';

abstract class LocalConfigLocalizations {
  static LocalConfigLocalizations resolve(Locale locale) {
    switch (locale.languageCode) {
      case 'pt':
        return LocalConfigLocalizationsPt();
      case 'en':
      default:
        return LocalConfigLocalizationsEn();
    }
  }

  static LocalConfigLocalizations of(BuildContext context) {
    return context.read<LocalConfigLocalizations>();
  }

  String get localConfig;

  String get search;

  String get changesApplied;

  String get changed;

  String get revertAll;

  String get revert;

  String get editParameter;

  String get edit;

  String get save;

  String get parameterName;

  String get dataType;

  String get value;

  String get close;

  String get fullScreenEditor;

  String get noResults;

  String get showOnlyChanged;

  String get noConfigsQuestion;

  String get possibleCauses;

  String get uninitializedTitle;

  String get uninitializedDescription;

  String get emptyConfigsTitle;

  String get emptyConfigsDescription;

  String get loadingConfigsTitle;

  String get loadingConfigsDescription;

  String get openGitHubIssue;

  String get emptyString;

  String get boolean;

  String get number;

  String get invalidBoolean;

  String get invalidNumber;

  String get invalidJson;

  String get validJson;

  String get help;

  String get format;

  String editorOf(Object type);
}
