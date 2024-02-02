import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../home/presentation/providers/home_provider.dart';
import '../../../search/presentation/providers/search_provider.dart';
import '../../../shared/domain/enum/page_tab.dart';
import '../../../shared/presentation/hooks/use_side_effect.dart';
import '../controllers/is_favorite_controller.dart';
import '../providers/favorites_provider.dart';

class ConsumerFavoriteButton extends HookConsumerWidget {
  const ConsumerFavoriteButton({
    required this.id,
    required this.page,
    required this.tab,
    super.key,
  });
  final int id;
  final int page;
  final PageTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isFavorite = ref.watch(
    //   itemControllerProvider(id).select(
    //     (value) => value.whenData((value) => value.isFavorite),
    //   ),
    final isFavorite = switch (tab) {
      PageTab.favorites => ref.watch(
          favoritesProvider(page).select(
            (value) => value.whenData(
              (value) => value.firstWhere((element) => element.id == id).isFavorite,
            ),
          ),
        ),
      PageTab.home => ref.watch(
          homeProvider(page).select(
            (value) => value.whenData(
              (value) => value.firstWhere((element) => element.id == id).isFavorite,
            ),
          ),
        ),
      PageTab.search => ref.watch(
          searchProvider(page).select(
            (value) => value.whenData(
              (value) => value.firstWhere((element) => element.id == id).isFavorite,
            ),
          ),
        ),
    };

    final theme = Theme.of(context);
    final (clear: _, :mutate, :snapshot) = useSideEffect<void>();

    final (clear: _, :mutate, :snapshot) = useSideEffect<void>();
    return IconButton(
      color: theme.colorScheme.error,
      onPressed:
          // switch (isFavorite) {
          //   AsyncData() =>
          () {
        final future = ref.read(isFavoriteControllerProvider(id).notifier).toggle();
        mutate(future);

        ref
          ..invalidate(homeProvider)
          ..invalidate(searchProvider);
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
            AsyncData(value: false) => const Icon(Icons.favorite_border),
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
