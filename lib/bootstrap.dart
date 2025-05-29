import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fake_recipes_api/fake_recipes_api.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes_repository/recipes_repository.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
    FutureOr<Widget> Function(RecipesRepository) builder,) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  final recipesApi = FakeRecipesApi();
  final recipesRepository = RecipesRepository(recipesApi: recipesApi);

  runApp(await builder(recipesRepository));
}
