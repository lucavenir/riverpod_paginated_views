import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'item_details.freezed.dart';
part 'item_details.g.dart';

@freezed
@Collection(ignore: {'props', 'copyWith'})
class ItemDetails extends Equatable with _$ItemDetails {
  const factory ItemDetails({
    required int id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String label,
    required String author,
    required int? favoriteId,
  }) = _ItemDetails;
  const ItemDetails._();

  @override
  List<Object?> get props => [id];
  bool get isFavorite => favoriteId != null;
  bool get isNotFavorite => !isFavorite;
}
