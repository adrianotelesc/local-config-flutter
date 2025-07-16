abstract final class ServiceLocator {
  static final _instances = <Type, Object>{};

  static void register<T extends Object>(T instance) {
    _instances[instance.runtimeType] = instance;
  }

  static T get<T>() {
    final instance = _instances[T];
    if (instance == null) {
      throw StateError('Service of type ${T.runtimeType} not registered.');
    }
    return instance as T;
  }

  static void reset() {
    _instances.clear();
  }
}
