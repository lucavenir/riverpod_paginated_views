import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../../shared/domain/interfaces/repository_mixin.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/items_repository_interface.dart';

final class ItemsRepository with RepositoryInterfaceMixin implements ItemsRepositoryInterface {
  const ItemsRepository();

  @override
  Future<IList<Item>> fetchItems({required int page}) => randomItems(page);

  @override
  Future<Item> getDetails({required int id}) => randomItem(id);
}
