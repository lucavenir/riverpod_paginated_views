import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../controllers/favorites_ovverride_controller.dart';

part 'is_favorite_provider.g.dart';

@riverpod
bool? isFavorite(IsFavoriteRef ref, int id) {
  return ref.watch(
    favoritesOverrideControllerProvider.select(
      (overrides) => overrides[id],
    ),
  );
}
