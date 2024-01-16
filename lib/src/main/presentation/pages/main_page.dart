import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../router/routes_configuration.dart';
import '../providers/loading_provider.dart';

class MainPage extends HookConsumerWidget {
  const MainPage(this.navigationShell, {super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInitial = navigationShell.currentIndex == 0;
    final canExit = useRef(isInitial);
    final loading = ref.watch(loadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite paginated lists with Riverpod'),
      ),
      // bugged, because of `go_router`
      body: PopScope(
        canPop: canExit.value,
        onPopInvoked: (value) {
          if (value) return;
          const HomeRoute().go(context);
          canExit.value = true;
        },
        child: switch (loading) {
          AsyncValue(hasValue: true, value: != null) => navigationShell,
          AsyncError() => const Center(
              child: Text(
                'An error occurred while loading data.\n'
                'Please try again later.',
                textAlign: TextAlign.center,
              ),
            ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(label: 'Home', icon: Icon(Icons.home_filled)),
          NavigationDestination(label: 'Search', icon: Icon(Icons.search)),
          NavigationDestination(label: 'Favorites', icon: Icon(Icons.favorite)),
        ],
        onDestinationSelected: (i) {
          if (i > 0) canExit.value = false;
          navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex);
        },
      ),
    );
  }
}
