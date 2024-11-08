import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_local_config/widget/text_editor_screen.dart';
import 'package:firebase_local_config/local_config.dart';
import 'package:firebase_local_config/model/config_value.dart';

class LocalConfigScreen extends StatefulWidget {
  const LocalConfigScreen({
    super.key,
    required this.configs,
  });

  final List<MapEntry<String, ConfigValue>> configs;

  @override
  State<StatefulWidget> createState() => _LocalConfigScreenState();
}

class _LocalConfigScreenState extends State<LocalConfigScreen> {
  final _scrollController = ScrollController();

  List<MapEntry<String, ConfigValue>> _configs = [];

  @override
  void initState() {
    super.initState();
    _configs = widget.configs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const _AppBar(),
            _SearchBar(onChanged: _onSearchTextChanged),
            if (_configs.isEmpty)
              const _EmptyConfigList()
            else
              _ConfigList(configs: _configs)
          ],
        ),
      ),
    );
  }

  void _onSearchTextChanged(String searchText) {
    setState(() => _configs = _filterConfigsBy(searchText));
  }

  List<MapEntry<String, ConfigValue>> _filterConfigsBy(String text) {
    return text.isNotEmpty ? _filterConfigsContaining(text) : widget.configs;
  }

  List<MapEntry<String, ConfigValue>> _filterConfigsContaining(String text) {
    return widget.configs
        .where((config) => caseInsensitiveContains(config.key, text))
        .toList();
  }

  bool caseInsensitiveContains(String string, String substring) {
    return string.contains(RegExp(substring, caseSensitive: false));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      title: Text('Local Config'),
      centerTitle: false,
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({this.onChanged});

  final void Function(String)? onChanged;

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();

  bool isCloseVisible = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onChanged);
  }

  void _onChanged() {
    final searchText = _textController.text;
    widget.onChanged?.call(searchText);
    setState(() => isCloseVisible = searchText.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverHeaderDelegate(
        minHeight: 80,
        maxHeight: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Wrap(
            runAlignment: WrapAlignment.center,
            children: [
              SearchBar(
                padding:
                    const WidgetStatePropertyAll(EdgeInsets.only(left: 16)),
                hintText: 'Search',
                leading: const Icon(Icons.search),
                controller: _textController,
                trailing: [
                  if (isCloseVisible)
                    IconButton(
                      onPressed: () => _textController.clear(),
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.removeListener(_onChanged);
    _textController.dispose();
    super.dispose();
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _EmptyConfigList extends StatelessWidget {
  const _EmptyConfigList();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: Column(
          children: [
            Text(
              '( ╹ -╹)',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox.square(dimension: 16),
            Text(
              'There is nothing here.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfigList extends StatelessWidget {
  const _ConfigList({this.configs = const []});

  final List<MapEntry<String, ConfigValue>> configs;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: configs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final configEntry = configs[index];
        return _ConfigListTile(
          name: configEntry.key,
          value: configEntry.value,
        );
      },
    );
  }
}

class _ConfigListTile extends StatelessWidget {
  const _ConfigListTile({
    required this.name,
    required this.value,
  });

  final String name;
  final ConfigValue value;

  @override
  Widget build(BuildContext context) {
    final valueText = _textForValue(value);
    final typeIcon = _iconForType(value.type);

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16, right: 8),
      title: Text(name),
      subtitle: Text(valueText),
      leading: Icon(typeIcon),
      trailing: IconButton(
        onPressed: () async {
          await showConfigForm(context);
        },
        icon: const Icon(Icons.edit),
      ),
    );
  }

  Future<dynamic> showConfigForm(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return _ConfigForm(
          name: name,
          type: value.type,
          value: value.raw,
          presetValues: _presetValuesForType(value.type),
          inputAction: value.type.isText
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<Null>(
                        fullscreenDialog: true,
                        builder: (BuildContext context) {
                          return TextEditorScreen(initialValue: value.raw);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_full),
                )
              : null,
          onChanged: (value) {
            if (this.value.type == ConfigType.intType) {
              LocalConfig.instance.setInt(
                name,
                int.tryParse(value) ?? 0,
              );
            }

            if (this.value.type == ConfigType.doubleType) {
              LocalConfig.instance.setDouble(
                name,
                double.tryParse(value) ?? 0,
              );
            }

            if (this.value.type == ConfigType.stringType ||
                this.value.type == ConfigType.jsonType) {
              LocalConfig.instance.setString(
                name,
                value,
              );
            }
          },
          validator: (value) {
            if (this.value.type == ConfigType.intType &&
                value != null &&
                int.tryParse(value) == null) {
              return 'Invalid integer.';
            }

            if (this.value.type == ConfigType.doubleType &&
                value != null &&
                double.tryParse(value) == null) {
              return 'Invalid double.';
            }

            return null;
          },
        );
      },
    );
  }
}

class _ConfigForm extends StatefulWidget {
  const _ConfigForm({
    required this.name,
    required this.type,
    required this.value,
    this.onChanged,
    this.inputAction,
    this.validator,
    this.presetValues = const [],
  });

  final String name;
  final ConfigType type;
  final String value;
  final Widget? inputAction;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final List<String> presetValues;

  @override
  State<StatefulWidget> createState() => _ConfigFormState();
}

class _ConfigFormState extends State<_ConfigForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _controller.text = _value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQueryData.fromView(View.of(context)).padding.bottom +
              MediaQuery.of(context).viewInsets.bottom),
      child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(_iconForType(widget.type)),
                  const SizedBox.square(dimension: 4),
                  Text(
                    _textForType(widget.type),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Form(
                  key: _formKey,
                  child: widget.presetValues.isEmpty
                      ? TextFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            border: const OutlineInputBorder(),
                            suffixIcon: widget.inputAction,
                          ),
                          controller: _controller,
                          autovalidateMode: AutovalidateMode.always,
                          validator: widget.validator,
                        )
                      : DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField<String>(
                                isDense: false,
                                itemHeight: 48,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  suffixIcon: widget.inputAction,
                                  contentPadding:
                                      const EdgeInsets.only(right: 4),
                                ),
                                items: widget.presetValues.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: _value,
                                onChanged: (value) {
                                  _controller.text = value ?? _value;
                                }),
                          ),
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.text = _value;
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox.square(dimension: 8),
                  FilledButton(
                    onPressed: () {
                      if (!(_formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      onChanged(_controller.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              )
            ],
          )),
    );
  }

  void onChanged(String value) {
    setState(() => _value = value);
    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

List<String> _presetValuesForType(ConfigType type) {
  switch (type) {
    case ConfigType.boolType:
      return ['false', 'true'];
    default:
      return [];
  }
}

String _textForValue(ConfigValue value) {
  switch (value.type) {
    case ConfigType.stringType:
      return value.raw.isNotEmpty ? value.raw : '(empty string)';
    default:
      return value.raw;
  }
}

String _textForType(ConfigType type) {
  switch (type) {
    case ConfigType.boolType:
      return 'bool';
    case ConfigType.intType:
      return 'int';
    case ConfigType.doubleType:
      return 'double';
    case ConfigType.stringType:
      return 'String';
    case ConfigType.jsonType:
      return 'JSON';
  }
}

IconData _iconForType(ConfigType type) {
  switch (type) {
    case ConfigType.boolType:
      return Icons.toggle_on;
    case ConfigType.intType:
    case ConfigType.doubleType:
      return Icons.onetwothree;
    case ConfigType.stringType:
      return Icons.abc;
    case ConfigType.jsonType:
      return Icons.data_object;
  }
}
