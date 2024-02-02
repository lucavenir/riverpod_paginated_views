import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/domain/enum/page_tab.dart';
import '../../../shared/presentation/widgets/mocked_list_view.dart';
import '../providers/home_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MockedListView(
      tab: PageTab.home,
      title: 'Home page!',
      family: homeProvider,
      watcher: (page) => homeProvider(page),
      refreshable: (page) => homeProvider(page).future,
    );
  }
}
