import 'package:flutter/material.dart';

class TextInputListTileWidget extends StatefulWidget {
  const TextInputListTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isNumeric,
    this.leadingIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
  });

  final String title;
  final String subtitle;
  final String value;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final bool isNumeric;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;

  @override
  State<StatefulWidget> createState() => _TextInputListTileWidgetState();
}

class _TextInputListTileWidgetState extends State<TextInputListTileWidget> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _textController.text = _value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(widget.title),
        leading: widget.leadingIcon,
        trailing: Text(_value.isNotEmpty ? _value : '(empty string)'),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom:
                      MediaQueryData.fromView(View.of(context)).padding.bottom +
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
                        widget.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.leadingIcon != null
                              ? widget.leadingIcon!
                              : const SizedBox.shrink(),
                          const SizedBox.square(dimension: 4),
                          Text(
                            widget.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              suffixIcon: widget.suffixIcon,
                            ),
                            controller: _textController,
                            autovalidateMode: AutovalidateMode.always,
                            validator: widget.validator,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _textController.text = _value;
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox.square(dimension: 8),
                          FilledButton(
                            onPressed: () {
                              if (!(_formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              onChanged(_textController.text);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      )
                    ],
                  )),
            );
          },
        ).whenComplete(() {
          _textController.text = _value;
        });
      },
    );
  }

  void onChanged(String value) {
    setState(() => _value = value);
    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}
