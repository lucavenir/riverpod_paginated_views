import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../favorites/presentation/controllers/favorites_controller.dart';
import '../../../favorites/presentation/logic/favorite_controller_mixin.dart';
import '../../../items/domain/entities/item.dart';
import '../../../shared/domain/interfaces/fn1.dart';
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

  @override
  @protected
  Fn1<Item, Future<int>> get addFavoriteCallback =>
      ref.read(favoritesControllerProvider(page).notifier).addFavorite;

  @override
  @protected
  Fn1<Item, Future<int>> get removeFavoriteCallback =>
      ref.read(favoritesControllerProvider(page).notifier).removeFavorite;
}
