import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../items/domain/entities/item.dart';
import '../../presentation/constants/page_size.dart';
import 'repository_interface.dart';

mixin RepositoryInterfaceMixin implements RepositoryInterface {
  Future<IList<Item>> randomItems(int page, {bool favoritesOnly = false}) {
    final random = Random();
    final items = List.generate(pageSize, (index) {
      final favoriteId = favoritesOnly
          ? -1
          : random.nextBool()
              ? random.nextInt(1 << 16)
              : null;
      return Item(id: page + index, label: 'Item $favoriteId', favoriteId: favoriteId);
    });
    return Future.delayed(
      random.nextInt(1000).milliseconds,
      () => items.lock,
    );
  }

  Future<Item> randomItem(int id) async {
    final random = Random();
    final randomPage = random.nextInt((id + 1) << 16);
    final items = await randomItems(randomPage);
    final randomIndex = random.nextInt(items.length);
    return Future.delayed(
      random.nextInt(1000).milliseconds,
      () => items[randomIndex],
    );
  }
}
