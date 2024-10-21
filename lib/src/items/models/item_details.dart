import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_details.freezed.dart';

@freezed
class ItemDetails with _$ItemDetails {
  const factory ItemDetails({
    required int id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String label,
    required String author,
    @Default(false) bool isFavorite,
  }) = _ItemDetails;
}

extension ItemDetailsExt on ItemDetails {
  bool get isNotFavorite => !isFavorite;
}
