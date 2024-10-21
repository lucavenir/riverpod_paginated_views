import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    required this.value,
    required this.onToggle,
    super.key,
  });
  final AsyncValueSetter<bool> onToggle;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      color: theme.colorScheme.error,
      onPressed: () => onToggle(value),
      icon: value ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
    );
  }
}
