import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../controllers/favorites_controller.dart';

// ignore: invalid_use_of_internal_member
mixin WithFavoritesMixin implements BuildlessAutoDisposeAsyncNotifier<List<Item>> {
  /// Toggles the favorite status of the given [favorite].
  Future<void> toggleFavorite(Item favorite) {
    return favorite.isFavorite ? removeFavorite(favorite) : addFavorite(favorite);
  }

  /// Adds the given [item] to the favorites.
  /// Triggers a side effect to add the favorite and updates the state accordingly.
  @protected
  Future<int> addFavorite(Item item) async {
    assert(item.isNotFavorite, 'Item must not be favorite to add it to the favorites');

    final favoriteId = await ref.read(favoritesControllerProvider.notifier).addFavorite(item);
    await update((state) {
      return [
        ...state.map((f) => f.id == item.id ? f.copyWith(favoriteId: favoriteId) : f),
      ];
    });
    return favoriteId;
  }

  /// Removes the given [item] from the favorites.
  /// Triggers a side effect to remove the favorite and updates the state accordingly.
  @protected
  Future<int> removeFavorite(Item item) async {
    assert(item.isFavorite, 'Item must be favorite to remove it from the favorites');

    final favoriteId = await ref.read(favoritesControllerProvider.notifier).removeFavorite(item);
    await update((state) {
      return [
        ...state.map((f) => f.id == item.id ? f.copyWith(favoriteId: null) : f),
      ];
    });
    return favoriteId;
  }
}
