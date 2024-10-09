import 'dart:convert';

import 'package:firebase_local_config/local_config.dart';
import 'package:firebase_local_config/model/config_value.dart';
import 'package:flutter/material.dart';

class DataObjectConfigWidget extends StatefulWidget {
  const DataObjectConfigWidget({
    super.key,
    required this.configKey,
    required this.configValue,
  });

  final String configKey;
  final ConfigValue configValue;

  @override
  State<StatefulWidget> createState() => _DataObjectConfigWidgetState();
}

class _DataObjectConfigWidgetState extends State<DataObjectConfigWidget> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.configValue.value;
    _textController.text = prettify(jsonDecode(_value));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(widget.configKey),
        leading: const Icon(Icons.data_object),
        trailing: Text(_value),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.configKey),
                  TextButton(
                    onPressed: () {
                      _textController.text =
                          prettify(jsonDecode(_textController.text));
                    },
                    child: const Text('Format'),
                  ),
                ],
              ),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  maxLines: null,
                  controller: _textController,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    try {
                      prettify(jsonDecode(_textController.text));
                    } on FormatException catch (_) {
                      return 'Invalid JSON.';
                    }

                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _textController.text = prettify(jsonDecode(_value));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    onChanged(unprettify(jsonDecode(_textController.text)));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String prettify(dynamic json) {
    var spaces = ' ' * 4;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }

  String unprettify(dynamic json) {
    var encoder = const JsonEncoder();
    return encoder.convert(json);
  }

  void onChanged(String value) {
    setState(() {
      _value = value;
    });
    LocalConfig.instance.setString(widget.configKey, _value);
  }
}
