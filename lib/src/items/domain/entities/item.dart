import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

@freezed
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
