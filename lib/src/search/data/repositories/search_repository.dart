import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:isar/isar.dart';

import '../../../items/domain/entities/item.dart';
import '../../../shared/data/errors/data_not_found_exception.dart';
import '../../../shared/domain/interfaces/repository_mixin.dart';
import '../../../shared/presentation/constants/page_size.dart';
import '../../domain/repositories/search_repository_interface.dart';

final class SearchRepository with RepositoryInterfaceMixin implements SearchRepositoryInterface {
  const SearchRepository(this.db);
  final Isar db;
  @override
  Future<IList<Item>> search(int page) => fetch(
        localFetcher: () => _localItems(page),
        remoteFetcher: () => _freshItems(page),
        localSetter: _cacheItems,
        resetCache: _clearItems,
      );

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
}
