import 'dart:async';
import 'dart:math';

import 'package:recipes_api/recipes_api.dart';
import 'package:rxdart/rxdart.dart';

/// {@template fake_recipes_api}
/// A fake implementation of the RecipesApi that returns mock data.
/// {@endtemplate}
class FakeRecipesApi extends RecipesApi {
  /// {@macro fake_recipes_api}
  FakeRecipesApi()
      : _recipesStreamController = BehaviorSubject.seeded(_fakeRecipes);

  final BehaviorSubject<List<Recipe>> _recipesStreamController;
  static final _random = Random();

  // Fake ingredients data
  static final _fakeIngredients = [
    const Ingredient(
      name: 'Milk',
      calories: 600,
      image:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Eggs',
      calories: 155,
      image:
          'https://images.unsplash.com/photo-1491524062933-cb0289261700?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Flour',
      calories: 387,
      image:
          'https://images.unsplash.com/photo-1610725664285-7c57e6eeac3f?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Vanilla',
      calories: 33,
      image:
          'https://images.unsplash.com/photo-1610487512810-b614ad747572?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Sugar',
      calories: 387,
      image:
          'https://images.unsplash.com/photo-1559181567-c3190ca9959b?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Butter',
      calories: 717,
      image:
          'https://images.unsplash.com/photo-1556912167-f556f1f39fdf?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Chocolate',
      calories: 546,
      image:
          'https://images.unsplash.com/photo-1610450949065-1f2841536c88?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Strawberry',
      calories: 32,
      image:
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Banana',
      calories: 89,
      image:
          'https://images.unsplash.com/photo-1481349518771-20055b2a7b24?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Apple',
      calories: 52,
      image:
          'https://images.unsplash.com/photo-1584306670957-acf935f5033c?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Lemon',
      calories: 29,
      image:
          'https://images.unsplash.com/photo-1568569350062-ebfa3cb195df?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Honey',
      calories: 304,
      image:
          'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Cinnamon',
      calories: 247,
      image:
          'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Salt',
      calories: 0,
      image:
          'https://images.unsplash.com/photo-1501430654243-c934cec2e1c0?w=400&h=400&fit=crop',
    ),
    const Ingredient(
      name: 'Baking Powder',
      calories: 53,
      image:
          'https://images.unsplash.com/photo-1584949091598-c31daaaa4aa9?w=400&h=400&fit=crop',
    ),
  ];

  // Fake recipes data
  static final _fakeRecipes = [
    Recipe(
      id: '1',
      title: 'Classic Vanilla Cake',
      image:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800&h=600&fit=crop',
      steps: const [
        'Preheat oven to 350°F (175°C)',
        'Mix dry ingredients: flour, baking powder, salt',
        'Cream butter and sugar until fluffy',
        'Add eggs one at a time, then vanilla',
        'Alternate adding dry ingredients and milk',
        'Pour into greased pan and bake for 30-35 minutes',
      ],
      ingredients: [
        _fakeIngredients[2], // Flour
        _fakeIngredients[0], // Milk
        _fakeIngredients[1], // Eggs
        _fakeIngredients[3], // Vanilla
        _fakeIngredients[4], // Sugar
        _fakeIngredients[5], // Butter
        _fakeIngredients[14], // Baking Powder
      ],
    ),
    Recipe(
      id: '2',
      title: 'Chocolate Chip Cookies',
      image:
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=800&h=600&fit=crop',
      steps: const [
        'Preheat oven to 375°F (190°C)',
        'Mix flour, baking soda, and salt',
        'Beat butter with sugars until creamy',
        'Add eggs and vanilla',
        'Gradually blend in flour mixture',
        'Stir in chocolate chips',
        'Drop onto ungreased cookie sheets',
        'Bake for 9-11 minutes',
      ],
      ingredients: [
        _fakeIngredients[2], // Flour
        _fakeIngredients[1], // Eggs
        _fakeIngredients[3], // Vanilla
        _fakeIngredients[4], // Sugar
        _fakeIngredients[5], // Butter
        _fakeIngredients[6], // Chocolate
      ],
    ),
    Recipe(
      id: '3',
      title: 'Banana Bread',
      image:
          'https://images.unsplash.com/photo-1632931057819-4eefffa8e007?w=400&h=400&fit=crop',
      steps: const [
        'Preheat oven to 350°F (175°C)',
        'Mash ripe bananas in a bowl',
        'Mix in melted butter',
        'Add sugar, egg, and vanilla',
        'Sprinkle in baking soda and salt',
        'Add flour and mix until just combined',
        'Pour into loaf pan and bake for 60-65 minutes',
      ],
      ingredients: [
        _fakeIngredients[8], // Banana
        _fakeIngredients[2], // Flour
        _fakeIngredients[1], // Eggs
        _fakeIngredients[3], // Vanilla
        _fakeIngredients[4], // Sugar
        _fakeIngredients[5], // Butter
      ],
    ),
    Recipe(
      id: '4',
      title: 'Apple Pie',
      image:
          'https://images.unsplash.com/photo-1568571780765-9276ac8b75a2?w=800&h=600&fit=crop',
      steps: const [
        'Make pie crust with flour and butter',
        'Peel and slice apples',
        'Mix apples with sugar, cinnamon, and lemon juice',
        'Roll out bottom crust and place in pie pan',
        'Add apple filling',
        'Cover with top crust and seal edges',
        'Bake at 425°F for 15 minutes, then 350°F for 35-45 minutes',
      ],
      ingredients: [
        _fakeIngredients[9], // Apple
        _fakeIngredients[2], // Flour
        _fakeIngredients[4], // Sugar
        _fakeIngredients[5], // Butter
        _fakeIngredients[12], // Cinnamon
        _fakeIngredients[10], // Lemon
      ],
    ),
    Recipe(
      id: '5',
      title: 'Strawberry Smoothie',
      image:
          'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=800&h=600&fit=crop',
      steps: const [
        'Wash and hull strawberries',
        'Add strawberries to blender',
        'Pour in milk',
        'Add honey for sweetness',
        'Add a few ice cubes',
        'Blend until smooth',
        'Serve immediately',
      ],
      ingredients: [
        _fakeIngredients[7], // Strawberry
        _fakeIngredients[0], // Milk
        _fakeIngredients[11], // Honey
      ],
    ),
  ];

  @override
  Stream<List<Recipe>> getRecipes() {
    return _recipesStreamController.asBroadcastStream();
  }

  @override
  Future<Recipe> getRecipe(String id) async {
    await _simulateNetworkDelay();
    final recipe = _fakeRecipes.firstWhere(
      (recipe) => recipe.id == id,
      orElse: () => throw RecipeNotFoundException(),
    );
    return recipe;
  }

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    await _simulateNetworkDelay();
    final recipes = [..._recipesStreamController.value];
    final recipeIndex = recipes.indexWhere((r) => r.id == recipe.id);

    if (recipeIndex >= 0) {
      recipes[recipeIndex] = recipe;
    } else {
      recipes.add(recipe);
    }

    _recipesStreamController.add(recipes);
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    await _simulateNetworkDelay();
    final recipes = [..._recipesStreamController.value];
    final recipeIndex = recipes.indexWhere((r) => r.id == recipe.id);

    if (recipeIndex == -1) {
      throw RecipeNotFoundException();
    }

    recipes[recipeIndex] = recipe;
    _recipesStreamController.add(recipes);
  }

  @override
  Future<void> deleteRecipe(String id) async {
    await _simulateNetworkDelay();
    final recipes = [..._recipesStreamController.value];
    final recipeIndex = recipes.indexWhere((r) => r.id == id);

    if (recipeIndex == -1) {
      throw RecipeNotFoundException();
    }

    recipes.removeAt(recipeIndex);
    _recipesStreamController.add(recipes);
  }

  @override
  Future<List<Recipe>> getAllRecipes() async {
    await _simulateNetworkDelay();
    return _recipesStreamController.value;
  }

  @override
  Future<List<Recipe>> getRecipesWithIngredients(
      List<String> ingredientNames,) async {
    await _simulateNetworkDelay();

    // Check if ingredients match cake recipe (Milk, Eggs, Flour)
    final cakeIngredients = {'milk', 'eggs', 'flour'};
    final providedIngredients =
        ingredientNames.map((name) => name.toLowerCase()).toSet();

    if (cakeIngredients.every(providedIngredients.contains)) {
      // Return the vanilla cake recipe
      return [_fakeRecipes[0]];
    }

    // Otherwise return a random recipe from all recipes
    final allRecipes = await getAllRecipes();
    if (allRecipes.isEmpty) return [];

    final randomIndex = _random.nextInt(allRecipes.length);
    return [allRecipes[randomIndex]];
  }

  @override
  Future<List<Recipe>> searchRecipesByIngredients(
      List<String> ingredientNames,) async {
    await _simulateNetworkDelay();

    final lowercaseIngredientNames =
        ingredientNames.map((name) => name.toLowerCase()).toSet();

    return _recipesStreamController.value.where((recipe) {
      return recipe.ingredients.any((ingredient) {
        return lowercaseIngredientNames.contains(ingredient.name.toLowerCase());
      });
    }).toList();
  }

  @override
  Future<List<Ingredient>> getAllIngredients() async {
    await _simulateNetworkDelay();
    return _fakeIngredients;
  }

  @override
  Future<void> close() async {
    await _recipesStreamController.close();
  }

  /// Simulates network delay
  Future<void> _simulateNetworkDelay() async {
    await Future<void>.delayed(const Duration(seconds: 3));
  }
}
