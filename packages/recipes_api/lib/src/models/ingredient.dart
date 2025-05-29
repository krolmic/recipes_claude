import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

/// An ingredient consists of [name], [calories], and [image].
@freezed
abstract class Ingredient with _$Ingredient {
  /// Creates a new [Ingredient].
  const factory Ingredient({
    required String name,
    required int calories,
    required String image,
  }) = _Ingredient;

  const Ingredient._();

  /// Creates a new [Ingredient] from a JSON object.
  factory Ingredient.fromJson(Map<String, Object?> json) =>
      _$IngredientFromJson(json);
}
