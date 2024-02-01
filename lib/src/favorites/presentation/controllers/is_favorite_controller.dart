import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/favorites_repository_interface.dart';
import '../providers/favorites_provider.dart';

part 'is_favorite_controller.g.dart';

@riverpod
class IsFavoriteController extends _$IsFavoriteController {
  @protected
  late FavoritesRepositoryInterface favoritesRepository;
  @override
  FutureOr<int?> build(int id) async {
    favoritesRepository = ref.watch(favoritesRepositoryProvider);
    final favorites = await ref.watch(favoritesProvider(0).future);
    final favorite = favorites.firstWhereOrNull((element) => element.id == id);
    return favorite?.favoriteId;
  }

  Future<void> toggle() {
    return future.then((state) => state == null ? addFavorite() : removeFavorite());
  }

  /// Adds this item to the favorites.
  @protected
  Future<void> addFavorite() async {
    await update((state) async {
      assert(state == null, 'Item *must not* be a favorite to add it to the favorites');

      final favoriteId = await favoritesRepository.addFavorite(id);
      return favoriteId;
    });
    ref.invalidate(favoritesProvider);
  }

  /// Removes this item from the favorites.
  @protected
  Future<void> removeFavorite() async {
    await update((state) async {
      assert(state != null, 'Item *must* be favorite to remove it from the favorites');

      final _ = await favoritesRepository.removeFavorite(id);
      return null;
    });
    ref.invalidate(favoritesProvider);
  }
}
