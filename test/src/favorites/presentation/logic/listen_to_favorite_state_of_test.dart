import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paginated_views/src/favorites/domain/repositories/favorites_repository_interface.dart';
import 'package:riverpod_paginated_views/src/favorites/presentation/controllers/is_favorite_controller.dart';
import 'package:riverpod_paginated_views/src/favorites/presentation/logic/listen_to_favorite_state_of.dart';
import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';
import 'package:riverpod_paginated_views/src/items/domain/repositories/items_repository_interface.dart';

import '../../../../helpers/container_setup.dart';
import '../../../../helpers/test_transitions.dart';

part 'listen_to_favorite_state_of_test.g.dart';

void main() {
  late ItemsRepositoryInterface mockRepository;

  setUp(() {
    mockRepository = MockItemsRepository();
  });
  tearDown(() {
    reset(mockRepository);
  });

  group('listenToFavoriteStateOf keeps favorite state in sync', () {
    test('updates the items when a favorite is added or removed', () async {
      Future<IList<Item>> initCall() => mockRepository.fetchItems(page: 0);
      when(initCall).thenAnswer((_) async => _someItems);
      final container = TestContainer.setup(
        overrides: [
          isFavoriteControllerProvider(0).overrideWith(MockItemController.new),
          isFavoriteControllerProvider(1).overrideWith(MockItemController.new),
          isFavoriteControllerProvider(2).overrideWith(MockItemController.new),
          isFavoriteControllerProvider(3).overrideWith(MockItemController.new),
          itemsRepositoryProvider.overrideWith((ref) => mockRepository),
        ],
      );
      final tester = container.testTransitionsOn(_testProvider);

      await container.read(_testProvider.future);
      await container.read(isFavoriteControllerProvider(0).notifier).toggle();
      await container.read(isFavoriteControllerProvider(1).notifier).toggle();
      await container.read(isFavoriteControllerProvider(0).notifier).toggle();
      await container.read(isFavoriteControllerProvider(2).notifier).toggle();
      await container.read(isFavoriteControllerProvider(3).notifier).toggle();
      await container.read(isFavoriteControllerProvider(0).notifier).toggle();
      await container.pump();
      await container.read(_testProvider.future);

      verifyInOrder([
        initCall,
        () => tester(null, const AsyncLoading<IList<Item>>()),
        () => tester(const AsyncLoading<IList<Item>>(), AsyncData(_someItems)),
        () => tester(AsyncData(_someItems), AsyncData(_firstUpdate)),
        () => tester(AsyncData(_firstUpdate), AsyncData(_secondUpdate)),
        () => tester(AsyncData(_secondUpdate), AsyncData(_thirdUpdate)),
        () => tester(AsyncData(_thirdUpdate), AsyncData(_fourthUpdate)),
        () => tester(AsyncData(_fourthUpdate), AsyncData(_fifthUpdate)),
        () => tester(AsyncData(_fifthUpdate), AsyncData(_sixthUpdate)),
      ]);
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(tester);
    });
  });
}

class MockItemsRepository extends Mock implements ItemsRepositoryInterface {}

class MockItemController extends ItemController {
  @override
  FutureOr<Item> build(int id) {
    this.itemsRepository = ref.watch(itemsRepositoryProvider);
    this.favoritesRepository = ref.watch(favoritesRepositoryProvider);
    return switch (id) {
      0 => _item0,
      1 => _item1,
      2 => _item2,
      3 => _item3,
      _ => throw Exception("Didn't mock for this id id: $id"),
    };
  }

  @override
  Future<void> addFavorite() => update((state) => state.copyWith(favoriteId: id));
  @override
  Future<void> removeFavorite() => update((state) => state.copyWith(favoriteId: null));
}

@riverpod
FutureOr<IList<Item>> _test(_TestRef ref) async {
  final repo = ref.watch(itemsRepositoryProvider);
  final items = await repo.fetchItems(page: 0);

  ref.listenToFavoriteStateOf(items);

  return items;
}

const _item0 = Item(id: 0, label: 'Item 0', favoriteId: null);
const _item1 = Item(id: 1, label: 'Item 1', favoriteId: 1);
const _item2 = Item(id: 2, label: 'Item 2', favoriteId: 2);
const _item3 = Item(id: 3, label: 'Item 3', favoriteId: null);

final _someItems = <Item>[
  _item0,
  _item1,
  _item2,
  _item3,
].lock;

final _firstUpdate = <Item>[
  _item0.copyWith(favoriteId: 0),
  _item1,
  _item2,
  _item3,
].lock;

final _secondUpdate = <Item>[
  _item0.copyWith(favoriteId: 0),
  _item1.copyWith(favoriteId: null),
  _item2,
  _item3,
].lock;

final _thirdUpdate = <Item>[
  _item0.copyWith(favoriteId: null),
  _item1,
  _item2,
  _item3,
].lock;

final _fourthUpdate = <Item>[
  _item0.copyWith(favoriteId: null),
  _item1,
  _item2.copyWith(favoriteId: null),
  _item3,
].lock;

final _fifthUpdate = <Item>[
  _item0.copyWith(favoriteId: null),
  _item1,
  _item2.copyWith(favoriteId: null),
  _item3.copyWith(favoriteId: 3),
].lock;

final _sixthUpdate = <Item>[
  _item0.copyWith(favoriteId: 0),
  _item1,
  _item2.copyWith(favoriteId: null),
  _item3.copyWith(favoriteId: 3),
].lock;
