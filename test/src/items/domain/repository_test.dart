import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_paginated_views/src/items/domain/entities/item.dart';
import 'package:riverpod_paginated_views/src/items/domain/repositories/items_repository_interface.dart';

import '../../../helpers/container_setup.dart';

void main() {
  group('ItemsRepositoryInterface', () {
    test('fetchItems returns an expected list of items', () async {
      final container = TestContainer.setup();
      final itemsRepository = container.read(itemsRepositoryProvider);

      final result = await itemsRepository.fetchItems(page: 0);

      expect(result, isA<IList<Item>>());
      expect(result.first.id, equals(0));
    });
  });
}
