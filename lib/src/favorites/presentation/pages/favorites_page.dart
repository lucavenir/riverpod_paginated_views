import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/domain/enum/page_tab.dart';
import '../../../shared/presentation/widgets/mocked_list_view.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MockedListView(
      tab: PageTab.favorites,
      title: 'Favorites!',
      family: favoritesProvider,
      watcher: (page) => favoritesProvider(page),
      refreshable: (page) => favoritesProvider(page).future,
    );
  }
}
