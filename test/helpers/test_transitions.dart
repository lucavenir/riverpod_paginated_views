import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class ProviderTransitionsTester<T> extends Mock {
  void call(T? previous, T value);
}

extension SetUpListener on ProviderContainer {
  ProviderTransitionsTester<T> testTransitionsOn<T>(
    ProviderListenable<T> provider, {
    bool fireImmediately = true,
  }) {
    final listener = ProviderTransitionsTester<T>();
    final subscription = listen(provider, listener.call, fireImmediately: fireImmediately);
    addTearDown(subscription.close);
    return listener;
  }
}

/// Syntax sugar for:
///
/// ```dart
/// verify(mock()).called(1);
/// verifyNoMoreInteractions(mock);
/// ```
VerificationResult verifySingle<T>(Mock mock, ValueGetter<T> invocation) {
  final result = verify(invocation)..called(1);
  verifyNoMoreInteractions(mock);
  return result;
}
