import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../data/repositories/favorites_repository.dart';

part 'favorites_repository_interface.g.dart';

@riverpod
FavoritesRepositoryInterface favoritesRepository(FavoritesRepositoryRef ref) {
  return const FavoritesRepository();
}

abstract interface class FavoritesRepositoryInterface {
  Future<List<Item>> getFavorites({required int page});
  Future<int> addFavorite(Item item);
  Future<int> removeFavorite(Item item);
}
