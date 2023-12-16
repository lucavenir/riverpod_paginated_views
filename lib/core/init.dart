import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../clients/talker.dart';
import '../logs/riverpod_paginated_views_provider_observer.dart';
import 'init_talker.dart';
import 'riverpod_paginated_views.dart';
import 'riverpod_paginated_views_flavors.dart';

Future<void> initWith(RiverpodPaginatedViewsFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  final talker = initTalker();

  // add more configurations here
  runApp(
    ProviderScope(
      overrides: [
        flavorProvider.overrideWith((ref) {
          ref.keepAlive();
          return flavor;
        }),
        talkerProvider.overrideWith((ref) {
          ref.keepAlive();
          return talker;
        }),
      ],
      observers: [RiverpodPaginatedViewsProviderObserver(talker)],
      child: const RiverpodPaginatedViews(),
    ),
  );
}
