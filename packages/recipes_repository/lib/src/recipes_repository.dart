import 'package:recipes_api/recipes_api.dart';

/// {@template recipes_repository}
/// A repository that handles recipe related requests.
/// {@endtemplate}
class RecipesRepository {
  /// {@macro recipes_repository}
  const RecipesRepository({
    required RecipesApi recipesApi,
  }) : _recipesApi = recipesApi;

  final RecipesApi _recipesApi;

  /// Provides a [Stream] of all recipes.
  Stream<List<Recipe>> getRecipes() => _recipesApi.getRecipes();

  /// Gets a single recipe by its [id].
  ///
  /// Throws a [RecipeNotFoundException] if the recipe is not found.
  Future<Recipe> getRecipe(String id) => _recipesApi.getRecipe(id);

  /// Saves a [recipe].
  ///
  /// If the recipe already exists, it will be updated.
  Future<void> saveRecipe(Recipe recipe) => _recipesApi.saveRecipe(recipe);

  /// Updates an existing [recipe].
  ///
  /// Throws a [RecipeNotFoundException] if the recipe doesn't exist.
  Future<void> updateRecipe(Recipe recipe) => _recipesApi.updateRecipe(recipe);

  /// Deletes a recipe by its [id].
  ///
  /// Throws a [RecipeNotFoundException] if the recipe doesn't exist.
  Future<void> deleteRecipe(String id) => _recipesApi.deleteRecipe(id);

  /// Gets all recipes as a [Future].
  ///
  /// Unlike [getRecipes], this returns a one-time snapshot of all recipes.
  Future<List<Recipe>> getAllRecipes() => _recipesApi.getAllRecipes();

  /// Gets recipes that contain ALL of the specified [ingredientNames].
  ///
  /// Returns a list of recipes where each recipe contains all of the
  /// ingredients specified in [ingredientNames].
  ///
  /// This is different from [searchRecipesByIngredients] which returns
  /// recipes containing any of the specified ingredients.
  Future<List<Recipe>> getRecipesWithIngredients(
    List<String> ingredientNames,
  ) =>
      _recipesApi.getRecipesWithIngredients(ingredientNames);

  /// Searches for recipes that contain any of the specified [ingredientNames].
  ///
  /// Returns a list of recipes that have at least one ingredient matching
  /// any of the provided ingredient names.
  Future<List<Recipe>> searchRecipesByIngredients(
    List<String> ingredientNames,
  ) =>
      _recipesApi.searchRecipesByIngredients(ingredientNames);

  /// Gets all available ingredients.
  ///
  /// Returns a list of all ingredients that can be used in recipes.
  /// This is useful for populating ingredient selection lists in the UI.
  Future<List<Ingredient>> getAllIngredients() =>
      _recipesApi.getAllIngredients();

  /// Closes the repository and releases any resources.
  Future<void> close() => _recipesApi.close();
}
