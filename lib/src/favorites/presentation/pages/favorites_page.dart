import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../items/presentation/controllers/item_controller.dart';
import '../../../shared/presentation/logic/riverpod_pagination_utils.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Infinite paginated lists with Riverpod')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Home page!', style: theme.textTheme.headlineLarge, textAlign: TextAlign.center),
          Flexible(
            child: ref.paginationBuilder(
              // logic - see the repetition?
              family: favoritesProvider,
              watcher: (page) => favoritesProvider(page),
              refreshable: (page) => favoritesProvider(page).future,
              // builders
              context: context,
              mainBuilder: (context, itemBuilder) => ListView.builder(itemBuilder: itemBuilder),
              emptyBuilder: (context) => const Center(child: Text('No items found')),
              itemBuilder: (context, element) => ListTile(
                title: Text('Item $element'),
                trailing: IconButton(
                  onPressed: () => ref.read(itemControllerProvider(element.id).notifier).toggle(),
                  icon: element.isFavorite
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                ),
              ),
              // I'm lazy, so I'm using a simple `CircularProgressIndicator`
              shimmerBuilder: (context) => const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, error, stackTrace) => const Center(child: Text('Error!')),
            ),
          ),
        ],
      ),
    );
  }
}
