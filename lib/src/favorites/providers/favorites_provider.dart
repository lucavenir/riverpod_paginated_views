import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../api/items.api.dart';
import '../../items/models/item.dart';
import '../controllers/favorites_ovverride_controller.dart';

part 'favorites_provider.g.dart';

@riverpod
FutureOr<IList<Item>> favorites(FavoritesRef ref, int page) async {
  final api = await ref.watch(itemsApiProvider.future);
  final favorites = await api.favorites(page: page);
  ref.read(favoritesOverrideControllerProvider.notifier).set(favorites);
  return favorites;
}
