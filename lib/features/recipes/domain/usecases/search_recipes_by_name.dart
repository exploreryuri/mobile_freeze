import 'package:mobile_freeze/features/recipes/data/models/recipe_model.dart';

import '../repositories/recipe_repository.dart';

class SearchRecipesByName {
  final RecipeRepository repository;

  SearchRecipesByName(this.repository);

  Future<List<SearchRecipeModel>> call(String query) async {
    return await repository.searchRecipesByName(query);
  }
}
