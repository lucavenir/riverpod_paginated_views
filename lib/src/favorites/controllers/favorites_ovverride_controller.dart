import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../api/items.api.dart';
import '../../items/models/item.dart';

part 'favorites_ovverride_controller.g.dart';

@riverpod
class FavoritesOverrideController extends _$FavoritesOverrideController {
  late ItemsApi itemsApi;

  @override
  Map<int, bool> build() {
    itemsApi = ref.watch(itemsApiProvider.select((value) => value.requireValue));
    return {};
  }

  void set(Iterable<Item> items) {
    final temp = state;
    for (final i in items) {
      if (temp.containsKey(i.id)) temp[i.id] = i.isFavorite;
    }
    state = temp;
  }

  Future<void> toggle({required int id, required bool like}) async {
    print('$id requested with value $like');
    await itemsApi.setFavorite(id: id, isFavorite: like);
    state = {
      ...state,
      id: like,
    };
  }
}
