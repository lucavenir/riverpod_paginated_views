import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef ContainerUtilities = Never;

extension TestContainer on ContainerUtilities {
  static ProviderContainer setup({
    ProviderContainer? parent,
    List<Override> overrides = const [],
    List<ProviderObserver> observers = const [],
  }) {
    final container = ProviderContainer(
      parent: parent,
      overrides: overrides,
      observers: observers,
    );
    addTearDown(container.dispose);
    return container;
  }
}
