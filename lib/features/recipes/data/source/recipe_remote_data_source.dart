import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<SearchRecipeModel>> searchRecipesByName(String query);
  Future<List<RecipeModel>> searchRecipesByIngredients(
      List<String> ingredients);
  Future<List<RecipeModel>> getRecipesByCategory(String category);
  Future<RecipeModel> getRecipeInformation(int id);
  Future<List<RecipeModel>> getRandomRecipes(
      {int number, String? includeTags, String? excludeTags});
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final http.Client client;
  static const baseUrl = 'https://api.spoonacular.com/recipes';
  static const apiKey = 'b13b2b72e51846cda399ca45e11a54c6';

  RecipeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RecipeModel>> getRandomRecipes(
      {int number = 1, String? includeTags, String? excludeTags}) async {
    final response = await client
        .get(Uri.parse('$baseUrl/random?number=$number&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> recipesJson = jsonResponse['recipes'];
      return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load random recipes');
    }
  }

  @override
  Future<List<RecipeModel>> searchRecipesByIngredients(
      List<String> ingredients) async {
    final ingredientsString = ingredients.join(',');
    final response = await client.get(Uri.parse(
        '$baseUrl/complexSearch?includeIngredients=$ingredientsString&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> recipesJson = jsonResponse['results'];
      return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Future<List<RecipeModel>> getRecipesByCategory(String category) async {
    final response = await client.get(Uri.parse(
        '$baseUrl/random?include-tags=$category&number=5&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> recipesJson = jsonResponse['recipes'];
      return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Future<List<SearchRecipeModel>> searchRecipesByName(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/complexSearch?query=$query&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> recipesJson = jsonResponse['results'];
      return recipesJson
          .map((json) => SearchRecipeModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Future<RecipeModel> getRecipeInformation(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$id/information?apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return RecipeModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load recipe information');
    }
  }
}
