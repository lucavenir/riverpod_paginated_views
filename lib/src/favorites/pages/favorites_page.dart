import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/presentation/widgets/list_view.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MockedListView(
      title: 'Favorites!',
      family: favoritesProvider,
      watcher: (page) => favoritesProvider(page),
      refreshable: (page) => favoritesProvider(page).future,
    );
  }
}
