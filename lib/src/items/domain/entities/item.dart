import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
@Collection(ignore: {'props', 'copyWith'})
class Item extends Equatable with _$Item {
  const factory Item({
    required int id,
    required String label,
    required int? favoriteId,
  }) = _Item;
  const Item._();

  @override
  List<Object?> get props => [id];
  bool get isFavorite => favoriteId != null;
  bool get isNotFavorite => !isFavorite;
}
