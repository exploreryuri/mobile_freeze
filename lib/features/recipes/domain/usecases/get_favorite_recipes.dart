import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetFavoriteRecipes {
  final RecipeRepository repository;

  GetFavoriteRecipes(this.repository);

  Future<List<Recipe>> call() async {
    return await repository.getFavoriteRecipes();
  }
}
