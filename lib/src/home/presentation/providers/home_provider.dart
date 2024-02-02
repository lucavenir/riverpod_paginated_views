import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../../items/domain/repositories/items_repository_interface.dart';

part 'home_provider.g.dart';

@riverpod
FutureOr<IList<Item>> home(HomeRef ref, int page) async {
  final repo = ref.watch(itemsRepositoryProvider);
  final items = await repo.fetchItems(page: page);
  // ref.listenToFavoriteStateOf(items);
  return items;
}
