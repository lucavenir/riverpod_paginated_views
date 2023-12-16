import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../l10n/l10n.dart';
import '../router/router.dart';
import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';

class RiverpodPaginatedViews extends ConsumerWidget {
  const RiverpodPaginatedViews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: RiverpodPaginatedViewsLocalizations.localizationsDelegates,
      supportedLocales: RiverpodPaginatedViewsLocalizations.supportedLocales,
    );
  }
}
