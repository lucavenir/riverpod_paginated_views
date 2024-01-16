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
    final home = homeProvider(page);
    late ItemsRepositoryInterface homeMockedRepo;

    setUp(() {
      homeMockedRepo = MockItemsRepository();
    });
    tearDown(() {
      reset(homeMockedRepo);
    });
    test('should call fetchItems and load initial state', () async {
      final items = <Item>[].lock;
      Future<IList<Item>> initCall() => homeMockedRepo.fetchItems(page: page);
      when(initCall).thenAnswer((_) async => items);
      final container = TestContainer.setup(
        overrides: [itemsRepositoryProvider.overrideWith((ref) => homeMockedRepo)],
      );

      final tester = container.testTransitionsOn(home);
      await container.read(home.future);

      verifyInOrder([
        initCall,
        () => tester(null, const AsyncLoading()),
        () => tester(const AsyncLoading(), AsyncData(items)),
      ]);
      verifyNoMoreInteractions(homeMockedRepo);
      verifyNoMoreInteractions(tester);
    });
  });
}

class MockItemsRepository extends Mock implements ItemsRepositoryInterface {}
