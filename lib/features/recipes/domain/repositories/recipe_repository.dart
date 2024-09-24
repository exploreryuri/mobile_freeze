import 'package:mobile_freeze/features/recipes/data/models/recipe_model.dart';

import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<SearchRecipeModel>> searchRecipesByName(String query);
  Future<List<Recipe>> searchRecipesByIngredients(List<String> ingredients);
  Future<List<Recipe>> getRecipesByCategory(String category);
  Future<Recipe> getRecipeInformation(int id);
  Future<List<Recipe>> getRandomRecipes(
      {required int number, String? includeTags, String? excludeTags});
  Future<void> addToFavorites(Recipe recipe);
  Future<List<Recipe>> getFavoriteRecipes();
}
