part of 'recipes_cubit.dart';

enum RecipesStatus { initial, loading, success, failure }
enum RecipeStatus { initial, loading, success, failure }

final class RecipesState extends Equatable {
  const RecipesState({
    this.status = RecipesStatus.initial,
    this.recipeStatus = RecipeStatus.initial,
    this.ingredients = const [],
    this.selectedIngredients = const [],
    this.recipes = const [],
    this.recipe,
    this.errorMessage,
  });

  final RecipesStatus status;
  final RecipeStatus recipeStatus;
  final List<Ingredient> ingredients;
  final List<Ingredient> selectedIngredients;
  final List<Recipe> recipes;
  final Recipe? recipe;
  final String? errorMessage;

  RecipesState copyWith({
    RecipesStatus? status,
    RecipeStatus? recipeStatus,
    List<Ingredient>? ingredients,
    List<Ingredient>? selectedIngredients,
    List<Recipe>? recipes,
    Recipe? recipe,
    String? errorMessage,
  }) {
    return RecipesState(
      status: status ?? this.status,
      recipeStatus: recipeStatus ?? this.recipeStatus,
      ingredients: ingredients ?? this.ingredients,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      recipes: recipes ?? this.recipes,
      recipe: recipe ?? this.recipe,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        recipeStatus,
        ingredients,
        selectedIngredients,
        recipes,
        recipe,
        errorMessage,
      ];
}
