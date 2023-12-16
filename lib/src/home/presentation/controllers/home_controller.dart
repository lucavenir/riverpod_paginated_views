import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../favorites/presentation/controllers/favorites_controller.dart';
import '../../../favorites/presentation/logic/favorite_controller_mixin.dart';
import '../../../items/domain/entities/item.dart';
import '../../../items/domain/repositories/items_repository_interface.dart';
import '../../../shared/domain/interfaces/fn1.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController with WithFavoritesMixin {
  late ItemsRepositoryInterface _repo;
  @override
  FutureOr<List<Item>> build(int page) {
    _repo = ref.watch(itemsRepositoryProvider);
    return _repo.fetchItems(page: page);
  }

  @override
  @protected
  Fn1<Item, Future<int>> get addFavoriteCallback {
    return ref.read(favoritesControllerProvider(page).notifier).addFavorite;
  }

  @override
  @protected
  Fn1<Item, Future<int>> get removeFavoriteCallback {
    return ref.read(favoritesControllerProvider(page).notifier).removeFavorite;
  }
}
