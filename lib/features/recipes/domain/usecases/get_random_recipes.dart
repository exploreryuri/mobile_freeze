import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetRandomRecipes {
  final RecipeRepository repository;

  GetRandomRecipes(this.repository);

  Future<List<Recipe>> call(
      {int number = 1, String? includeTags, String? excludeTags}) async {
    return await repository.getRandomRecipes(
        number: number, includeTags: includeTags, excludeTags: excludeTags);
  }
}
