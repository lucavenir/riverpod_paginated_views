import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../clients/isar_client.dart';

part 'loading_provider.g.dart';

@riverpod
FutureOr<void> loading(LoadingRef ref) {
  return ref.watch(isarClientProvider.future);
}
