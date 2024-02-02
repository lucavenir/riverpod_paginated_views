import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../home/presentation/providers/home_provider.dart';
import '../../../items/presentation/controllers/item_controller.dart';
import '../../../search/presentation/providers/search_provider.dart';
import '../providers/favorites_provider.dart';

class ConsumerFavoriteButton extends ConsumerWidget {
  const ConsumerFavoriteButton({
    required this.id,
    required this.page,
    super.key,
  });
  final int id;
  final int page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isFavorite = ref.watch(
    //   itemControllerProvider(id).select(
    //     (value) => value.whenData((value) => value.isFavorite),
    //   ),
    final isFavorite = ref.watch(
      favoritesProvider(page).select(
        (value) => value.whenData(
          (value) => value.firstWhere((element) => element.id == id).isFavorite,
        ),
      ),
    );

    final theme = Theme.of(context);

    return IconButton(
      color: theme.colorScheme.error,
      onPressed:
          // switch (isFavorite) {
          //   AsyncData() =>
          () {
        ref.read(itemControllerProvider(id).notifier).toggle();
        ref
          ..invalidate(homeProvider(page))
          ..invalidate(searchProvider(page));
      },
      //   _ => null,
      // },
      icon: switch (isFavorite) {
        AsyncData(value: true) => const Icon(Icons.favorite),
        AsyncData(value: false) => const Icon(Icons.favorite_border),
        AsyncLoading() => const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
        _ => const Icon(Icons.favorite_border),
      },
    );
  }
}
