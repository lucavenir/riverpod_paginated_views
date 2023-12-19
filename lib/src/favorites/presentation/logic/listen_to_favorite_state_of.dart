import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../../items/presentation/controllers/item_controller.dart';
import '../../../shared/presentation/logic/ref_update.dart';

extension ListenToFavoriteStateOfExt on AutoDisposeFutureProviderRef<IList<Item>> {
  void listenToFavoriteStateOf(IList<Item> items) {
    for (final item in items) {
      final sub = listen(itemControllerProvider(item.id), (_, next) {
        if (next case AsyncData(:final value)) {
          update(
            (state) => [
              ...state.map(
                (element) => element.id == value.id
                    ? element.copyWith(favoriteId: value.favoriteId)
                    : element,
              ),
            ].lock,
          );
        }
      });
      onDispose(sub.close);
    }
  }
}
