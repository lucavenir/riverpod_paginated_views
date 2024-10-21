import 'package:riverpod_annotation/riverpod_annotation.dart';

extension RefUpdateExtension<T> on AutoDisposeFutureProviderRef<T> {
  Future<T> update(
    FutureOr<T> Function(T) cb, {
    FutureOr<T> Function(Object err, StackTrace stackTrace)? onError,
  }) async {
    final newState = await future.then(cb, onError: onError);
    state = AsyncData<T>(newState);
    return newState;
  }
}
