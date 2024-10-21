import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../src/items/models/item.dart';
import '../src/items/models/item_details.dart';
import '../src/shared/presentation/constants/page_size.dart';

part 'items.api.g.dart';

@riverpod
Future<ItemsApi> itemsApi(ItemsApiRef ref) async {
  final db = Db();
  final api = ItemsApiMock(db);
  await api.generateMocks();

  return api;
}

abstract interface class ItemsApi {
  Future<IList<Item>> home({required int page});
  Future<IList<Item>> search({required int page, required String q});
  Future<IList<Item>> favorites({required int page});
  Future<ItemDetails> getDetails({required int id});
  Future<void> setFavorite({required int id, required bool isFavorite});
}

/// Mocked version of an api returning lists of items, and their details
/// To emulate some sort of "server state", a local SQLite DB is used.
/// You can essentially ignore everything that's under this line
class ItemsApiMock implements ItemsApi {
  const ItemsApiMock(this.db);
  final Db db;

  @override
  Future<void> setFavorite({required int id, required bool isFavorite}) async {
    final query = db.update(db.dbItem)..where((i) => i.id.equals(id));
    await query.write(DbItemCompanion(isFavorite: Value(isFavorite)));
  }

  @override
  Future<IList<Item>> home({required int page}) async {
    final query = db.select(db.dbItem)..limit(page.limit, offset: page.offset);
    final dbResults = await query.get();
    return dbResults.toSnippets();
  }

  @override
  Future<IList<Item>> favorites({required int page}) async {
    final query = db.select(db.dbItem)
      ..limit(page.limit, offset: page.offset)
      ..where((i) => i.isFavorite.equals(true));
    final dbResults = await query.get();
    return dbResults.toSnippets();
  }

  @override
  Future<IList<Item>> search({required int page, required String q}) async {
    final query = db.select(db.dbItem)
      ..where((i) => i.label.contains(q))
      ..limit(page.limit, offset: page.offset);
    final dbResults = await query.get();
    return dbResults.toSnippets();
  }

  @override
  Future<ItemDetails> getDetails({required int id}) async {
    final query = db.select(db.dbItem)..where((d) => d.id.equals(id));
    final result = await query.getSingle();
    return result.toDetails();
  }

  @protected
  Future<void> generateMocks() async {
    final count = await db.dbItem.count().getSingle();
    if (count > 0) return;

    await db.batch((batch) => batch.insertAll(db.dbItem, randomItems(from: 0, to: 12)));
  }

  @protected
  Iterable<DbItemCompanion> randomItems({required int from, required int to}) sync* {
    for (var i = from; i < to; i++) {
      for (var j = 0; j < pageSize; j++) {
        yield randomItem(from * pageSize + j);
      }
    }
  }

  @protected
  DbItemCompanion randomItem(int id) {
    final isFavorite = random.nextDouble() < 0.3;
    final date = DateTime(2024, random.nextInt(12) + 1, random.nextInt(28) + 1);
    return DbItemCompanion(
      id: Value(id),
      label: Value(isFavorite ? 'Favorite item: $id' : 'Item: $id'),
      isFavorite: Value(isFavorite),
      author: const Value('someone'),
      createdAt: Value(date),
      updatedAt: Value(date.add(random.nextInt(28).days)),
    );
  }

  @protected
  DbItemCompanion randomDetailsFrom(DbItemCompanion item) {
    final date = DateTime(2024, random.nextInt(12) + 1, random.nextInt(28) + 1);

    return DbItemCompanion(
      id: item.id,
      label: item.label,
      isFavorite: item.isFavorite,
      createdAt: Value(date),
      updatedAt: Value(date.add(random.nextInt(28).days)),
      author: Value('some author of ${item.id}'),
    );
  }

  @protected
  math.Random get random => math.Random();
}

@protected
extension MockApiModelListMapperExt on Iterable<DbItemData> {
  IList<Item> toSnippets() => IList(_toSnippets());
  Iterable<Item> _toSnippets() sync* {
    for (final i in this) {
      yield i.toSnippet();
    }
  }
}

@protected
extension PaginatorExt on int {
  int get offset => this * pageSize;
  int get limit => this * pageSize + pageSize;
}

@protected
extension MockApiModelMapperExt on DbItemData {
  Item toSnippet() => Item(id: id, label: label, isFavorite: isFavorite);
  ItemDetails toDetails() => ItemDetails(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        label: label,
        author: author,
        isFavorite: isFavorite,
      );
}

@DriftDatabase(tables: [DbItem])
class Db extends _$Db {
  Db() : super(startup());

  static QueryExecutor startup() {
    // driftDatabase from package:drift_flutter stores the database in
    // getApplicationDocumentsDirectory().
    return driftDatabase(name: 'my_database');
  }

  @override
  int get schemaVersion => 1;
}

class DbItem extends Table {
  IntColumn get id => integer().references(DbItem, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get label => text()();
  TextColumn get author => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}
