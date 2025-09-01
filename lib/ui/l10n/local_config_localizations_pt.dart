// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'local_config_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class LocalConfigLocalizationsPt extends LocalConfigLocalizations {
  LocalConfigLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get localConfig => 'Configuração Local';

  @override
  String get search => 'Buscar';

  @override
  String get configsChangedLocally => 'Alterações aplicadas';

  @override
  String get changedLocally => 'Alterado';

  @override
  String get revertAll => 'Reverter tudo';

  @override
  String get revert => 'Reverter';

  @override
  String get editParameter => 'Editar parâmetro';

  @override
  String get save => 'Salvar';

  @override
  String get parameterName => 'Nome do parâmetro (chave)';

  @override
  String get dataType => 'Tipo de dado';

  @override
  String get value => 'Valor';

  @override
  String get close => 'Fechar';

  @override
  String get fullScreenEditor => 'Editor de tela cheia';

  @override
  String get noResults => 'Uuuh... Nothing here... Just emptiness...';

  @override
  String get whatAreTheConfigs => 'WHERE ARE THE CONFIGS!?';

  @override
  String get reasosForIssues =>
      'Hmm... this might be happening because:\n• Local Config SDK hasn’t been initialized yet.\n• Configs are still populating.';

  @override
  String get wait =>
      'If you\\\'ve been waiting a while, maybe your configs are... empty.';

  @override
  String get emptyString => '(string vazia)';

  @override
  String get boolean => 'Booleano';

  @override
  String get number => 'Número';

  @override
  String get invalidBoolean => 'Booleano Inválido';

  @override
  String get invalidNumber => 'Número Inválido';

  @override
  String get invalidJson => 'JSON Inválido';

  @override
  String get validJson => 'JSON Válido';

  @override
  String get help =>
      'Essa é a chave que você vai passar para o SDK da Configuração Local, por exemplo:\n';

  @override
  String get format => 'Formatar';

  @override
  String editorOf(Object type) {
    return 'Editor de $type';
  }
}
