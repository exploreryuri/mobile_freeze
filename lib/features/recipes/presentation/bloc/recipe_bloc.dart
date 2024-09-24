import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/ger_recipe_by_category.dart';
import '../../domain/usecases/get_random_recipes.dart';
import '../../domain/usecases/get_recipe_information.dart';
import '../../domain/usecases/search_recipes_by_name.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final GetRecipesByCategory getRecipesByCategory;
  final SearchRecipesByName searchRecipesByName;
  final GetRandomRecipes getRandomRecipes;
  final GetRecipeInformation getRecipeInformation;

  RecipeBloc({
    required this.getRecipesByCategory,
    required this.searchRecipesByName,
    required this.getRandomRecipes,
    required this.getRecipeInformation,
  }) : super(RecipeInitial()) {
    on<GetRecipesByCategoryEvent>((event, emit) async {
      emit(RecipeLoading());
      try {
        final recipes = await getRecipesByCategory(event.category);
        emit(RecipeLoaded(recipes: recipes));
      } catch (e) {
        emit(RecipeError(message: e.toString()));
      }
    });

    on<SearchRecipesByNameEvent>((event, emit) async {
      emit(RecipeLoading());
      try {
        final recipes = await searchRecipesByName(event.query);
        emit(SearchRecipeLoaded(recipes: recipes));
      } catch (e) {
        emit(RecipeError(message: e.toString()));
      }
    });

    on<GetRandomRecipesEvent>((event, emit) async {
      emit(RecipeLoading());
      try {
        final recipes = await getRandomRecipes(
            number: event.number,
            includeTags: event.includeTags,
            excludeTags: event.excludeTags);
        emit(RecipeLoaded(recipes: recipes));
      } catch (e) {
        emit(RecipeError(message: e.toString()));
      }
    });

    on<GetRecipeInformationEvent>((event, emit) async {
      emit(RecipeLoading());
      try {
        final recipe = await getRecipeInformation(event.id);
        emit(RecipeInformationLoaded(recipe: recipe));
      } catch (e) {
        emit(RecipeError(message: e.toString()));
      }
    });
  }
}
