import 'dart:async';

import 'package:local_config/model/config.dart';
import 'package:local_config/storage/key_value_store.dart';

class ConfigRepository {
  final KeyValueStore _store;
  final _configs = <String, Config>{};
  final _controller = StreamController<Map<String, Config>>();

  ConfigRepository({
    required KeyValueStore store,
  }) : _store = store;

  Map<String, Config> get configs => _configs;

  Stream<Map<String, Config>> get stream => _controller.stream;

  Future<void> initialize({
    Map<String, String> all = const <String, String>{},
  }) async {
    _configs.addAll(
      all.map((key, value) => MapEntry(key, Config(value: value))),
    );

    final storeAll = await _store.all;
    for (final storeEntry in storeAll.entries) {
      final config = _configs[storeEntry.key];
      if (config == null) {
        await _store.remove(storeEntry.key);
        continue;
      }
      _configs[storeEntry.key] = config.copyWith(
        changedValue: storeEntry.value,
      );
    }

    _controller.add(_configs);
  }

  Future<Config?> get(String key) async => _configs[key];

  Future<void> set(String key, String value) async {
    final config = _configs[key];
    if (config == null) return;
    _configs[key] = config.copyWith(changedValue: value);
    _controller.add(_configs);
    await _store.set(key, value);
  }

  Future<void> remove(String key) async {
    final config = _configs[key];
    if (config == null) return;
    _configs[key] = config.copyWith(changedValue: null);
    _controller.add(_configs);
    await _store.remove(key);
  }

  Future<void> removeAll() async {
    final configs = Map<String, Config>.from(_configs);
    _configs.clear();
    _configs.addAll(configs.map(
      (key, value) => MapEntry(key, value.copyWith(changedValue: null)),
    ));
    _controller.add(_configs);
    await _store.clear();
  }
}
