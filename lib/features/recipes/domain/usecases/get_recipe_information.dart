import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetRecipeInformation {
  final RecipeRepository repository;

  GetRecipeInformation(this.repository);

  Future<Recipe> call(int id) async {
    return await repository.getRecipeInformation(id);
  }
}
