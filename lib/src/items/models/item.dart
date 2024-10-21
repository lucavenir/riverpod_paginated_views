import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

@freezed
class Item with _$Item {
  const factory Item({
    required int id,
    required String label,
    @Default(false) bool isFavorite,
  }) = _Item;
}

extension ItemExt on Item {
  bool get isNotFavorite => !isFavorite;
}
