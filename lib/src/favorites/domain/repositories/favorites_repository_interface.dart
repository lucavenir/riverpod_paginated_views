import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../clients/isar_client.dart';
import '../../../items/domain/entities/item.dart';
import '../../../shared/domain/interfaces/repository_interface.dart';
import '../../data/repositories/favorites_repository.dart';

part 'favorites_repository_interface.g.dart';

@riverpod
FavoritesRepositoryInterface favoritesRepository(FavoritesRepositoryRef ref) {
  final db = ref.read(isarClientProvider.select((value) => value.requireValue));
  return FavoritesRepository(db);
}

abstract interface class FavoritesRepositoryInterface implements RepositoryInterface {
  Future<IList<Item>> getFavorites({required int page});
  Future<int> addFavorite(int item);
  Future<int> removeFavorite(int item);
}
