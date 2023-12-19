import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../favorites/domain/repositories/favorites_repository_interface.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/items_repository_interface.dart';

part 'item_controller.g.dart';

@riverpod
class ItemController extends _$ItemController {
  @protected
  late ItemsRepositoryInterface itemsRepository;
  @protected
  late FavoritesRepositoryInterface favoritesRepository;
  @override
  FutureOr<Item> build(int id) {
    itemsRepository = ref.watch(itemsRepositoryProvider);
    favoritesRepository = ref.watch(favoritesRepositoryProvider);
    return itemsRepository.getDetails(id: id);
  }

  Future<void> toggle() {
    return future.then((state) => state.isFavorite ? removeFavorite() : addFavorite());
  }

  /// Adds this item to the favorites.
  @protected
  Future<void> addFavorite() {
    return update((state) async {
      assert(state.isNotFavorite, 'Item *must not* be a favorite to add it to the favorites');

      final favoriteId = await favoritesRepository.addFavorite(state);
      return state.copyWith(favoriteId: favoriteId);
    });
  }

  /// Removes this item from the favorites.
  @protected
  Future<void> removeFavorite() {
    return update((state) async {
      assert(state.isFavorite, 'Item *must* be favorite to remove it from the favorites');

      final _ = await favoritesRepository.removeFavorite(state);
      return state.copyWith(favoriteId: null);
    });
  }
}
