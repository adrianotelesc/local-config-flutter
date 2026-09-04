import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:local_config/src/common/utils/key_validators.dart';
import 'package:local_config/src/local_config_internals.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/local_config_theme.dart';
import 'package:local_config/src/presentation/models/config_value.dart';
import 'package:local_config/src/presentation/notifiers/config_editing_notifier.dart';
import 'package:local_config/src/presentation/widgets/config_value_field.dart';
import 'package:local_config/src/presentation/widgets/dashed_l_connector.dart';
import 'package:local_config/src/presentation/widgets/diff_viewer.dart';
import 'package:local_config/src/presentation/widgets/input_form_field.dart';
import 'package:local_config/src/presentation/widgets/root_aware_sliver_app_bar.dart';

class ConfigEditingScreen extends StatefulWidget {
  const ConfigEditingScreen({super.key, this.name});

  final String? name;

  @override
  State<StatefulWidget> createState() => _ConfigEditingScreenState();
}

class _ConfigEditingScreenState extends State<ConfigEditingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _textController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  final _valueFocusNode = FocusNode();

  final _configEditingNotifier = ConfigEditingNotifier(configRepo: configRepo);

  var _type = ConfigValueType.string;

  var _didSeedTypeController = false;

  bool get _isAdding => widget.name == null;

  bool get _isFreeForm =>
      _isAdding || _configEditingNotifier.configValue.isCustom;

  @override
  void initState() {
    super.initState();
    _typeController.addListener(_handleTypeChanged);

    if (_isAdding) {
      _configEditingNotifier.showEditingLocalValue = true;
      _textController.text = _defaultValueFor(_type);
      return;
    }

    _configEditingNotifier.load(widget.name!);
    _nameController.text = widget.name!;
    _textController.text =
        _configEditingNotifier.initialEditingLocalValue ?? '';

    if (_configEditingNotifier.configValue.isCustom) {
      _type = _configEditingNotifier.configValue.type;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // getDisplayName() needs Localizations.of(context), which can't be
    // resolved yet inside initState().
    if (_didSeedTypeController || !_isFreeForm) return;
    _didSeedTypeController = true;

    _typeController.text = _type.getDisplayName(context);
  }

  @override
  void dispose() {
    _typeController.removeListener(_handleTypeChanged);
    _nameController.dispose();
    _typeController.dispose();
    _textController.dispose();
    _nameFocusNode.dispose();
    _typeFocusNode.dispose();
    _valueFocusNode.dispose();
    super.dispose();
  }

  void _handleTypeChanged() {
    if (!_isFreeForm) return;

    final match = ConfigValueType.values.firstWhereOrNull(
      (value) => value.getDisplayName(context) == _typeController.text,
    );
    if (match == null || match == _type) return;

    setState(() {
      _type = match;
      _textController.text = _defaultValueFor(match);
    });

    FocusScope.of(context).requestFocus(_valueFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          _AppBar(
            title: _isAdding
                ? LocalConfigLocalizations.of(context)!.addParameter
                : LocalConfigLocalizations.of(context)!.editParameter,
            onSaveButtonPressed: _submit,
          ),
          ListenableBuilder(
            listenable: _configEditingNotifier,
            builder: (_, _) {
              return _Form(
                formKey: _formKey,
                nameController: _nameController,
                nameFocusNode: _nameFocusNode,
                typeController: _typeController,
                typeFocusNode: _typeFocusNode,
                fieldTextController: _textController,
                valueFocusNode: _valueFocusNode,
                nameEditable: _isFreeForm,
                nameValidator: _isFreeForm ? _validateName : null,
                type: _isFreeForm
                    ? _type
                    : _configEditingNotifier.configValue.type,
                typeEditable: _isFreeForm,
                configValue: _isAdding
                    ? null
                    : _configEditingNotifier.configValue,
                onSubmitted: (_) => _submit(),
                setShowEditingLocalValue: (value) {
                  _configEditingNotifier.showEditingLocalValue = value;
                },
                showEditingLocalValue:
                    _configEditingNotifier.showEditingLocalValue,
                shouldResetToDefault:
                    _configEditingNotifier.shouldResetToDefault,
                setShouldResetToDefault: (value) {
                  _configEditingNotifier.shouldResetToDefault = value;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String? _validateName(String? value) {
    final name = value ?? '';

    if (!isValidStorageKey(name)) {
      return LocalConfigLocalizations.of(context)!.invalidParameterName;
    }
    if (name != widget.name && _configEditingNotifier.nameExists(name)) {
      return LocalConfigLocalizations.of(context)!.parameterNameAlreadyExists;
    }

    return null;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (_isAdding) {
      // Adding always needs a valid name — there's no "revert" concept for
      // an entry that doesn't exist yet.
      if (!isValid) return;
      _configEditingNotifier.add(_nameController.text, _textController.text);
    } else {
      if (!isValid && !_configEditingNotifier.shouldResetToDefault) return;
      _configEditingNotifier.save(_nameController.text, _textController.text);
    }

    Navigator.of(context).pop();
  }
}

String _defaultValueFor(ConfigValueType type) => switch (type) {
  ConfigValueType.boolean => 'false',
  ConfigValueType.number => '0',
  ConfigValueType.string => '',
  ConfigValueType.json => '{}',
};

class _AppBar extends StatelessWidget {
  final String title;
  final Function()? onSaveButtonPressed;

  const _AppBar({
    required this.title,
    this.onSaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RootAwareSliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Text(title),
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        TextButton(
          onPressed: onSaveButtonPressed,
          child: Text(LocalConfigLocalizations.of(context)!.save),
        ),
      ],
      centerTitle: false,
      pinned: true,
    );
  }
}

class _Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final FocusNode nameFocusNode;
  final TextEditingController typeController;
  final FocusNode typeFocusNode;
  final TextEditingController fieldTextController;
  final FocusNode valueFocusNode;
  final bool nameEditable;
  final String? Function(String?)? nameValidator;
  final ConfigValueType type;
  final bool typeEditable;

  final ConfigValue? configValue;
  final Function(String)? onSubmitted;
  final bool showEditingLocalValue;
  final Function(bool)? setShowEditingLocalValue;
  final bool shouldResetToDefault;
  final Function(bool)? setShouldResetToDefault;

  const _Form({
    required this.formKey,
    required this.nameController,
    required this.nameFocusNode,
    required this.typeController,
    required this.typeFocusNode,
    required this.fieldTextController,
    required this.valueFocusNode,
    this.nameEditable = false,
    this.nameValidator,
    required this.type,
    this.typeEditable = false,
    this.configValue,
    this.onSubmitted,
    this.showEditingLocalValue = false,
    this.setShowEditingLocalValue,
    this.shouldResetToDefault = false,
    this.setShouldResetToDefault,
  });

  bool get _hasDefault => configValue != null && !configValue!.isCustom;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              InputFormField(
                controller: nameController,
                focusNode: nameFocusNode,
                textStyle: context.extendedTextTheme.codeBodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withAlpha(nameEditable ? 255 : 97),
                ),
                label: Tooltip(
                  preferBelow: true,
                  showDuration: const Duration(seconds: 5),
                  triggerMode: TooltipTriggerMode.tap,
                  padding: const EdgeInsets.all(8),
                  richMessage: type.usageHint(
                    context,
                    name: nameController.text.isEmpty
                        ? 'name'
                        : nameController.text,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(LocalConfigLocalizations.of(context)!.parameterName),
                      const Icon(Icons.help_outline, size: 16),
                    ],
                  ),
                ),
                enabled: nameEditable,
                autofocus: nameEditable,
                textInputAction: nameEditable ? TextInputAction.next : null,
                onFieldSubmitted: nameEditable
                    ? (_) => FocusScope.of(context).requestFocus(
                        typeFocusNode,
                      )
                    : null,
                validator: nameEditable ? nameValidator : null,
              ),
              InputFormField(
                controller: typeEditable
                    ? typeController
                    : TextEditingController(
                        text: type.getDisplayName(context),
                      ),
                focusNode: typeFocusNode,
                entries: ConfigValueType.values.map((value) {
                  return DropdownMenuEntry(
                    value: value.getDisplayName(context),
                    label: value.getDisplayName(context),
                    leadingIcon: Icon(value.displayIcon),
                  );
                }).toList(),
                enabled: typeEditable,
                label: Text(
                  LocalConfigLocalizations.of(context)!.dataType,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              DashedLConnector(
                size: const Size(32, 72),
                entries: [
                  if (showEditingLocalValue)
                    DashedLEntry(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(
                            deleteIcon: shouldResetToDefault
                                ? Icon(Icons.add)
                                : Icon(Icons.close),
                            // There's nothing to revert to while adding a
                            // brand-new entry, so the delete affordance
                            // only makes sense once configValue exists.
                            onDeleted: configValue == null
                                ? null
                                : () {
                                    setShouldResetToDefault?.call(
                                      !shouldResetToDefault,
                                    );
                                  },
                            label: Text(
                              LocalConfigLocalizations.of(context)!.localValue,
                              style:
                                  TextTheme.of(
                                    context,
                                  ).bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    decoration: shouldResetToDefault
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                            ),
                            color: WidgetStatePropertyAll(
                              context.extendedColorScheme.warningContainer,
                            ),
                          ),
                          if (_hasDefault)
                            IconButton(
                              onPressed: () => _openDiff(context),
                              icon: const Icon(Icons.difference_outlined),
                              tooltip: LocalConfigLocalizations.of(
                                context,
                              )!.diff,
                            ),
                        ],
                      ),
                      value: ConfigValueField(
                        type: type,
                        controller: fieldTextController,
                        focusNode: valueFocusNode,
                        enabled: !shouldResetToDefault,
                        autofocus: !nameEditable,
                        onFieldSubmitted: onSubmitted,
                      ),
                    ),
                  if (_hasDefault)
                    DashedLEntry(
                      label: Text(
                        LocalConfigLocalizations.of(context)!.defaultValue,
                        style: TextTheme.of(context).bodyMedium,
                      ),
                      value: ConfigValueField(
                        type: type,
                        controller: TextEditingController(
                          text: configValue!.defaultValue,
                        ),
                        enabled: false,
                      ),
                    ),
                ],
              ),
              if (_hasDefault && !showEditingLocalValue)
                OutlinedButton.icon(
                  label: Text(LocalConfigLocalizations.of(context)!.localValue),
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setShowEditingLocalValue?.call(true);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDiff(BuildContext context) {
    final controller = type.textEditorController;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => DiffViewer(
          title: LocalConfigLocalizations.of(context)!.diff,
          oldValue: controller.prettify(configValue!.defaultValue),
          newValue: controller.prettify(fieldTextController.text),
        ),
      ),
    );
  }
}
