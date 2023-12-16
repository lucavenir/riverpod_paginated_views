import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../items/domain/entities/item.dart';
import '../../../shared/domain/interfaces/fn1.dart';
import '../../domain/repositories/favorites_repository_interface.dart';
import '../logic/favorite_controller_mixin.dart';

part 'favorites_controller.g.dart';

@riverpod
final class FavoritesController extends _$FavoritesController with WithFavoritesMixin {
  late FavoritesRepositoryInterface _repository;

  @override
  Future<List<Item>> build(int page) {
    _repository = ref.watch(favoritesRepositoryProvider);
    return _repository.getFavorites(page: page);
  }

  @override
  @protected
  Fn1<Item, Future<int>> get addFavoriteCallback => _repository.removeFavorite;

  @override
  @protected
  Fn1<Item, Future<int>> get removeFavoriteCallback => _repository.removeFavorite;
}
