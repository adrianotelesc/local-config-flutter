import 'dart:async';

abstract class ServiceLocator {
  void registerLazySingleton<T extends Object>(
    T Function() factory, {
    String? tag,
    FutureOr Function(T)? dispose,
  });

  void registerFactory<T extends Object>(T Function() factory, {String? tag});

  FutureOr unregister<T extends Object>({
    Object? instance,
    String? tag,
    FutureOr Function(T)? dispose,
  });

  T get<T extends Object>({String? tag});

  FutureOr<dynamic> resetLazySingleton<T extends Object>({
    T? instance,
    String? tag,
    FutureOr<dynamic> Function(T)? dispose,
  });
}
