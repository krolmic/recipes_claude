import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:recipes_api/recipes_api.dart';
import 'package:recipes_claude/app/app.dart';
import 'package:recipes_claude/recipes/recipes.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
        backgroundColor: Colors.white,
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
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          SizedBox(height: 30),
          _TitleSection(),
          SizedBox(height: 24),
          _SearchField(),
          SizedBox(height: 24),
          _IngredientsList(),
          SizedBox(height: 20),
          _FindRecipeButton(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Iconsax.menu, size: 28),
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Do you want tasty?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter up to 3 ingredients',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
        hintText: 'Type your ingredients',
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(Iconsax.search_normal_1_copy, color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

class _IngredientsList extends StatelessWidget {
  const _IngredientsList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<RecipesCubit, RecipesState>(
        builder: (context, state) {
          if (state.status == RecipesStatus.loading) {
            return const _SkeletonList();
          }
          return _LoadedList(
            ingredients: state.ingredients,
            selectedIngredients: state.selectedIngredients,
          );
        },
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => const _SkeletonItem(),
      ),
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  const _SkeletonItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF706DFF).withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.transparent,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Ingredient name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '100 calories',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadedList extends StatelessWidget {
  const _LoadedList({
    required this.ingredients,
    required this.selectedIngredients,
  });

  final List<Ingredient> ingredients;
  final List<Ingredient> selectedIngredients;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: ingredients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        final isSelected = selectedIngredients.contains(ingredient);
        return _IngredientItem(
          ingredient: ingredient,
          isSelected: isSelected,
        );
      },
    );
  }
}

class _IngredientItem extends StatelessWidget {
  const _IngredientItem({
    required this.ingredient,
    required this.isSelected,
  });

  final Ingredient ingredient;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<RecipesCubit>().toggleIngredient(ingredient);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF706DFF).withValues(alpha: 0.1)
              : const Color(0xFF706DFF).withValues(alpha: 0.025),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF706DFF) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            _IngredientImage(image: ingredient.image),
            const SizedBox(width: 16),
            _IngredientName(
              name: ingredient.name,
              isSelected: isSelected,
            ),
            _CaloriesText(calories: ingredient.calories),
            if (isSelected) const _SelectionIndicator(),
          ],
        ),
      ),
    );
  }
}

class _IngredientImage extends StatelessWidget {
  const _IngredientImage({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 50,
          height: 50,
          color: Colors.grey[300],
          child: const Icon(
            Icons.restaurant,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _IngredientName extends StatelessWidget {
  const _IngredientName({
    required this.name,
    required this.isSelected,
  });

  final String name;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isSelected ? const Color(0xFF706DFF) : Colors.black87,
        ),
      ),
    );
  }
}

class _CaloriesText extends StatelessWidget {
  const _CaloriesText({required this.calories});

  final int calories;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$calories calories',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 12),
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF706DFF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 16,
          ),
        ),
      ],
    );
  }
}

class _FindRecipeButton extends StatelessWidget {
  const _FindRecipeButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesCubit, RecipesState>(
      builder: (context, state) {
        final hasSelection = state.selectedIngredients.isNotEmpty;

        return SizedBox(
          width: double.infinity,
          height: 80,
          child: ElevatedButton(
            onPressed: hasSelection
                ? () {
                    context.read<RecipesCubit>().getRecipeWithIngredients();
                    context.pushNamed(AppRoutes.recipe);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF706DFF),
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
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
    );
  }
}
