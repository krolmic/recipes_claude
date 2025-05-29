import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipes_api/recipes_api.dart';
import 'package:recipes_repository/recipes_repository.dart';

part 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  RecipesCubit({
    required RecipesRepository recipesRepository,
  })  : _recipesRepository = recipesRepository,
        super(const RecipesState());

  final RecipesRepository _recipesRepository;

  Future<void> getAllIngredients() async {
    emit(state.copyWith(status: RecipesStatus.loading));
    try {
      final ingredients = await _recipesRepository.getAllIngredients();
      emit(
        state.copyWith(
          status: RecipesStatus.success,
          ingredients: ingredients,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RecipesStatus.failure,
          errorMessage: 'Failed to load ingredients',
        ),
      );
    }
  }

  void toggleIngredient(Ingredient ingredient) {
    final selectedIngredients =
        List<Ingredient>.from(state.selectedIngredients);

    if (selectedIngredients.contains(ingredient)) {
      selectedIngredients.remove(ingredient);
    } else {
      // Limit selection to 3 ingredients
      if (selectedIngredients.length >= 3) {
        emit(
          state.copyWith(
            status: RecipesStatus.failure,
            errorMessage: 'You can select up to 3 ingredients only',
          ),
        );
        return;
      }
      selectedIngredients.add(ingredient);
    }

    emit(
      state.copyWith(
        selectedIngredients: selectedIngredients,
        status: RecipesStatus.success, // Clear any error status
      ),
    );
  }

  Future<void> getRecipesWithSelectedIngredients() async {
    if (state.selectedIngredients.isEmpty) {
      emit(
        state.copyWith(
          status: RecipesStatus.failure,
          errorMessage: 'Please select at least one ingredient',
        ),
      );
      return;
    }

    emit(state.copyWith(status: RecipesStatus.loading));
    try {
      final ingredientNames = state.selectedIngredients
          .map((ingredient) => ingredient.name)
          .toList();

      final recipes =
          await _recipesRepository.getRecipesWithIngredients(ingredientNames);

      emit(
        state.copyWith(
          status: RecipesStatus.success,
          recipes: recipes,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RecipesStatus.failure,
          errorMessage: 'Failed to load recipes',
        ),
      );
    }
  }

  Future<void> getRecipeWithIngredients() async {
    emit(state.copyWith(recipeStatus: RecipeStatus.loading));
    try {
      final ingredientNames = state.selectedIngredients
          .map((ingredient) => ingredient.name)
          .toList();
      final recipes = await _recipesRepository.getRecipesWithIngredients(
        ingredientNames,
      );

      if (recipes.isNotEmpty) {
        emit(
          state.copyWith(
            recipeStatus: RecipeStatus.success,
            recipe: recipes.first,
          ),
        );
      } else {
        emit(
          state.copyWith(
            recipeStatus: RecipeStatus.failure,
            errorMessage: 'No recipes found with selected ingredients',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          recipeStatus: RecipeStatus.failure,
          errorMessage: 'Failed to load recipe',
        ),
      );
    }
  }
}
