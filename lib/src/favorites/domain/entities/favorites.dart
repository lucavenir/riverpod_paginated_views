import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../items/domain/entities/item.dart';

part 'favorites.freezed.dart';

@freezed
class Favorites with _$Favorites {
  const factory Favorites({
    required List<Item> favorites,
  }) = _Favorites;
}
