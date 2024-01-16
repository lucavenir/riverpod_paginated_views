import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../items/domain/entities/item.dart';
import '../../data/errors/data_not_found_exception.dart';
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
      final id = page * pageSize + index;
      return Item(id: id, label: 'Item $id with $favoriteId', favoriteId: favoriteId);
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

  Future<T> fetch<T>({
    required AsyncValueGetter<T> localFetcher,
    required AsyncValueGetter<T> remoteFetcher,
    required AsyncCallback resetCache,
    required AsyncValueSetter<T> localSetter,
    bool refresh = false,
  }) async {
    if (refresh) {
      return _fetch(
        localSetter: localSetter,
        remoteFetcher: remoteFetcher,
        resetCache: resetCache,
        refresh: true,
      );
    }
    try {
      final items = await localFetcher();
      return items;
    } on DataNotFoundException {
      final results = await _fetch(
        localSetter: localSetter,
        remoteFetcher: remoteFetcher,
        resetCache: resetCache,
      );
      return results;
    }
  }

  Future<T> _fetch<T>({
    required AsyncValueGetter<T> remoteFetcher,
    required AsyncCallback resetCache,
    required AsyncValueSetter<T> localSetter,
    bool refresh = false,
  }) async {
    if (refresh) await resetCache();
    final results = await remoteFetcher();
    await localSetter(results);
    return results;
  }
}
