import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../router/routes_configuration.dart';

class MainPage extends HookConsumerWidget {
  const MainPage(this.navigationShell, {super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final canExit = useRef(_initial(context));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite paged lists test'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: PopScope(
        canPop: canExit.value,
        onPopInvoked: (value) {
          if (value) return;
          const HomeRoute().go(context);
          canExit.value = true;
        },
        child: navigationShell,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.colorScheme.primary,
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

  bool _initial(BuildContext context) {
    return GoRouterState.of(context).uri.toString() == const HomeRoute().location;
  }
}
