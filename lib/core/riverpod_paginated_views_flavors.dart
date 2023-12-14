

import 'package:riverpod_annotation/riverpod_annotation.dart';




part 'riverpod_paginated_views_flavors.g.dart';
@riverpod
RiverpodPaginatedViewsFlavor flavor(FlavorRef ref) {


  throw UnimplementedError('This provider is meant to be overridden');

}



enum RiverpodPaginatedViewsFlavor {
  development(title: '[DEV] Riverpod Paginated Views'),
  staging(title: '[STG] Riverpod Paginated Views'),
  production(title: 'Riverpod Paginated Views');

  const RiverpodPaginatedViewsFlavor({required this.title});
  final String title;

  // add flavor-related configurations getters and methods, e.g. url or special configurations
}
