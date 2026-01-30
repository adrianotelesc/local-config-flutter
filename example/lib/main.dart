import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_config/local_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocalConfig.instance.initialize(
    parameters: {
      'social_login_enabled': false,
      'timeout_ms': 8000,
      'animation_speed': 1.25,
      'api_base_url': 'https://api.myapp.com/v1',
      "checkout": {
        "payment_methods": {
          "allowed": ["credit_card", "pix", "boleto"],
          "default": "credit_card",
        },
        "installments": {
          "enabled": false,
          "rules": [
            {"max_installments": 3, "min_order_value": 0},
            {"max_installments": 6, "min_order_value": 100},
            {"max_installments": 10, "min_order_value": 300},
          ],
        },
      },
    },
    keyValueStore: SecureStorageKeyValueStore(
      secureStorage: const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    ),
  );

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  static const title = 'Local Config Example';

  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const ExamplePage(title: title),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key, required this.title});

  final String title;

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  Map<String, dynamic> _configs = {};
  StreamSubscription? _configSub;

  @override
  void initState() {
    super.initState();
    _configSub = LocalConfig.instance.onConfigUpdated.listen((configs) {
      setState(() => _configs = configs);
    });
  }

  @override
  void dispose() {
    _configSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actionsPadding: EdgeInsets.all(8),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LocalConfig.instance.entrypoint,
                ),
              );
            },
            tooltip: 'Local Config',
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _configs.length,
        itemBuilder: (context, index) {
          final key = _configs.keys.elementAt(index);
          final value = _configs[key];

          return ListTile(
            title: Text(key),
            subtitle: Text(value?.toString() ?? 'null'),
          );
        },
      ),
    );
  }
}
