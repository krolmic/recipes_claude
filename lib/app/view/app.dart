import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipes_claude/ingredients/ingredients.dart';
import 'package:recipes_claude/l10n/l10n.dart';
import 'package:recipes_claude/recipe/view/recipe_page.dart';
import 'package:recipes_claude/recipes/recipes.dart';
import 'package:recipes_repository/recipes_repository.dart';
import 'package:toastification/toastification.dart';

class App extends StatelessWidget {
  const App({required this.recipesRepository, super.key});

  final RecipesRepository recipesRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: recipesRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => RecipesCubit(
          recipesRepository: context.read<RecipesRepository>(),
        ),
        child: ToastificationWrapper(
          child: MaterialApp.router(
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              useMaterial3: true,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}

// Route names
class AppRoutes {
  static const String ingredients = 'ingredients';
  static const String recipe = 'recipe';
}

// GoRouter configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.ingredients,
      builder: (context, state) => const IngredientsPage(),
    ),
    GoRoute(
      path: '/recipe',
      name: AppRoutes.recipe,
      builder: (context, state) => const RecipePage(),
    ),
  ],
);
