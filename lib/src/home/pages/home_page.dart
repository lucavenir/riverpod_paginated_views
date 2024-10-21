import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/presentation/widgets/list_view.dart';
import '../providers/home_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MockedListView(
      title: 'Home page!',
      family: homeProvider,
      watcher: (page) => homeProvider(page),
      refreshable: (page) => homeProvider(page).future,
    );
  }
}
