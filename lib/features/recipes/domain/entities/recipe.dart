class Recipe {
  final int id;
  final String title;
  final String summary;
  final int readyInMinutes;
  final String image;
  final List<String> ingredients;
  final List<String> dishTypes;
  final List<String> cuisines;
  final List<String> instructions;
  final int servings;

  Recipe({
    required this.id,
    required this.title,
    required this.summary,
    required this.readyInMinutes,
    required this.image,
    required this.ingredients,
    required this.dishTypes,
    required this.cuisines,
    required this.instructions,
    required this.servings,
  });
}
