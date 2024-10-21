import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../src/favorites/pages/favorites_page.dart';
import '../src/home/pages/home_page.dart';
import '../src/main/pages/main_page.dart';
import '../src/search/pages/search_page.dart';

part 'routes_configuration.g.dart';

@TypedStatefulShellRoute<MainRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(
      routes: [TypedGoRoute<HomeRoute>(path: '/')],
    ),
    TypedStatefulShellBranch<SearchBranch>(
      routes: [TypedGoRoute<SearchRoute>(path: '/search')],
    ),
    TypedStatefulShellBranch<FavoritesBranch>(
      routes: [TypedGoRoute<FavoritesRoute>(path: '/favorite')],
    ),
  ],
)
class MainRoute extends StatefulShellRouteData {
  const MainRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainPage(navigationShell);
  }
}

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();
}

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

class SearchBranch extends StatefulShellBranchData {
  const SearchBranch();
}

class SearchRoute extends GoRouteData {
  const SearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchPage();
  }
}

class FavoritesBranch extends StatefulShellBranchData {
  const FavoritesBranch();
}

class FavoritesRoute extends GoRouteData {
  const FavoritesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FavoritesPage();
  }
}
