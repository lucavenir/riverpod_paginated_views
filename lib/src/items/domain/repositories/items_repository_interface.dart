import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/items_repository.dart';
import '../entities/item.dart';

part 'items_repository_interface.g.dart';

@riverpod
ItemsRepositoryInterface itemsRepository(ItemsRepositoryRef ref) {
  return const ItemsRepository();
}

abstract interface class ItemsRepositoryInterface {
  Future<List<Item>> fetchItems({required int page});
}
