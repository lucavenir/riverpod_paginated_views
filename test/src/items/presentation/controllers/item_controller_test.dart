import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paginated_views/src/favorites/domain/repositories/favorites_repository_interface.dart';
import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';
import 'package:riverpod_paginated_views/src/items/domain/repositories/items_repository_interface.dart';
import 'package:riverpod_paginated_views/src/items/presentation/controllers/item_controller.dart';

import '../../../../helpers/container_setup.dart';
import '../../../../helpers/test_transitions.dart';

void main() {
  group('ItemController', () {
    const id = 99;
    final item = itemControllerProvider(id);

    late MockFavoritesRepository favoriteMock;
    late MockItemsRepository itemsMock;

    setUp(() {
      favoriteMock = MockFavoritesRepository();
      itemsMock = MockItemsRepository();
    });
    tearDown(() {
      reset(favoriteMock);
      reset(itemsMock);
    });
    test('build works properly', () async {
      when(() => itemsMock.getDetails(id: id)).thenAnswer((_) async => itemMock);
      final container = TestContainer.setup(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => favoriteMock),
          itemsRepositoryProvider.overrideWith((ref) => itemsMock),
        ],
      );
      final tester = container.testTransitionsOn(item);

      await container.read(item.future);

      verifyInOrder([
        () => tester(null, const AsyncLoading<Item>()),
        () => tester(const AsyncLoading<Item>(), const AsyncData(itemMock)),
      ]);
      verifyNoMoreInteractions(tester);
    });

    test('toggle should call addFavorite when item is not favorite', () async {
      Future<int> favoriteCall() => favoriteMock.addFavorite(itemMock);
      when(favoriteCall).thenAnswer((_) async => favoriteMockId);
      final container = TestContainer.setup(
        overrides: [
          item.overrideWith(NonfavoriteItemControllerMock.new),
          favoritesRepositoryProvider.overrideWith((ref) => favoriteMock),
        ],
      );
      final tester = container.testTransitionsOn(item);

      await container.read(item.future);
      await container.read(item.notifier).toggle();
      await container.read(item.future);

      verifyInOrder([
        () => tester(null, const AsyncData(itemMock)),
        favoriteCall,
        () => tester(const AsyncData(itemMock), AsyncData(favoritedMock)),
      ]);
      verifyNoMoreInteractions(favoriteMock);
      verifyNoMoreInteractions(tester);
    });
    test('toggle should call removeFavorite when item is favorite', () async {
      Future<int> unfavoriteCall() => favoriteMock.removeFavorite(favoritedMock);
      when(unfavoriteCall).thenAnswer((_) async => favoriteMockId);
      final container = TestContainer.setup(
        overrides: [
          item.overrideWith(FavoriteItemControllerMock.new),
          favoritesRepositoryProvider.overrideWith((ref) => favoriteMock),
        ],
      );
      final tester = container.testTransitionsOn(item);

      await container.read(item.future);
      await container.read(item.notifier).toggle();
      await container.read(item.future);

      verifyInOrder([
        () => tester(null, AsyncData(favoritedMock)),
        unfavoriteCall,
        () => tester(AsyncData(favoritedMock), const AsyncData(itemMock)),
      ]);
      verifyNoMoreInteractions(favoriteMock);
      verifyNoMoreInteractions(tester);
    });
  });
}

class MockFavoritesRepository extends Mock implements FavoritesRepositoryInterface {}

class MockItemsRepository extends Mock implements ItemsRepositoryInterface {}

class NonfavoriteItemControllerMock extends ItemController {
  @override
  FutureOr<Item> build(int id) {
    this.itemsRepository = ref.watch(itemsRepositoryProvider);
    this.favoritesRepository = ref.watch(favoritesRepositoryProvider);
    return itemMock;
  }
}

class FavoriteItemControllerMock extends ItemController {
  @override
  FutureOr<Item> build(int id) {
    this.itemsRepository = ref.watch(itemsRepositoryProvider);
    this.favoritesRepository = ref.watch(favoritesRepositoryProvider);
    return favoritedMock;
  }
}

const itemMock = Item(id: 0, label: 'first', favoriteId: null);
const favoriteMockId = 99;
final favoritedMock = itemMock.copyWith(favoriteId: favoriteMockId);
