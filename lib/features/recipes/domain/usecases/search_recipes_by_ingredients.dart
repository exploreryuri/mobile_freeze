import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class SearchRecipesByIngredients {
  final RecipeRepository repository;

  SearchRecipesByIngredients(this.repository);

  Future<List<Recipe>> call(List<String> ingredients) async {
    return await repository.searchRecipesByIngredients(ingredients);
  }
}
