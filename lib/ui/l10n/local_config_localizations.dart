import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'local_config_localizations_en.dart';
import 'local_config_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of LocalConfigLocalizations
/// returned by `LocalConfigLocalizations.of(context)`.
///
/// Applications need to include `LocalConfigLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/local_config_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: LocalConfigLocalizations.localizationsDelegates,
///   supportedLocales: LocalConfigLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the LocalConfigLocalizations.supportedLocales
/// property.
abstract class LocalConfigLocalizations {
  LocalConfigLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static LocalConfigLocalizations? of(BuildContext context) {
    return Localizations.of<LocalConfigLocalizations>(
      context,
      LocalConfigLocalizations,
    );
  }

  static const LocalizationsDelegate<LocalConfigLocalizations> delegate =
      _LocalConfigLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @localConfig.
  ///
  /// In en, this message translates to:
  /// **'Local Config'**
  String get localConfig;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @configsChangedLocally.
  ///
  /// In en, this message translates to:
  /// **'Configurações alteradas localmente'**
  String get configsChangedLocally;

  /// No description provided for @changedLocally.
  ///
  /// In en, this message translates to:
  /// **'Alterado localmente'**
  String get changedLocally;

  /// No description provided for @revertAll.
  ///
  /// In en, this message translates to:
  /// **'Reverter tudo'**
  String get revertAll;

  /// No description provided for @revert.
  ///
  /// In en, this message translates to:
  /// **'Reverter'**
  String get revert;

  /// No description provided for @editParameter.
  ///
  /// In en, this message translates to:
  /// **'Editar parâmetro'**
  String get editParameter;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @parameterName.
  ///
  /// In en, this message translates to:
  /// **'Nome do parâmetro (chave)'**
  String get parameterName;

  /// No description provided for @dataType.
  ///
  /// In en, this message translates to:
  /// **'Tipo de dado'**
  String get dataType;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Valor'**
  String get value;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Fechar'**
  String get close;

  /// No description provided for @fullScreenEditor.
  ///
  /// In en, this message translates to:
  /// **'Editor de tela cheia'**
  String get fullScreenEditor;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'Uuuh... Nothing here... Just emptiness...'**
  String get noResults;

  /// No description provided for @whatAreTheConfigs.
  ///
  /// In en, this message translates to:
  /// **'WHERE ARE THE CONFIGS!?'**
  String get whatAreTheConfigs;

  /// No description provided for @reasosForIssues.
  ///
  /// In en, this message translates to:
  /// **'Hmm... this might be happening because:\n• Local Config SDK hasn’t been initialized yet.\n• Configs are still populating.'**
  String get reasosForIssues;

  /// No description provided for @wait.
  ///
  /// In en, this message translates to:
  /// **'If you\\\'ve been waiting a while, maybe your configs are... empty.'**
  String get wait;

  /// No description provided for @emptyString.
  ///
  /// In en, this message translates to:
  /// **'(string vazia)'**
  String get emptyString;

  /// No description provided for @boolean.
  ///
  /// In en, this message translates to:
  /// **'Booleano'**
  String get boolean;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Número'**
  String get number;

  /// No description provided for @invalidBoolean.
  ///
  /// In en, this message translates to:
  /// **'Booleano Inválido'**
  String get invalidBoolean;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Número Inválido'**
  String get invalidNumber;

  /// No description provided for @invalidJson.
  ///
  /// In en, this message translates to:
  /// **'JSON Inválido'**
  String get invalidJson;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'This is the key you\'ll pass to the Local Config SDK,\nfor example:\n'**
  String get help;
}

class _LocalConfigLocalizationsDelegate
    extends LocalizationsDelegate<LocalConfigLocalizations> {
  const _LocalConfigLocalizationsDelegate();

  @override
  Future<LocalConfigLocalizations> load(Locale locale) {
    return SynchronousFuture<LocalConfigLocalizations>(
      lookupLocalConfigLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalConfigLocalizationsDelegate old) => false;
}

LocalConfigLocalizations lookupLocalConfigLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return LocalConfigLocalizationsEn();
    case 'pt':
      return LocalConfigLocalizationsPt();
  }

  throw FlutterError(
    'LocalConfigLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
