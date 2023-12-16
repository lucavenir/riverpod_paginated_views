import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../../shared/domain/interfaces/fn1.dart';

// ignore: invalid_use_of_internal_member
mixin WithFavoritesMixin on BuildlessAutoDisposeAsyncNotifier<List<Item>> {
  @protected
  Fn1<Item, Future<int>> get addFavoriteCallback;
  @protected
  Fn1<Item, Future<int>> get removeFavoriteCallback;

  /// Toggles the favorite status of the given [favorite].
  Future<void> toggleFavorite(Item favorite) {
    return favorite.isFavorite ? removeFavorite(favorite) : addFavorite(favorite);
  }

  /// Adds the given [favorite] to the favorites.
  /// Triggers a side effect to add the favorite and updates the state accordingly.
  @protected
  Future<int> addFavorite(Item favorite) async {
    assert(favorite.isNotFavorite, 'Item must not be favorite to add it to the favorites');

    final favoriteId = await addFavoriteCallback(favorite);
    await update((state) async {
      return [
        ...state,
        favorite.copyWith(favoriteId: favoriteId),
      ];
    });
    return favoriteId;
  }

  /// Removes the given [favorite] from the favorites.
  /// Triggers a side effect to remove the favorite and updates the state accordingly.
  @protected
  Future<int> removeFavorite(Item favorite) async {
    assert(favorite.isFavorite, 'Item must be favorite to remove it from the favorites');

    final favoriteId = await removeFavoriteCallback(favorite);
    await update((state) async {
      return [
        ...state.where((f) => f.favoriteId != favorite.favoriteId),
      ];
    });
    return favoriteId;
  }
}
