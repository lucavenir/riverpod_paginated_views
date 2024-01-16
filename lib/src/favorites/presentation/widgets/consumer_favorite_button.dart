import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../items/presentation/controllers/item_controller.dart';

class ConsumerFavoriteButton extends ConsumerWidget {
  const ConsumerFavoriteButton({
    required this.id,
    super.key,
  });
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(
      itemControllerProvider(id).select(
        (value) => value.whenData((value) => value.isFavorite),
      ),
    );

    return IconButton(
      onPressed: switch (isFavorite) {
        AsyncData() => () => ref.read(itemControllerProvider(id).notifier).toggle(),
        _ => null,
      },
      icon: switch (isFavorite) {
        AsyncData(value: final isFavorite) =>
          isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
        AsyncLoading() => const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
        _ => const Icon(Icons.favorite_border),
      },
    );
  }
}
