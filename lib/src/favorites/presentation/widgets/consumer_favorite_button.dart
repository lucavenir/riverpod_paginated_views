import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/is_favorite_controller.dart';

class ConsumerFavoriteButton extends ConsumerWidget {
  const ConsumerFavoriteButton({
    required this.id,
    super.key,
  });
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(
      isFavoriteControllerProvider(id).select(
        (value) => value.whenData((value) => value != null),
      ),
    );

    final theme = Theme.of(context);

    return IconButton(
      color: theme.colorScheme.error,
      onPressed: switch (isFavorite) {
        AsyncData() => () => ref.read(isFavoriteControllerProvider(id).notifier).toggle(),
        _ => null,
      },
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
