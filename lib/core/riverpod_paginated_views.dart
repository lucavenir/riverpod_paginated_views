import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


import 'package:go_router/go_router.dart';

import '../l10n/l10n.dart';
import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';
import '../router/router.dart';

class RiverpodPaginatedViews extends ConsumerWidget {
  const RiverpodPaginatedViews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return  MaterialApp.router(
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: RiverpodPaginatedViewsLocalizations.localizationsDelegates,
      supportedLocales: RiverpodPaginatedViewsLocalizations.supportedLocales,
    );
  }
}
