import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paginated_views/src/favorites/domain/repositories/favorites_repository_interface.dart';
import 'package:riverpod_paginated_views/src/favorites/presentation/controllers/favorites_controller.dart';
import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';

import '../../../../helpers/container_setup.dart';
import '../../../../helpers/test_transitions.dart';

void main() {
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
  });
  tearDown(() {
    reset(mockRepository);
  });

  group('FavoritesController', () {
    test('build should call getFavorites and load initial state', () async {
      Future<IList<Item>> initCall() => mockRepository.getFavorites(page: 0);
      when(initCall).thenAnswer((_) async => startingList);
      final container = TestContainer.setup(
        overrides: [favoritesRepositoryProvider.overrideWith((ref) => mockRepository)],
      );

      const loadingState = AsyncLoading<IList<Item>>();
      final tester = container.testTransitionsOn(favoritesControllerProvider);
      await container.read(favoritesControllerProvider.future);

      verifyInOrder([
        initCall,
        () => tester(null, loadingState),
        () => tester(loadingState, emptyState),
      ]);
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(tester);
    });
    test('addFavorite should call addFavorite and update state', () async {
      Future<int> firstFavoriteCall() => mockRepository.addFavorite(firstMock);
      when(firstFavoriteCall).thenAnswer((_) async => favoriteId1);
      Future<int> secondFavoriteCall() => mockRepository.addFavorite(secondMock);
      when(secondFavoriteCall).thenAnswer((_) async => favoriteId2);

      final container = TestContainer.setup(
        overrides: [
          favoritesControllerProvider.overrideWith(InitializedFavoritesController.new),
          favoritesRepositoryProvider.overrideWith((ref) => mockRepository),
        ],
      );
      final tester = container.testTransitionsOn(favoritesControllerProvider);

      final notifier = container.read(favoritesControllerProvider.notifier);
      await notifier.addFavorite(firstMock);
      await notifier.addFavorite(secondMock);

      verifyInOrder([
        () => tester(null, emptyState),
        firstFavoriteCall,
        () => tester(emptyState, firstState),
        secondFavoriteCall,
        () => tester(firstState, secondState),
      ]);
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(tester);
    });
    test('removeFavorite should call removeFavorite and update state', () async {
      final removed = favoritedFirstMock;
      Future<int> removeCall() => mockRepository.removeFavorite(removed);
      when(removeCall).thenAnswer((_) async => removed.favoriteId!);

      final container = TestContainer.setup(
        overrides: [
          favoritesControllerProvider.overrideWith(WithFavoritesFavoritesController.new),
          favoritesRepositoryProvider.overrideWith((ref) => mockRepository),
        ],
      );
      final tester = container.testTransitionsOn(favoritesControllerProvider);

      final notifier = container.read(favoritesControllerProvider.notifier);
      await notifier.removeFavorite(removed);

      verifyInOrder([
        () => tester(null, secondState),
        removeCall,
        () => tester(secondState, thirdState),
      ]);
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(tester);
    });
  });
}

class MockFavoritesRepository extends Mock implements FavoritesRepositoryInterface {}

final startingList = <Item>[].lock;
final emptyState = AsyncData(startingList);

class InitializedFavoritesController extends FavoritesController {
  @override
  FutureOr<IList<Item>> build() {
    repository = ref.watch(favoritesRepositoryProvider);
    return startingList;
  }
}

const firstMock = Item(id: 0, label: 'first', favoriteId: null);
const favoriteId1 = 99;
final favoritedFirstMock = firstMock.copyWith(favoriteId: favoriteId1);
final firstList = [favoritedFirstMock].lock;
final firstState = AsyncData(firstList);

const secondMock = Item(id: 1, label: 'second', favoriteId: null);
const favoriteId2 = 101;
final favoritedSecondMock = secondMock.copyWith(favoriteId: favoriteId2);
final secondList = [favoritedSecondMock, ...firstList].lock;
final secondState = AsyncData(secondList);
final thirdList = [favoritedSecondMock].lock;
final thirdState = AsyncData(thirdList);

class WithFavoritesFavoritesController extends FavoritesController {
  @override
  FutureOr<IList<Item>> build() {
    repository = ref.watch(favoritesRepositoryProvider);
    return secondList;
  }
}
