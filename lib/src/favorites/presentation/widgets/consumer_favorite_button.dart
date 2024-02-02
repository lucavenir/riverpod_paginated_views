import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../home/presentation/providers/home_provider.dart';
import '../../../items/presentation/controllers/item_controller.dart';
import '../../../search/presentation/providers/search_provider.dart';
import '../../../shared/domain/enum/tab.dart';
import '../../../shared/presentation/hooks/use_side_effect.dart';
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
  final PageBar tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isFavorite = ref.watch(
    //   itemControllerProvider(id).select(
    //     (value) => value.whenData((value) => value.isFavorite),
    //   ),

    final isFavorite = switch (tab) {
      PageBar.home => ref.watch(
          homeProvider(page).select(
            (value) => value.whenData(
              (value) => value.firstWhereOrNull((element) => element.id == id)?.isFavorite ?? false,
            ),
          ),
        ),
      PageBar.fav => ref.watch(
          favoritesProvider(page).select(
            (value) => value.whenData(
              (value) => value.firstWhereOrNull((element) => element.id == id)?.isFavorite ?? false,
            ),
          ),
        ),
      PageBar.search => ref.watch(
          homeProvider(page).select(
            (value) => value.whenData(
              (value) => value.firstWhereOrNull((element) => element.id == id)?.isFavorite ?? false,
            ),
          ),
        )
    };
    print('Id: $id \n $isFavorite');
    final theme = Theme.of(context);

    final (clear: _, :mutate, :snapshot) = useSideEffect<void>();
    return IconButton(
      color: theme.colorScheme.error,
      onPressed:
          // switch (isFavorite) {
          //   AsyncData() =>
          () async {
        final future = ref.read(itemControllerProvider(id).notifier).toggle();
        mutate(future);
        await future;
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
