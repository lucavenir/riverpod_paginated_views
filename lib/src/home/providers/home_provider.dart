import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../api/items.api.dart';
import '../../favorites/controllers/favorites_ovverride_controller.dart';
import '../../items/models/item.dart';

part 'home_provider.g.dart';

@riverpod
FutureOr<IList<Item>> home(HomeRef ref, int page) async {
  final repo = await ref.watch(itemsApiProvider.future);
  final items = await repo.home(page: page);
  ref.read(favoritesOverrideControllerProvider.notifier).set(items);
  return items;
}
