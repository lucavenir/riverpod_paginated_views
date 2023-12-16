// import 'package:flutter_test/flutter_test.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:riverpod_paginated_views/src/favorites/presentation/logic/with_favorites_mixin.dart';
// import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';

// import '../../../../helpers/container_setup.dart';

// class MockedWithFavoritesNotifier extends AutoDisposeFamilyAsyncNotifier<List<Item>, int>
//     with Mock, WithFavoritesMixin {
//   @override
//   Future<List<Item>> build(int arg) async {
//     return [];
//   }
// }

// void main() {
//   late WithFavoritesMixin notifier;
//   setUp(() => notifier = MockedWithFavoritesNotifier());

//   group('WithFavoritesMixin', () {
//     test('toggleFavorite calls addFavorite if item is not a favorite', () async {
//       const item = Item(id: 1, favoriteId: null, label: '');
//       when(() => notifier.toggleFavorite(item)).thenAnswer((_) async {});

//       await notifier.toggleFavorite(mockItem);
//       verify(mockItem.copyWith(favoriteId: 1)).called(1);
//     });

//     test('toggleFavorite calls removeFavorite if item is a favorite', () async {
//       when(mockItem.isFavorite).thenReturn(true);
//       await notifier.toggleFavorite(mockItem);
//       verify(mockItem.copyWith(favoriteId: 1)).called(1);
//     });

//     test('addFavorite adds an item to the favorites', () async {
//       when(mockItem.isNotFavorite).thenReturn(true);
//       await notifier.addFavorite(mockItem);
//       verify(mockItem.copyWith(favoriteId: 1)).called(1);
//     });
//   });
// }
