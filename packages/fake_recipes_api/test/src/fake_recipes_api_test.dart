// ignore_for_file: prefer_const_constructors
import 'package:fake_recipes_api/fake_recipes_api.dart';
import 'package:test/test.dart';

void main() {
  group('FakeRecipesApi', () {
    test('can be instantiated', () {
      expect(FakeRecipesApi(), isNotNull);
    });
  });
}
