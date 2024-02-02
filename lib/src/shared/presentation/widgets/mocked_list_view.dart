import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../favorites/presentation/widgets/consumer_favorite_button.dart';
import '../../../items/domain/entities/item.dart';
import '../../../shared/presentation/logic/riverpod_pagination_utils.dart';
import '../../domain/enum/tab.dart';
import 'item_shimmer_widget.dart';

class MockedListView extends ConsumerWidget {
  const MockedListView({
    required this.title,
    required this.family,
    required this.watcher,
    required this.refreshable,
    required this.pageBar,
    super.key,
  });
  final String title;
  final ProviderOrFamily family;
  final PaginatedWatcher<Item> watcher;
  final PaginatedRefreshable<Item> refreshable;
  final PageBar pageBar;

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
              // logic - see the repetition?
              family: family,
              watcher: watcher,
              refreshable: refreshable,
              // builders
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
                  leading: ConsumerFavoriteButton(
                    id: element.id,
                    page: page,
                    tab: pageBar,
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
