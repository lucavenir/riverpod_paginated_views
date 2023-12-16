import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../favorites/presentation/logic/with_favorites_mixin.dart';
import '../../../items/domain/entities/item.dart';
import '../../domain/repositories/search_repository_interface.dart';

part 'search_controller.g.dart';

@riverpod
final class SearchController extends _$SearchController with WithFavoritesMixin {
  late SearchRepositoryInterface _repository;

  @override
  Future<List<Item>> build(int page) async {
    _repository = ref.watch(searchRepositoryProvider);
    return _repository.getSearch();
  }
}
