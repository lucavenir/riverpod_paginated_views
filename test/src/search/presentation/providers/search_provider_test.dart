import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';
import 'package:riverpod_paginated_views/src/search/domain/repositories/search_repository_interface.dart';
import 'package:riverpod_paginated_views/src/search/presentation/providers/search_provider.dart';

import '../../../../helpers/container_setup.dart';
import '../../../../helpers/test_transitions.dart';

void main() {
  group('search', () {
    const page = 0;
    late MockSearchRepository searchMockedRepo;
    final searches = searchProvider(0);

    setUp(() {
      searchMockedRepo = MockSearchRepository();
    });
    tearDown(() {
      reset(searchMockedRepo);
    });

    test('should call fetchItems and load initial state', () async {
      final items = <Item>[].lock;
      Future<IList<Item>> searchRequest() => searchMockedRepo.search(page);
      when(searchRequest).thenAnswer((_) async => items);
      final container = TestContainer.setup(
        overrides: [
          searchRepositoryProvider.overrideWith((ref) => searchMockedRepo),
        ],
      );
      final tester = container.testTransitionsOn(searches);

      await container.read(searchProvider(0).future);

      verifyInOrder([
        searchRequest,
        () => tester(null, const AsyncLoading()),
        () => tester(const AsyncLoading(), AsyncData(items)),
      ]);
      verifyNoMoreInteractions(searchMockedRepo);
      verifyNoMoreInteractions(tester);
    });
  });
}

class MockSearchRepository extends Mock implements SearchRepositoryInterface {}
