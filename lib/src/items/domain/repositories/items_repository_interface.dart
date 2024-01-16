import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../clients/isar_client.dart';
import '../../../shared/domain/interfaces/repository_interface.dart';
import '../../data/repositories/items_repository.dart';
import '../entities/item.dart';

part 'items_repository_interface.g.dart';

@riverpod
ItemsRepositoryInterface itemsRepository(ItemsRepositoryRef ref) {
  final db = ref.read(isarClientProvider.select((value) => value.requireValue));
  return ItemsRepository(db);
}

abstract interface class ItemsRepositoryInterface implements RepositoryInterface {
  Future<IList<Item>> fetchItems({required int page, bool refresh = false});
  Future<Item> getDetails({required int id, bool refresh = false});
}
