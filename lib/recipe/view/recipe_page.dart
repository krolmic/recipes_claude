import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:recipes_api/recipes_api.dart';
import 'package:recipes_claude/recipes/recipes.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:toastification/toastification.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RecipeView();
  }
}

class RecipeView extends StatelessWidget {
  const RecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipesCubit, RecipesState>(
      listenWhen: (previous, current) =>
          previous.recipeStatus != current.recipeStatus &&
          current.recipeStatus == RecipeStatus.failure,
      listener: (context, state) {
        if (state.errorMessage != null) {
          toastification.show(
            context: context,
            title: Text(state.errorMessage!),
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            autoCloseDuration: const Duration(seconds: 4),
            alignment: Alignment.topCenter,
            animationDuration: const Duration(milliseconds: 300),
            icon: const Icon(Icons.error_outline_rounded),
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red.shade900,
            showProgressBar: false,
          );
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RecipeContent(),
        ),
      ),
    );
  }
}

class RecipeContent extends StatefulWidget {
  const RecipeContent({super.key});

  @override
  State<RecipeContent> createState() => _RecipeContentState();
}

class _RecipeContentState extends State<RecipeContent> {
  late PageController _pageController;
  int _currentStep = 0;
  bool _showCompletionOverlay = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showCompletionAnimation() {
    setState(() {
      _showCompletionOverlay = true;
    });
  }

  void _hideCompletionOverlay() {
    setState(() {
      _showCompletionOverlay = false;
    });
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<RecipesCubit, RecipesState>(
          builder: (context, state) {
            if (state.recipeStatus == RecipeStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.recipe == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No recipe found',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Go back'),
                    ),
                  ],
                ),
              );
            }

            final recipe = state.recipe!;
            final totalSteps = recipe.steps.length;

            return LayoutBuilder(
              builder: (
                BuildContext context,
                BoxConstraints viewportConstraints,
              ) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: _Header(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _RecipeTitle(recipe: recipe),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 3,
                        child: _RecipeImage(recipe: recipe),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(48),
                            color: Colors.grey.shade50,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.soup_kitchen_outlined,
                                    color: Color(0xFF6C5CE7),
                                    size: 36,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Cooking process',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Step ${_currentStep + 1}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              StepProgressIndicator(
                                totalSteps: totalSteps,
                                currentStep: _currentStep + 1,
                                selectedColor: const Color(0xFF706DFF),
                                unselectedColor: Colors.grey[300]!,
                                roundedEdges: const Radius.circular(12),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: _buildRecipeSteps(totalSteps, recipe),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        if (_showCompletionOverlay) _buildCompletionOverlay(),
      ],
    );
  }

  PageView _buildRecipeSteps(int totalSteps, Recipe recipe) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentStep = index;
        });
      },
      itemCount: totalSteps,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.steps[index],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (index > 0)
                  TextButton.icon(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    label: const Text('Previous'),
                  )
                else
                  const SizedBox.shrink(),
                if (index < totalSteps - 1)
                  ElevatedButton.icon(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF706DFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          28,
                        ),
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: _showCompletionAnimation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF706DFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                    child: const Text('Done'),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  AnimatedOpacity _buildCompletionOverlay() {
    return AnimatedOpacity(
      opacity: _showCompletionOverlay ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: ColoredBox(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.tick_square_copy,
                      size: 150,
                      color: Color(0xFF706DFF),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'You did it!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The dish is successfully cooked!',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: _hideCompletionOverlay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        image: DecorationImage(
          image: NetworkImage(recipe.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _RecipeTitle extends StatelessWidget {
  const _RecipeTitle({
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Text(
      recipe.title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Search',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.normal,
              ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Iconsax.search_normal_1_copy,
            size: 18,
          ),
        ),
      ],
    );
  }
}
