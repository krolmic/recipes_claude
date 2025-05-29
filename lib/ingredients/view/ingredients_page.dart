import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipes_claude/app/app.dart';
import 'package:recipes_claude/recipes/recipes.dart';
import 'package:toastification/toastification.dart';

class IngredientsPage extends StatelessWidget {
  const IngredientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger loading ingredients when the page is built
    context.read<RecipesCubit>().getAllIngredients();
    return const IngredientsView();
  }
}

class IngredientsView extends StatelessWidget {
  const IngredientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipesCubit, RecipesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == RecipesStatus.failure,
      listener: (context, state) {
        if (state.errorMessage != null) {
          toastification.show(
            context: context,
            title: Text(state.errorMessage!),
            type: state.errorMessage!.contains('up to 3')
                ? ToastificationType.warning
                : ToastificationType.error,
            style: ToastificationStyle.flat,
            autoCloseDuration: const Duration(seconds: 4),
            alignment: Alignment.topCenter,
            animationDuration: const Duration(milliseconds: 300),
            icon: Icon(
              state.errorMessage!.contains('up to 3')
                  ? Icons.warning_amber_rounded
                  : Icons.error_outline_rounded,
            ),
            backgroundColor: state.errorMessage!.contains('up to 3')
                ? Colors.orange.shade50
                : Colors.red.shade50,
            foregroundColor: state.errorMessage!.contains('up to 3')
                ? Colors.orange.shade900
                : Colors.red.shade900,
            showProgressBar: false,
          );
        }
      },
      child: const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: SafeArea(
          child: IngredientsContent(),
        ),
      ),
    );
  }
}

class IngredientsContent extends StatelessWidget {
  const IngredientsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with menu and profile
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, size: 28),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Title
          const Text(
            'Do you want tasty?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Enter up to 3 ingredients',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Search field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type your ingredients',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Ingredients list
          Expanded(
            child: BlocBuilder<RecipesCubit, RecipesState>(
              builder: (context, state) {
                if (state.status == RecipesStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                  itemCount: state.ingredients.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ingredient = state.ingredients[index];
                    final isSelected =
                        state.selectedIngredients.contains(ingredient);

                    return GestureDetector(
                      onTap: () {
                        context
                            .read<RecipesCubit>()
                            .toggleIngredient(ingredient);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6C5CE7).withValues(alpha: 0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF6C5CE7)
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Ingredient image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                ingredient.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.restaurant,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Ingredient name
                            Expanded(
                              child: Text(
                                ingredient.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF6C5CE7)
                                      : Colors.black87,
                                ),
                              ),
                            ),

                            // Calories
                            Text(
                              '${ingredient.calories} calories',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),

                            // Selection indicator
                            if (isSelected) ...[
                              const SizedBox(width: 12),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6C5CE7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Find recipes button
          BlocBuilder<RecipesCubit, RecipesState>(
            builder: (context, state) {
              final hasSelection = state.selectedIngredients.isNotEmpty;

              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: hasSelection
                      ? () {
                          context
                              .read<RecipesCubit>()
                              .getRecipeWithIngredients();
                          context.pushNamed(AppRoutes.recipe);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Find recipe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: hasSelection ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
