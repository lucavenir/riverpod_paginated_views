import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../src/items/domain/entities/item.dart';
import '../src/items/domain/entities/item_details.dart';

part 'isar_client.g.dart';

@riverpod
FutureOr<Isar> isarClient(IsarClientRef ref) async {
  ref.keepAlive();
  final dir = await getApplicationDocumentsDirectory();
  final isar = Isar.open(
    schemas: [ItemSchema, ItemDetailsSchema],
    directory: dir.path,
    name: 'isar.db',
  );
  ref.onDispose(isar.close);

  return isar;
}
