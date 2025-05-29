import 'package:recipes_api/recipes_api.dart';

/// {@template recipes_api}
/// The interface for an API that provides access to a list of recipes.
/// {@endtemplate}
abstract class RecipesApi {
  /// {@macro recipes_api}
  const RecipesApi();

  /// Provides a [Stream] of all recipes.
  Stream<List<Recipe>> getRecipes();

  /// Gets a single recipe by its [id].
  ///
  /// If no recipe with the given [id] exists, a [RecipeNotFoundException]
  /// error is thrown.
  Future<Recipe> getRecipe(String id);

  /// Saves a [recipe].
  ///
  /// If a [recipe] with the same id already exists, it will be replaced.
  Future<void> saveRecipe(Recipe recipe);

  /// Updates a [recipe].
  ///
  /// If no [recipe] with the given id exists, a [RecipeNotFoundException]
  /// error is thrown.
  Future<void> updateRecipe(Recipe recipe);

  /// Deletes the recipe with the given [id].
  ///
  /// If no recipe with the given [id] exists, a [RecipeNotFoundException]
  /// error is thrown.
  Future<void> deleteRecipe(String id);

  /// Returns a list of all recipes.
  Future<List<Recipe>> getAllRecipes();

  /// Returns recipes that contain all of the specified [ingredientNames].
  ///
  /// This is different from [searchRecipesByIngredients] which returns recipes
  /// containing any of the ingredients. This method returns only recipes that
  /// contain ALL of the specified ingredients.
  Future<List<Recipe>> getRecipesWithIngredients(List<String> ingredientNames);

  /// Returns recipes that contain any of the specified [ingredientNames].
  Future<List<Recipe>> searchRecipesByIngredients(List<String> ingredientNames);

  /// Returns a list of all available ingredients.
  /// 
  /// This can be used to populate the initial ingredients list in the UI.
  Future<List<Ingredient>> getAllIngredients();

  /// Closes the client and frees up any resources.
  Future<void> close();
}

/// Error thrown when a [Recipe] with a given id is not found.
class RecipeNotFoundException implements Exception {}

/// Error thrown when an [Ingredient] with a given name is not found.
class IngredientNotFoundException implements Exception {}
