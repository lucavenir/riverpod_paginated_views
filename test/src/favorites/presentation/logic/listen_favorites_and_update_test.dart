import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paginated_views/src/favorites/domain/repositories/favorites_repository_interface.dart';
import 'package:riverpod_paginated_views/src/favorites/presentation/controllers/favorites_controller.dart';
import 'package:riverpod_paginated_views/src/favorites/presentation/logic/listen_to_favorites_and_update_accordingly.dart';
import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';

import '../../../../helpers/container_setup.dart';
import '../../../../helpers/test_transitions.dart';
import '../../../../helpers/verify_single.dart';

part 'listen_favorites_and_update_test.g.dart';

void main() {
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
  });
  tearDown(() {
    reset(mockRepository);
  });

  group('listenToFavoritesAndUpdateAccordingly keeps state in sync', () {
    test('updates the items when a favorite is removed', () async {
      final container = TestContainer.setup(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => mockRepository),
          favoritesControllerProvider.overrideWith(MockFavoritesController.new),
        ],
      );
      Future<int> removeCall() => mockRepository.removeFavorite(_toBeRemoved);
      when(removeCall).thenAnswer((_) async => _toBeRemoved.favoriteId!);
      final someItemsAfterRemoval = <Item>[
        _toBeAdded,
        _toBeRemoved.copyWith(favoriteId: null),
        const Item(id: 2, label: 'Item 2', favoriteId: null),
        const Item(id: 3, label: 'Item 3', favoriteId: 3),
      ].lock;
      final tester = container.testTransitionsOn(_testProvider);

      await container.read(_testProvider.future);
      await container.read(favoritesControllerProvider.notifier).removeFavorite(_toBeRemoved);
      await Future<void>.delayed(1.milliseconds); // waiting for `ref.state = ...` to be executed
      await container.read(_testProvider.future);

      verifyInOrder([
        () => tester(null, AsyncData(_someItems)),
        removeCall,
        () => tester(AsyncData(_someItems), AsyncData(someItemsAfterRemoval)),
      ]);
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(tester);
    });
    test('updates the items when a favorite is added', () async {
      final container = TestContainer.setup(
        overrides: [
          favoritesRepositoryProvider.overrideWith((ref) => mockRepository),
          favoritesControllerProvider.overrideWith(MockFavoritesController.new),
        ],
      );
      Future<int> addCall() => mockRepository.addFavorite(_toBeAdded);
      when(addCall).thenAnswer((_) async => _toBeAddedFavoriteId);
      final someItemsAfterAddition = <Item>[
        _toBeAdded.copyWith(favoriteId: _toBeAddedFavoriteId),
        _toBeRemoved,
        const Item(id: 2, label: 'Item 2', favoriteId: null),
        const Item(id: 3, label: 'Item 3', favoriteId: 3),
      ].lock;
      final tester = container.testTransitionsOn(_testProvider);

      await container.read(_testProvider.future);
      await container.read(favoritesControllerProvider.notifier).addFavorite(_toBeAdded);
      await Future<void>.delayed(1.milliseconds); // waiting for `ref.state = ...` to be executed
      await container.read(_testProvider.future);

      verifyInOrder([
        () => tester(null, AsyncData(_someItems)),
        addCall,
        () => tester(AsyncData(_someItems), AsyncData(someItemsAfterAddition)),
      ]);
      verifyNoMoreInteractions(tester);
      verifyNoMoreInteractions(mockRepository);
    });
  });
  test('nothing gets updated if unrelated changes happen to favorites', () async {
    final container = TestContainer.setup(
      overrides: [
        favoritesRepositoryProvider.overrideWith((ref) => mockRepository),
        favoritesControllerProvider.overrideWith(MockFavoritesController.new),
      ],
    );
    Future<int> removeCall() => mockRepository.removeFavorite(_extraItem1);
    when(removeCall).thenAnswer((_) async => _extraItem1.favoriteId!);
    Future<int> addCall() => mockRepository.addFavorite(_extraItem2);
    when(addCall).thenAnswer((_) async => _extraItem2FavoriteId);
    final tester = container.testTransitionsOn(_testProvider);

    await container.read(_testProvider.future);
    await container.read(favoritesControllerProvider.notifier).removeFavorite(_extraItem1);
    await Future<void>.delayed(1.milliseconds); // waiting for `ref.state = ...` to be executed
    await container.read(_testProvider.future);
    await container.read(favoritesControllerProvider.notifier).addFavorite(_extraItem2);
    await Future<void>.delayed(1.milliseconds); // waiting for `ref.state = ...` to be executed
    await container.read(_testProvider.future);
    container.read(favoritesControllerProvider.notifier).state =
        await AsyncValue.guard(() => throw Exception('woops!'));
    await Future<void>.delayed(1.milliseconds); // waiting for `ref.state = ...` to be executed
    await container.read(_testProvider.future);

    verifySingle(tester, () => tester(null, AsyncData(_someItems)));
  });
}

class MockFavoritesRepository extends Mock implements FavoritesRepositoryInterface {}

class MockFavoritesController extends FavoritesController {
  @override
  FutureOr<IList<Item>> build() {
    repository = ref.watch(favoritesRepositoryProvider);
    return _favoriteItems;
  }
}

@riverpod
FutureOr<IList<Item>> _test(_TestRef ref) {
  ref.listenToFavoritesAndUpdateAccordingly();
  return _someItems;
}

const _toBeRemoved = Item(id: 1, label: 'Item 1', favoriteId: 1);
const _toBeAdded = Item(id: 0, label: 'Item 0', favoriteId: null);
const _toBeAddedFavoriteId = 0;
const _extraItem1 = Item(id: 4, label: 'Item 4', favoriteId: 4);
const _extraItem2 = Item(id: 5, label: 'Item 5', favoriteId: null);
const _extraItem2FavoriteId = 5;

final _favoriteItems = <Item>[
  _toBeRemoved,
  const Item(id: 2, label: 'Item 2', favoriteId: 2),
  const Item(id: 3, label: 'Item 3', favoriteId: 3),
  _extraItem1,
].lock;

final _someItems = <Item>[
  _toBeAdded,
  _toBeRemoved,
  const Item(id: 2, label: 'Item 2', favoriteId: null),
  const Item(id: 3, label: 'Item 3', favoriteId: 3),
].lock;
