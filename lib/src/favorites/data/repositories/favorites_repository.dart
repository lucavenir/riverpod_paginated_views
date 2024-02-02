import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:isar/isar.dart';

import '../../../items/domain/entities/item.dart';
import '../../../shared/presentation/constants/page_size.dart';
import '../../domain/repositories/favorites_repository_interface.dart';

final class FavoritesRepository implements FavoritesRepositoryInterface {
  const FavoritesRepository(this.db);
  final Isar db;

  @override
  Future<IList<Item>> getFavorites({required int page}) async {
    final result = await db.items
        .where()
        .favoriteIdIsNotNull()
        .findAllAsync(offset: page * pageSize, limit: pageSize);
    return result.lock;
  }

  @override
  Future<int> addFavorite(Item item) async {
    final nextId = Random().nextInt(1 << 16);
    await db.writeAsync(
      (isar) => isar.items.update(
        id: item.id,
        favoriteId: nextId,
        isFavorite: true,
        isNotFavorite: false,
      ),
    );
    return nextId;
  }

  @override
  Future<int> removeFavorite(Item item) async {
    await db.writeAsync(
      (isar) => isar.items.update(
        id: item.id,
        // ignore: avoid_redundant_argument_values
        favoriteId: null,
        isFavorite: false,
        isNotFavorite: true,
      ),
    );

    return item.id;
  }
}
