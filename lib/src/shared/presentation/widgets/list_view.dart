import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../favorites/controllers/favorites_ovverride_controller.dart';
import '../../../favorites/providers/is_favorite_provider.dart';
import '../../../favorites/widgets/favorite_button.dart';
import '../../../items/models/item.dart';
import '../../../shared/presentation/logic/riverpod_pagination_utils.dart';
import 'item_shimmer_widget.dart';

class MockedListView extends ConsumerWidget {
  const MockedListView({
    required this.title,
    required this.family,
    required this.watcher,
    required this.refreshable,
    super.key,
  });
  final String title;
  final ProviderOrFamily family;
  final PaginatedWatcher<Item> watcher;
  final PaginatedRefreshable<Item> refreshable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(title, style: theme.textTheme.headlineLarge, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ref.paginationBuilder(
              family: family,
              watcher: watcher,
              refreshable: refreshable,
              context: context,
              mainBuilder: (context, itemBuilder) => ListView.builder(itemBuilder: itemBuilder),
              emptyBuilder: (context) => const Center(child: Text('No items found')),
              itemBuilder: (context, element, page) => Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  tileColor: theme.colorScheme.surface,
                  dense: true,
                  minLeadingWidth: 64,
                  title: Text('Item ${element.id}', style: theme.textTheme.bodyLarge),
                  leading: Consumer(
                    builder: (context, ref, child) {
                      final override = ref.watch(isFavoriteProvider(element.id));
                      print('${element.id}: ${element.isFavorite}, override: $override');

                      return FavoriteButton(
                        value: override ?? element.isFavorite,
                        onToggle: (value) {
                          return ref
                              .read(favoritesOverrideControllerProvider.notifier)
                              .toggle(id: element.id, like: !value);
                        },
                      );
                    },
                  ),
                ),
              ),
              shimmerBuilder: (context) => const ItemShimmerWidget(),
              errorBuilder: (context, error, stackTrace) => const Center(child: Text('Error!')),
            ),
          ),
        ),
      ],
    );
  }
}
