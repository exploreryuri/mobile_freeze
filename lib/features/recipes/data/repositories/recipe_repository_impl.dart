import 'package:mobile_freeze/features/recipes/data/models/recipe_model.dart';

import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../source/recipe_remote_data_source.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;

  RecipeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SearchRecipeModel>> searchRecipesByName(String query) async {
    return await remoteDataSource.searchRecipesByName(query);
  }

  @override
  Future<List<Recipe>> searchRecipesByIngredients(
      List<String> ingredients) async {
    return await remoteDataSource.searchRecipesByIngredients(ingredients);
  }

  @override
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    return await remoteDataSource.getRecipesByCategory(category);
  }

  @override
  Future<Recipe> getRecipeInformation(int id) async {
    return await remoteDataSource.getRecipeInformation(id);
  }

  @override
  Future<List<Recipe>> getRandomRecipes(
      {int number = 1, String? includeTags, String? excludeTags}) async {
    return await remoteDataSource.getRandomRecipes(
        number: number, includeTags: includeTags, excludeTags: excludeTags);
  }

  @override
  Future<void> addToFavorites(Recipe recipe) async {
    // Implementation for adding recipe to favorites
  }

  @override
  Future<List<Recipe>> getFavoriteRecipes() async {
    // Implementation for retrieving favorite recipes
    return [];
  }
}
