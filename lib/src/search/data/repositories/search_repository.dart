import '../../domain/entities/search.dart';
import '../../domain/repositories/search_repository_interface.dart';

final class SearchRepository implements SearchRepositoryInterface {
  const SearchRepository();

  @override
  Search getSearch() {
    throw UnimplementedError('TODO: add repository logic in here');
  }
}
