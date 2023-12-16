import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_paginated_views/src/favorites/domain/repositories/favorites_repository_interface.dart';
import 'package:riverpod_paginated_views/src/favorites/presentation/controllers/favorites_controller.dart';
import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';

import '../../../../helpers/container_setup.dart';
import '../../../../helpers/test_transitions.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepositoryInterface {}

void main() {
  late ProviderContainer container;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    container = TestContainer.setup(
      overrides: [favoritesRepositoryProvider.overrideWith((ref) => mockRepository)],
    );
  });
  tearDown(() {
    reset(mockRepository);
  });

  group('FavoritesController', () {
    test('build should call getFavorites method and load initial state', () async {
      Future<List<Item>> repoCall() => mockRepository.getFavorites(page: 0);
      const mockedResult = <Item>[];
      when(repoCall).thenAnswer((_) async => mockedResult);
      final tester = container.testTransitionsOn(favoritesControllerProvider);
      const loadingState = AsyncLoading<List<Item>>();
      const loadedState = AsyncData<List<Item>>(mockedResult);

      await expectLater(
        container.read(favoritesControllerProvider.future),
        completion(mockedResult),
      );

      verifyInOrder([
        repoCall,
        () => tester.call(null, loadingState),
        () => tester.call(loadingState, loadedState),
      ]);
    });

    // test('addFavorite should add the item to favorites', () async {
    //   // Arrange
    //   const item = Item(id: 1, name: 'Item 1', isFavorite: false);
    //   const favoriteId = 1;
    //   when(mockRepository.addFavorite(item)).thenAnswer((_) async => favoriteId);

    //   // Act
    //   final result = await favoritesController.addFavorite(item);

    //   // Assert
    //   expect(result, favoriteId);
    //   verify(mockRepository.addFavorite(item)).called(1);
    // });

    // test('removeFavorite should remove the item from favorites', () async {
    //   // Arrange
    //   const item = Item(id: 1, name: 'Item 1', isFavorite: true);
    //   const favoriteId = 1;
    //   when(mockRepository.removeFavorite(item)).thenAnswer((_) async => favoriteId);

    //   // Act
    //   final result = await favoritesController.removeFavorite(item);

    //   // Assert
    //   expect(result, favoriteId);
    //   verify(mockRepository.removeFavorite(item)).called(1);
    // });
  });
}
