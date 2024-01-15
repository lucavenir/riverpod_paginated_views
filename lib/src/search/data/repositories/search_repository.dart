import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../../items/domain/entities/item.dart';
import '../../../shared/domain/interfaces/repository_mixin.dart';
import '../../domain/repositories/search_repository_interface.dart';

final class SearchRepository with RepositoryInterfaceMixin implements SearchRepositoryInterface {
  const SearchRepository();

  @override
  Future<IList<Item>> search(int page) => randomItems(page);
}
