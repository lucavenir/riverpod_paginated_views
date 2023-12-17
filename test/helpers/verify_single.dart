import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';

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
