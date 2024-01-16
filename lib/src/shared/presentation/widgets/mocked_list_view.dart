import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../favorites/presentation/widgets/consumer_favorite_button.dart';
import '../../../items/domain/entities/item.dart';
import '../../../shared/presentation/logic/riverpod_pagination_utils.dart';

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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: theme.textTheme.headlineLarge, textAlign: TextAlign.center),
        Flexible(
          child: ref.paginationBuilder(
            // logic - see the repetition?
            family: family,
            watcher: watcher,
            refreshable: refreshable,
            // builders
            context: context,
            mainBuilder: (context, itemBuilder) => ListView.builder(itemBuilder: itemBuilder),
            emptyBuilder: (context) => const Center(child: Text('No items found')),
            itemBuilder: (context, element) => ListTile(
              key: ValueKey(element.id),
              title: Text('Item $element'),
              trailing: ConsumerFavoriteButton(id: element.id),
            ),
            // I'm lazy, so I'm using a simple `CircularProgressIndicator`
            shimmerBuilder: (context) => const Center(child: CircularProgressIndicator()),
            errorBuilder: (context, error, stackTrace) => const Center(child: Text('Error!')),
          ),
        ),
      ],
    );
  }
}
