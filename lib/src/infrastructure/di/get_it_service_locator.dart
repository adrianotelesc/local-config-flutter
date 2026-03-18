import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:local_config/src/core/di/service_locator.dart';

class GetItServiceLocator implements ServiceLocator {
  final GetIt _getIt = GetIt.I;

  @override
  FutureOr<dynamic> resetLazySingleton<T extends Object>({
    T? instance,
    String? tag,
    FutureOr<dynamic> Function(T)? dispose,
  }) => _getIt.resetLazySingleton(
    instance: instance,
    instanceName: tag,
    disposingFunction: dispose,
  );

  @override
  FutureOr<dynamic> unregister<T extends Object>({
    Object? instance,
    String? tag,
    FutureOr<dynamic> Function(T)? dispose,
  }) => _getIt.unregister<T>(
    instance: instance,
    instanceName: tag,
    disposingFunction: dispose,
  );

  @override
  T get<T extends Object>({String? tag}) => _getIt.get<T>(instanceName: tag);

  @override
  void registerFactory<T extends Object>(T Function() factory, {String? tag}) =>
      _getIt.registerFactory<T>(factory, instanceName: tag);

  @override
  void registerLazySingleton<T extends Object>(
    T Function() factory, {
    String? tag,
    FutureOr<dynamic> Function(T)? dispose,
  }) => _getIt.registerLazySingleton<T>(
    factory,
    instanceName: tag,
    dispose: dispose,
  );
}
