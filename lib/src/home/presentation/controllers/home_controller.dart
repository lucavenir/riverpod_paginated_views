import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../favorites/presentation/logic/with_favorites_mixin.dart';
import '../../../items/domain/entities/item.dart';
import '../../../items/domain/repositories/items_repository_interface.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController with WithFavoritesMixin {
  late ItemsRepositoryInterface _repo;
  @override
  FutureOr<List<Item>> build(int page) {
    _repo = ref.watch(itemsRepositoryProvider);
    return _repo.fetchItems(page: page);
  }
}
