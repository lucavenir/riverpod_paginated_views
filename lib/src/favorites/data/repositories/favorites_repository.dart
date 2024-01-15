import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../../items/domain/entities/item.dart';
import '../../../shared/domain/interfaces/repository_mixin.dart';
import '../../domain/repositories/favorites_repository_interface.dart';

final class FavoritesRepository
    with RepositoryInterfaceMixin
    implements FavoritesRepositoryInterface {
  const FavoritesRepository();

  @override
  Future<IList<Item>> getFavorites({required int page}) => randomItems(page, favoritesOnly: true);

  @override
  Future<int> addFavorite(Item item) async => Random().nextInt(1 << 16);

  @override
  Future<int> removeFavorite(Item item) async => item.favoriteId!;
}
