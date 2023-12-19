import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../domain/repositories/favorites_repository_interface.dart';
import '../logic/listen_to_favorite_state_of.dart';

part 'favorites_provider.g.dart';

// How can I inject `page` for this provider, so that I can paginate this without having to manually call `addPage`?
@riverpod
FutureOr<IList<Item>> favorites(FavoritesRef ref, int page) async {
  final repository = ref.watch(favoritesRepositoryProvider);

  final favorites = await repository.getFavorites(page: page);
  ref.listenToFavoriteStateOf(favorites);

  return favorites;
}
