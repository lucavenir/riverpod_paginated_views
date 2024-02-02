import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:isar/isar.dart';

import '../../../shared/data/errors/data_not_found_exception.dart';
import '../../../shared/domain/interfaces/repository_mixin.dart';
import '../../../shared/presentation/constants/page_size.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_details.dart';
import '../../domain/repositories/items_repository_interface.dart';

final class ItemsRepository with RepositoryInterfaceMixin implements ItemsRepositoryInterface {
  const ItemsRepository(this.db);
  final Isar db;

  @override
  Future<IList<Item>> fetchItems({required int page, bool refresh = false}) {
    print('ho fetchato');
    return fetch(
      localFetcher: () => _localItems(page),
      remoteFetcher: () => _freshItems(page),
      localSetter: _cacheItems,
      resetCache: _clearItems,
      refresh: refresh,
    );
  }

  Future<IList<Item>> _freshItems(int page) async {
    final results = await randomItems(page);
    return results;
  }

  Future<IList<Item>> _localItems(int page) async {
    final result = await db.items.where().findAllAsync(offset: page * pageSize, limit: pageSize);
    if (result.isEmpty) throw const DataNotFoundException('Items not found');
    return result.lock;
  }

  Future<void> _cacheItems(IList<Item> items) {
    return db.writeAsync((isar) {
      isar.items.putAll([...items]);
    });
  }

  Future<void> _clearItems() {
    return db.writeAsync((isar) {
      isar.items.clear();
    });
  }

  @override
  Future<Item> getDetails({required int id, bool refresh = false}) {
    print('sono stato chiamato');
    return fetch(
      localFetcher: () => _localItem(id),
      remoteFetcher: () => _freshItem(id),
      localSetter: _cacheItem,
      resetCache: () => _clearItem(id),
      refresh: refresh,
    );
  }

  Future<Item> _localItem(int id) async {
    final result = db.items.where().idEqualTo(id).findFirst();
    if (result == null) throw const DataNotFoundException('Item not found');
    return result;
  }

  Future<Item> _freshItem(int id) async {
    await db.writeAsync((isar) {
      isar.itemDetails.delete(id);
    });
    final item = await randomItem(id);
    return item;
  }

  Future<void> _cacheItem(Item item) {
    return db.writeAsync((isar) {
      isar.items.put(item);
    });
  }

  Future<void> _clearItem(int id) {
    return db.writeAsync((isar) {
      isar.itemDetails.delete(id);
    });
  }
}
