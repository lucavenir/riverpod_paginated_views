import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../domain/repositories/favorites_repository_interface.dart';

part 'favorites_provider.g.dart';

@riverpod
FutureOr<IList<Item>> favorites(FavoritesRef ref, int page) async {
  final repository = ref.watch(favoritesRepositoryProvider);
  final favorites = await repository.getFavorites(page: page);
  return favorites;
}
