import 'package:html/parser.dart' show parse;
import '../../domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  RecipeModel({
    required int id,
    required String title,
    required String summary,
    required int readyInMinutes,
    required String image,
    required List<String> ingredients,
    required List<String> dishTypes,
    required List<String> cuisines,
    required List<String> instructions,
    required int servings,
  }) : super(
          id: id,
          title: title,
          summary: summary,
          readyInMinutes: readyInMinutes,
          image: image,
          ingredients: ingredients,
          dishTypes: dishTypes,
          cuisines: cuisines,
          instructions: instructions,
          servings: servings,
        );

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Без названия',
      summary: _parseHtmlString(json['summary'] ?? 'Описание отсутствует'),
      readyInMinutes: json['readyInMinutes'] ?? 0,
      image: json['image'] ?? 'https://via.placeholder.com/150',
      ingredients: List<String>.from(
          json['extendedIngredients']?.map((x) => x['original'] ?? '') ?? []),
      dishTypes: List<String>.from(json['dishTypes'] ?? []),
      cuisines: List<String>.from(json['cuisines'] ?? []),
      instructions: json['analyzedInstructions'] != null &&
              json['analyzedInstructions'].isNotEmpty
          ? List<String>.from(json['analyzedInstructions'][0]['steps']
                  ?.map((step) => step['step'] ?? '') ??
              [])
          : [],
      servings: json['servings'] ?? 1,
    );
  }

  static String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body?.text).documentElement?.text ?? '';
    return parsedString;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'readyInMinutes': readyInMinutes,
      'image': image,
      'extendedIngredients': ingredients.map((x) => {'original': x}).toList(),
      'dishTypes': dishTypes,
      'cuisines': cuisines,
      'analyzedInstructions': [
        {
          'steps': instructions.map((x) => {'step': x}).toList()
        }
      ],
      'servings': servings,
    };
  }
}

class SearchRecipeModel {
  final int id;
  final String title;
  final String image;

  SearchRecipeModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory SearchRecipeModel.fromJson(Map<String, dynamic> json) {
    return SearchRecipeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Без названия',
      image: json['image'] ?? 'https://via.placeholder.com/150',
    );
  }
}
