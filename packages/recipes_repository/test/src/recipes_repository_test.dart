// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:recipes_api/recipes_api.dart';
import 'package:recipes_repository/recipes_repository.dart';
import 'package:test/test.dart';

class MockRecipesApi extends Mock implements RecipesApi {}

void main() {
  group('RecipesRepository', () {
    late RecipesApi recipesApi;
    late RecipesRepository recipesRepository;

    setUp(() {
      recipesApi = MockRecipesApi();
      recipesRepository = RecipesRepository(recipesApi: recipesApi);
    });

    test('can be instantiated', () {
      expect(recipesRepository, isNotNull);
    });

    group('getRecipes', () {
      test('calls getRecipes on recipesApi', () {
        when(() => recipesApi.getRecipes()).thenAnswer((_) => Stream.value([]));
        recipesRepository.getRecipes();
        verify(() => recipesApi.getRecipes()).called(1);
      });
    });

    group('getRecipe', () {
      test('calls getRecipe on recipesApi', () async {
        const recipeId = 'test-id';
        final recipe = Recipe(
          id: recipeId,
          title: 'Test Recipe',
          image: 'test.jpg',
        );
        when(() => recipesApi.getRecipe(recipeId))
            .thenAnswer((_) async => recipe);

        final result = await recipesRepository.getRecipe(recipeId);

        expect(result, equals(recipe));
        verify(() => recipesApi.getRecipe(recipeId)).called(1);
      });
    });

    group('saveRecipe', () {
      test('calls saveRecipe on recipesApi', () async {
        final recipe = Recipe(
          id: 'test-id',
          title: 'Test Recipe',
          image: 'test.jpg',
        );
        when(() => recipesApi.saveRecipe(recipe)).thenAnswer((_) async {});

        await recipesRepository.saveRecipe(recipe);

        verify(() => recipesApi.saveRecipe(recipe)).called(1);
      });
    });

    group('updateRecipe', () {
      test('calls updateRecipe on recipesApi', () async {
        final recipe = Recipe(
          id: 'test-id',
          title: 'Test Recipe',
          image: 'test.jpg',
        );
        when(() => recipesApi.updateRecipe(recipe)).thenAnswer((_) async {});

        await recipesRepository.updateRecipe(recipe);

        verify(() => recipesApi.updateRecipe(recipe)).called(1);
      });
    });

    group('deleteRecipe', () {
      test('calls deleteRecipe on recipesApi', () async {
        const recipeId = 'test-id';
        when(() => recipesApi.deleteRecipe(recipeId)).thenAnswer((_) async {});

        await recipesRepository.deleteRecipe(recipeId);

        verify(() => recipesApi.deleteRecipe(recipeId)).called(1);
      });
    });

    group('getAllRecipes', () {
      test('calls getAllRecipes on recipesApi', () async {
        final recipes = <Recipe>[];
        when(() => recipesApi.getAllRecipes()).thenAnswer((_) async => recipes);

        final result = await recipesRepository.getAllRecipes();

        expect(result, equals(recipes));
        verify(() => recipesApi.getAllRecipes()).called(1);
      });
    });

    group('getRecipesWithIngredients', () {
      test('calls getRecipesWithIngredients on recipesApi', () async {
        final ingredientNames = ['tomato', 'cheese', 'basil'];
        final recipes = <Recipe>[];
        when(() => recipesApi.getRecipesWithIngredients(ingredientNames))
            .thenAnswer((_) async => recipes);

        final result =
            await recipesRepository.getRecipesWithIngredients(ingredientNames);

        expect(result, equals(recipes));
        verify(() => recipesApi.getRecipesWithIngredients(ingredientNames))
            .called(1);
      });
    });

    group('searchRecipesByIngredients', () {
      test('calls searchRecipesByIngredients on recipesApi', () async {
        final ingredientNames = ['tomato', 'cheese'];
        final recipes = <Recipe>[];
        when(() => recipesApi.searchRecipesByIngredients(ingredientNames))
            .thenAnswer((_) async => recipes);

        final result =
            await recipesRepository.searchRecipesByIngredients(ingredientNames);

        expect(result, equals(recipes));
        verify(() => recipesApi.searchRecipesByIngredients(ingredientNames))
            .called(1);
      });
    });

    group('getAllIngredients', () {
      test('calls getAllIngredients on recipesApi', () async {
        final ingredients = [
          Ingredient(name: 'Milk', calories: 600, image: 'milk.jpg'),
          Ingredient(name: 'Eggs', calories: 155, image: 'eggs.jpg'),
          Ingredient(name: 'Flour', calories: 387, image: 'flour.jpg'),
          Ingredient(name: 'Vanilla', calories: 33, image: 'vanilla.jpg'),
        ];
        when(() => recipesApi.getAllIngredients())
            .thenAnswer((_) async => ingredients);

        final result = await recipesRepository.getAllIngredients();

        expect(result, equals(ingredients));
        verify(() => recipesApi.getAllIngredients()).called(1);
      });
    });

    group('close', () {
      test('calls close on recipesApi', () async {
        when(() => recipesApi.close()).thenAnswer((_) async {});

        await recipesRepository.close();

        verify(() => recipesApi.close()).called(1);
      });
    });
  });
}
