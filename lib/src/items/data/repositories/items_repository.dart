import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../shared/presentation/constants/page_size.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/items_repository_interface.dart';

final class ItemsRepository implements ItemsRepositoryInterface {
  const ItemsRepository();

  @override
  Future<IList<Item>> fetchItems({required int page}) {
    final random = Random();
    final items = List.generate(pageSize, (index) {
      final favoriteId = random.nextBool() ? random.nextInt(1 << 16) : null;
      return Item(
        id: page + index,
        label: 'Item $favoriteId',
        favoriteId: favoriteId,
      );
    });
    return Future.delayed(
      random.nextInt(1000).milliseconds,
      () => items.lock,
    );
  }

  @override
  Future<Item> getDetails({required int id}) {
    final random = Random();
    final favoriteId = random.nextBool() ? random.nextInt(1 << 16) : null;
    return Future.delayed(
      random.nextInt(1000).milliseconds,
      () => Item(id: id, label: 'Item $favoriteId', favoriteId: favoriteId),
    );
  }
}
