import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemShimmerWidget extends StatelessWidget {
  const ItemShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade600,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
        ),
        child: ListTile(
          leading: Icon(
            Icons.favorite_border,
            color: theme.colorScheme.error,
          ),
          title: Container(
            height: 20,
            width: 120,
            color: theme.colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
