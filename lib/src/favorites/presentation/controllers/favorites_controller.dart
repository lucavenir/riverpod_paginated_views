import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../domain/repositories/favorites_repository_interface.dart';

part 'favorites_controller.g.dart';

@riverpod
class FavoritesController extends _$FavoritesController {
  late FavoritesRepositoryInterface _repository;

  @override
  FutureOr<IList<Item>> build() {
    initRepo();
    return _repository.getFavorites(page: 0);
  }

  @protected
  void initRepo() {
    _repository = ref.watch(favoritesRepositoryProvider);
  }

  Future<void> addPage() async {
    throw UnimplementedError();
  }

  /// Adds the given [item] to the favorites.
  /// Triggers a side effect to add the favorite and updates the state accordingly.
  Future<int> addFavorite(Item item) async {
    final state = await future;
    assert(
      !state.contains(item),
      "State mustn't have this item as a favorite to add it to the favorites",
    );
    assert(item.isNotFavorite, 'Item must not *be* favorite to add it to the favorites');

    final favoriteId = await _repository.addFavorite(item);
    await update((state) => [item.copyWith(favoriteId: favoriteId), ...state].lock);
    return favoriteId;
  }

  /// Removes the given [item] from the favorites.
  /// Triggers a side effect to remove the favorite and updates the state accordingly.
  Future<int> removeFavorite(Item item) async {
    final state = await future;
    assert(
      state.contains(item),
      'State must have this item as a favorite to remove it from the favorites',
    );
    assert(item.isFavorite, 'Item must be favorite to remove it from the favorites');

    final favoriteId = await _repository.removeFavorite(item);
    await update((state) => [...state.where((element) => element.id != item.id)].lock);
    return favoriteId;
  }
}
