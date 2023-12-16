import '../../../items/domain/entities/item.dart';
import '../../domain/repositories/search_repository_interface.dart';

final class SearchRepository implements SearchRepositoryInterface {
  const SearchRepository();

  @override
  List<Item> getSearch() {
    throw UnimplementedError('TODO: add repository logic in here');
  }
}
