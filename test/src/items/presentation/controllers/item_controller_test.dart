import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paginated_views/src/favorites/domain/repositories/favorites_repository_interface.dart';
import 'package:riverpod_paginated_views/src/favorites/presentation/providers/favorites_provider.dart';
import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';
import 'package:riverpod_paginated_views/src/items/domain/repositories/items_repository_interface.dart';
import 'package:riverpod_paginated_views/src/items/presentation/controllers/item_controller.dart';

import '../../../../helpers/container_setup.dart';
import '../../../../helpers/test_transitions.dart';

void main() {
  const id = 99;
  final item = itemControllerProvider(id);
  group('ItemController', () {
    const id = 99;
    final item = itemControllerProvider(id);

    late MockItemsRepository itemsMock;

    setUp(() {
      itemsMock = MockItemsRepository();
    });
    tearDown(() {
      reset(itemsMock);
    });
    test('build works properly', () async {
      when(() => itemsMock.getDetails(id: id)).thenAnswer((_) async => itemMock);
      final container = TestContainer.setup(
        overrides: [
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
  });

  group('side effects', () {
    const page = 0;
    late MockFavoritesRepository favoriteMock;
    setUp(() {
      favoriteMock = MockFavoritesRepository();
    });
    tearDown(() {
      reset(favoriteMock);
    });
    test('toggle to add favorite works and invalidates favorites', () async {
      // setup
      Future<IList<Item>> favoriteInitCall() => favoriteMock.getFavorites(page: page);
      Future<int> addCall() => favoriteMock.addFavorite(itemMock);
      when(addCall).thenAnswer((_) async => favoriteMockId);
      when(favoriteInitCall).thenAnswer((_) async => <Item>[favoritedMock].lock);
      final container = TestContainer.setup(
        overrides: [
          item.overrideWith(NonfavoriteItemControllerMock.new),
          favoritesRepositoryProvider.overrideWith((ref) => favoriteMock),
        ],
      );
      final tester = container.testTransitionsOn(item);
      container.listen(favoritesProvider(page), (_, __) {});

      // act
      await container.read(item.future);
      await container.read(item.notifier).toggle();
      await container.read(item.future);
      await container.read(favoritesProvider(page).future);

      // assert
      verifyInOrder([
        () => tester(null, const AsyncData(itemMock)),
        favoriteInitCall,
        addCall,
        () => tester(const AsyncData(itemMock), AsyncData(favoritedMock)),
        favoriteInitCall, // because of invalidation
      ]);
      verifyNoMoreInteractions(favoriteMock);
      verifyNoMoreInteractions(tester);
    });
    test('toggle to removefavorite works and invalidates favorites', () async {
      // setup
      Future<IList<Item>> favoriteInitCall() => favoriteMock.getFavorites(page: page);
      Future<int> removeCall() => favoriteMock.removeFavorite(favoritedMock);
      when(removeCall).thenAnswer((_) async => favoriteMockId);
      when(favoriteInitCall).thenAnswer((_) async => <Item>[favoritedMock].lock);
      final container = TestContainer.setup(
        overrides: [
          item.overrideWith(FavoriteItemControllerMock.new),
          favoritesRepositoryProvider.overrideWith((ref) => favoriteMock),
        ],
      );
      final tester = container.testTransitionsOn(item);
      container.listen(favoritesProvider(page), (_, __) {});

      await container.read(item.future);
      await container.read(item.notifier).toggle();
      await container.read(item.future);
      await container.read(favoritesProvider(page).future);

      verifyInOrder([
        () => tester(null, AsyncData(favoritedMock)),
        favoriteInitCall,
        removeCall,
        () => tester(AsyncData(favoritedMock), const AsyncData(itemMock)),
        favoriteInitCall,
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
