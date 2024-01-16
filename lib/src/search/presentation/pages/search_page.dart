import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/presentation/widgets/mocked_list_view.dart';
import '../providers/search_provider.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MockedListView(
      title: 'Search!',
      family: searchProvider,
      watcher: (page) => searchProvider(page),
      refreshable: (page) => searchProvider(page).future,
    );
  }
}
