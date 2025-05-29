import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipes_api/src/models/ingredient.dart';
import 'package:uuid/uuid.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

/// A recipe consists of [title], [image], [steps], and [ingredients].
@freezed
abstract class Recipe with _$Recipe {
  /// Creates a new [Recipe].
  const factory Recipe({
    required String id,
    required String title,
    required String image,
    @Default([]) List<String> steps,
    @Default([]) List<Ingredient> ingredients,
  }) = _Recipe;

  const Recipe._();

  /// Creates an empty [Recipe].
  factory Recipe.empty() => Recipe(
        id: newId,
        title: '',
        image: '',
      );

  /// Creates a new [Recipe] from a JSON object.
  factory Recipe.fromJson(Map<String, Object?> json) => _$RecipeFromJson(json);

  /// Creates a new ID for a [Recipe].
  static String get newId => const Uuid().v4();

  /// Whether the recipe has steps.
  bool get hasSteps => steps.isNotEmpty;

  /// Whether the recipe has ingredients.
  bool get hasIngredients => ingredients.isNotEmpty;

  /// Total number of steps in the recipe.
  int get totalStepsCount => steps.length;

  /// Total number of ingredients in the recipe.
  int get totalIngredientsCount => ingredients.length;

  /// Total calories of all ingredients.
  int get totalCalories => ingredients.fold(
        0,
        (total, ingredient) => total + ingredient.calories,
      );
}
