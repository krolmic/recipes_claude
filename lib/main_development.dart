import 'package:recipes_claude/app/app.dart';
import 'package:recipes_claude/bootstrap.dart';

void main() {
  bootstrap((recipesRepository) => App(recipesRepository: recipesRepository));
}
