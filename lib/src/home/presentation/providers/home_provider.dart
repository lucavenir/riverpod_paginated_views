import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../favorites/presentation/logic/listen_to_favorites_and_update_accordingly.dart';
import '../../../items/domain/entities/item.dart';
import '../../../items/domain/repositories/items_repository_interface.dart';

part 'home_provider.g.dart';

@riverpod
FutureOr<IList<Item>> home(HomeRef ref, int page) {
  final repo = ref.watch(itemsRepositoryProvider);
  ref.listenToFavoritesAndUpdateAccordingly();

  return repo.fetchItems(page: page);
}
