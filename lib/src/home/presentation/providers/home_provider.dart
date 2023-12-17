import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../favorites/presentation/logic/listen_favorites_and_update.dart';
import '../../../items/domain/entities/item.dart';
import '../../../items/domain/repositories/items_repository_interface.dart';

part 'home_provider.g.dart';

@riverpod
FutureOr<List<Item>> home(HomeRef ref, int page) {
  final repo = ref.watch(itemsRepositoryProvider);
  ref.listenFavoritesAndUpdate();

  return repo.fetchItems(page: page);
}
