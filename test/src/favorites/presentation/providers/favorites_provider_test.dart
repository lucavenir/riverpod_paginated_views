import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paginated_views/src/favorites/domain/repositories/favorites_repository_interface.dart';
import 'package:riverpod_paginated_views/src/favorites/presentation/providers/favorites_provider.dart';
import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';

import '../../../../helpers/container_setup.dart';
import '../../../../helpers/test_transitions.dart';

void main() {
  group('favoritesProvider', () {
    const page = 0;
    final favorites = favoritesProvider(0);
    late MockFavoritesRepository mockRepository;

    setUp(() {
      mockRepository = MockFavoritesRepository();
    });
    tearDown(() {
      reset(mockRepository);
    });
    test('build should call getFavorites and load initial state', () async {
      Future<IList<Item>> initCall() => mockRepository.getFavorites(page: page);
      when(initCall).thenAnswer((_) async => <Item>[].lock);
      final container = TestContainer.setup(
        overrides: [favoritesRepositoryProvider.overrideWith((ref) => mockRepository)],
      );

      final tester = container.testTransitionsOn(favorites);
      await container.read(favorites.future);

      verifyInOrder([
        initCall,
        () => tester(null, const AsyncLoading<IList<Item>>()),
        () => tester(const AsyncLoading<IList<Item>>(), AsyncData(<Item>[].lock)),
      ]);
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(tester);
    });
  });
}

class MockFavoritesRepository extends Mock implements FavoritesRepositoryInterface {}
