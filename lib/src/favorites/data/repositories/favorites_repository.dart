import '../../domain/entities/favorites.dart';
import '../../domain/repositories/favorites_repository_interface.dart';

final class FavoritesRepository implements FavoritesRepositoryInterface {
  const FavoritesRepository();

  @override
  Future<Favorites> getFavorites({required int page}) {
    throw UnimplementedError('TODO: add repository logic in here');
  }

  @override
  Future<int> addFavorite(int id) {
    throw UnimplementedError();
  }

  @override
  Future<int> removeFavorite(int id) {
    throw UnimplementedError();
  }
}
