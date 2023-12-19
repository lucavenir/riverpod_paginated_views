import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paginated_views/src/home/presentation/providers/home_provider.dart';
import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';
import 'package:riverpod_paginated_views/src/items/domain/repositories/items_repository_interface.dart';

import '../../../../helpers/container_setup.dart';
import '../../../../helpers/test_transitions.dart';

void main() {
  group('homeProvider', () {
    const page = 0;
    final home = homeProvider(0);
    late ItemsRepositoryInterface mockRepository;

    setUp(() {
      mockRepository = MockItemsRepository();
    });
    tearDown(() {
      reset(mockRepository);
    });
    test('build should call fetchItems and load initial state', () async {
      Future<IList<Item>> initCall() => mockRepository.fetchItems(page: page);
      when(initCall).thenAnswer((_) async => <Item>[].lock);
      final container = TestContainer.setup(
        overrides: [itemsRepositoryProvider.overrideWith((ref) => mockRepository)],
      );

      final tester = container.testTransitionsOn(home);
      await container.read(home.future);

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

class MockItemsRepository extends Mock implements ItemsRepositoryInterface {}
