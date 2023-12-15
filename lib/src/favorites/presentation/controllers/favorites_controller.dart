import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/favorites.dart';
import '../../domain/repositories/favorites_repository_interface.dart';

part 'favorites_controller.g.dart';

@riverpod
final class FavoritesController extends _$FavoritesController {
  late FavoritesRepositoryInterface _repository;

  @override
  Favorites build() {
    _repository = ref.watch(favoritesRepositoryProvider);
    return _repository.getFavorites();
  }
}
