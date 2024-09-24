import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class AddToFavorites {
  final RecipeRepository repository;

  AddToFavorites(this.repository);

  Future<void> call(Recipe recipe) async {
    return await repository.addToFavorites(recipe);
  }
}
