import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../../shared/domain/interfaces/repository_interface.dart';
import '../../data/repositories/search_repository.dart';

part 'search_repository_interface.g.dart';

@riverpod
SearchRepositoryInterface searchRepository(SearchRepositoryRef ref) {
  return const SearchRepository();
}

abstract interface class SearchRepositoryInterface implements RepositoryInterface {
  Future<IList<Item>> search(int page);
}
