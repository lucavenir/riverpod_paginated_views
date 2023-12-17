import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../domain/repositories/search_repository_interface.dart';

part 'search_provider.g.dart';

@riverpod
Future<List<Item>> search(SearchRef ref, int page) async {
  final repository = ref.watch(searchRepositoryProvider);
  return repository.getSearch();
}
