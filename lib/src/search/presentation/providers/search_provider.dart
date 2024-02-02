import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../domain/repositories/search_repository_interface.dart';

part 'search_provider.g.dart';

@riverpod
Future<IList<Item>> search(SearchRef ref, int page) async {
  final repository = ref.watch(searchRepositoryProvider);
  final results = await repository.search(page);
  // ref.listenToFavoriteStateOf(results);
  return results;
}
