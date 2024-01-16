import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/page_size.dart';

typedef PaginatedWatcher<T> = ProviderListenable<AsyncValue<IList<T>>> Function(int page);
typedef PaginatedRefreshable<T> = Refreshable<Future<IList<T>>> Function(int page);
typedef RiverpodErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
);
typedef RiverpodPaginatedBuilder = Widget Function(
  BuildContext context,
  NullableIndexedWidgetBuilder itemBuilder,
);
typedef RiverpodItemBuilder<T> = Widget Function(BuildContext context, T element);

extension RiverpodPaginationUtils on WidgetRef {
  Widget paginationBuilder<T>({
    required BuildContext context,
    required RiverpodPaginatedBuilder mainBuilder,
    required WidgetBuilder emptyBuilder,
    required ProviderOrFamily family,
    required PaginatedWatcher<T> watcher,
    required PaginatedRefreshable<T> refreshable,
    required RiverpodItemBuilder<T> itemBuilder,
    required WidgetBuilder shimmerBuilder,
    required RiverpodErrorBuilder errorBuilder,
  }) {
    // issues to be solved...
    // invalidate(watcher(index));
    // refresh(watcher(index));

    return RefreshIndicator(
      onRefresh: () {
        invalidate(family);
        return refresh(refreshable(0));
      },
      child: mainBuilder(context, (context, index) {
        // pagination logic that fits literally anywhere
        final page = index ~/ pageSize;
        final offset = index % pageSize;
        final state = watch(watcher(page));

        // warn. opinionated. this is where your implementation should take place
        return switch (state) {
          AsyncValue(hasValue: true, value: IList(isEmpty: true)) when page == 0 =>
            emptyBuilder(context),
          AsyncValue(hasValue: true, :final value?) when offset < pageSize =>
            itemBuilder(context, value[offset]),
          AsyncLoading() => shimmerBuilder(context),
          AsyncError(:final error, :final stackTrace) => errorBuilder(context, error, stackTrace),
          _ => const ListTile(title: Text('what...?')),
        };
      }),
    );
  }
}
