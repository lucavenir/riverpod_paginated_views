import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/search.dart';
import '../../domain/repositories/search_repository_interface.dart';

part 'search_controller.g.dart';

@riverpod
final class SearchController extends _$SearchController {
  late SearchRepositoryInterface _repository;

  @override
  Search build() {
    _repository = ref.watch(searchRepositoryProvider);
    return _repository.getSearch();
  }
}
