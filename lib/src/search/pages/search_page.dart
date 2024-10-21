import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/presentation/widgets/list_view.dart';
import '../providers/search_provider.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final text = useListenableSelector(controller, () => controller.text);

    return Column(
      children: [
        SearchBar(controller: controller),
        Expanded(
          child: MockedListView(
            title: 'Search!',
            family: searchProvider,
            watcher: (page) => searchProvider(page: page, q: text),
            refreshable: (page) => searchProvider(page: page, q: text).future,
          ),
        ),
      ],
    );
  }
}
