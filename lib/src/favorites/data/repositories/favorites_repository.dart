import '../../domain/entities/favorites.dart';
import '../../domain/repositories/favorites_repository_interface.dart';

final class FavoritesRepository implements FavoritesRepositoryInterface {
  const FavoritesRepository();

  @override
  Favorites getFavorites() {
    throw UnimplementedError('TODO: add repository logic in here');
  }
}
