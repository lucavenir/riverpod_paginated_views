import '../../../items/domain/entities/item.dart';
import '../../domain/repositories/favorites_repository_interface.dart';

final class FavoritesRepository implements FavoritesRepositoryInterface {
  const FavoritesRepository();

  @override
  Future<List<Item>> getFavorites({required int page}) {
    throw UnimplementedError('TODO: add repository logic in here');
  }

  @override
  Future<int> addFavorite(Item item) {
    throw UnimplementedError();
  }

  @override
  Future<int> removeFavorite(Item item) {
    throw UnimplementedError();
  }
}
