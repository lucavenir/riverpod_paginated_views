import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../../shared/presentation/logic/ref_update.dart';
import '../controllers/is_favorite_controller.dart';

extension ListenToFavoriteStateOfExt on AutoDisposeFutureProviderRef<IList<Item>> {
  void listenToFavoriteStateOf(IList<Item> items) {
    for (final item in items) {
      final sub = listen(isFavoriteControllerProvider(item.id), (_, next) {
        if (next case AsyncData(:final value)) {
          update(
            (state) => [
              ...state.map(
                (element) => element.id == value ? element.copyWith(favoriteId: value) : element,
              ),
            ].lock,
          );
        }
      });
      try {
        onDispose(sub.close);
      } catch (_) {}
    }
  }
}
