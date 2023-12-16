import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../../shared/domain/interfaces/fn1.dart';

// ignore: invalid_use_of_internal_member
mixin WithFavoritesMixin on BuildlessAutoDisposeAsyncNotifier<List<Item>> {
  @protected
  Fn1<int, Future<int>> get addFavoriteCallback;
  @protected
  Fn1<int, Future<int>> get removeFavoriteCallback;

  /// Toggles the favorite status of the given [favorite].
  Future<void> toggleFavorite(Item favorite) {
    return favorite.isFavorite ? removeFavorite(favorite) : addFavorite(favorite);
  }

  /// Adds the given [favorite] to the favorites.
  /// Triggers a side effect to add the favorite and updates the state accordingly.
  @protected
  Future<void> addFavorite(Item favorite) {
    assert(favorite.isNotFavorite, 'Item must not be favorite to add it to the favorites');

    return update((state) async {
      final favoriteId = await addFavoriteCallback(favorite.id);
      return [
        ...state,
        favorite.copyWith(favoriteId: favoriteId),
      ];
    });
  }

  /// Removes the given [favorite] from the favorites.
  /// Triggers a side effect to remove the favorite and updates the state accordingly.
  @protected
  Future<void> removeFavorite(Item favorite) {
    assert(favorite.isFavorite, 'Item must be favorite to remove it from the favorites');

    return update((state) async {
      final _ = await removeFavoriteCallback(favorite.favoriteId!);
      return [
        ...state.where((f) => f.favoriteId != favorite.favoriteId),
      ];
    });
  }
}
