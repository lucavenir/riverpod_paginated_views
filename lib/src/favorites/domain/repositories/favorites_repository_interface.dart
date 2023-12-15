import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/favorites_repository.dart';
import '../entities/favorites.dart';

part 'favorites_repository_interface.g.dart';

@riverpod
FavoritesRepositoryInterface favoritesRepository(FavoritesRepositoryRef ref) {
  return const FavoritesRepository();
}

abstract interface class FavoritesRepositoryInterface {
  Future<Favorites> getFavorites({required int page});
  Future<int> addFavorite(int id);
  Future<int> removeFavorite(int id);
}
