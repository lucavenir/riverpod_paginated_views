import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../home/presentation/providers/home_provider.dart';
import '../../../search/presentation/providers/search_provider.dart';
import '../../../shared/presentation/hooks/use_side_effect.dart';
import '../controllers/is_favorite_controller.dart';
import '../providers/favorites_provider.dart';

class ConsumerFavoriteButton extends HookConsumerWidget {
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
    final (clear: _, :mutate, :snapshot) = useSideEffect<void>();

    Future<void> onPressed() async {
      await ref.read(isFavoriteControllerProvider(id).notifier).toggle();

      ref
        ..invalidate(homeProvider)
        ..invalidate(searchProvider);
    }

    return IconButton(
      color: theme.colorScheme.error,
      onPressed:
          // switch (isFavorite) {
          //   AsyncData() =>
          () async {
        try {
          final future = onPressed();
          mutate(future);
          await future;
        } catch (error) {
          print(error);
        }
      },

      //   _ => null,
      // },
      icon: switch (snapshot) {
        AsyncSnapshot(connectionState: ConnectionState.waiting) => const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
        _ => switch (isFavorite) {
            AsyncData(value: true) => const Icon(Icons.favorite),
            // AsyncData(value: false) => const Icon(Icons.favorite_border),
            // AsyncLoading() => const SizedBox.square(
            //     dimension: 20,
            //     child: CircularProgressIndicator(strokeWidth: 1.5),
            //   ),
            _ => const Icon(Icons.favorite_border),
          },
      },
    );
  }
}
