import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../../shared/presentation/logic/ref_update.dart';
import '../controllers/favorites_controller.dart';

extension ListenToFavoritesAndUpdateAccordinglyRefExtension
    on AutoDisposeFutureProviderRef<IList<Item>> {
  void listenToFavoritesAndUpdateAccordingly() {
    final favoriteSubscription = listen(favoritesControllerProvider, (previous, next) async {
      final nextSet = next.valueOrNull?.toISet();
      final prevSet = previous?.valueOrNull?.toISet();
      if (nextSet == null || prevSet == null || nextSet == prevSet) return;

      final current = await future.then((value) => value.toISet());
      final removed = prevSet.difference(nextSet);
      final added = nextSet.difference(prevSet);

      await _updateOnFavoriteAdded(added, current);
      await _updateOnFavoriteRemoved(removed, current);
    });
    onDispose(favoriteSubscription.close);
  }

  Future<void> _updateOnFavoriteAdded(ISet<Item> added, ISet<Item> current) async {
    final addedInHere = added.intersection(current);
    if (addedInHere.isEmpty) return;
    await update(
      (state) => [
        ...state.map(
          (e) => switch (added.lookup(e)) {
            Item(:final favoriteId?) => e.copyWith(favoriteId: favoriteId),
            _ => e,
          },
        ),
      ].lock,
    );
  }

  Future<void> _updateOnFavoriteRemoved(ISet<Item> removed, ISet<Item> current) async {
    final removedFromHere = removed.intersection(current);
    if (removedFromHere.isEmpty) return;
    await update(
      (state) => [
        ...state.map((e) => removedFromHere.contains(e) ? e.copyWith(favoriteId: null) : e),
      ].lock,
    );
  }
}
