import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../api/items.api.dart';
import '../../favorites/controllers/favorites_ovverride_controller.dart';
import '../../items/models/item.dart';

part 'search_provider.g.dart';

@riverpod
Future<IList<Item>> search(SearchRef ref, {required String q, required int page}) async {
  final repository = await ref.watch(itemsApiProvider.future);
  final results = await repository.search(page: page, q: q);
  ref.read(favoritesOverrideControllerProvider.notifier).set(results);
  return results;
}
