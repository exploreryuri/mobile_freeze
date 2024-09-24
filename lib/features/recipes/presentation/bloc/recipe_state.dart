import 'package:equatable/equatable.dart';
import '../../data/models/recipe_model.dart';
import '../../domain/entities/recipe.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;

  const RecipeLoaded({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

class SearchRecipeLoaded extends RecipeState {
  final List<SearchRecipeModel> recipes;

  const SearchRecipeLoaded({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

class RecipeInformationLoaded extends RecipeState {
  final Recipe recipe;

  const RecipeInformationLoaded({required this.recipe});

  @override
  List<Object> get props => [recipe];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError({required this.message});

  @override
  List<Object> get props => [message];
}
