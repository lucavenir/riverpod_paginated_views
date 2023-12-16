import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../data/repositories/search_repository.dart';

part 'search_repository_interface.g.dart';

@riverpod
SearchRepositoryInterface searchRepository(SearchRepositoryRef ref) {
  return const SearchRepository();
}

abstract interface class SearchRepositoryInterface {
  List<Item> getSearch();
}
