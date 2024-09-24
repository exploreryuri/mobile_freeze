import 'package:equatable/equatable.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class GetRecipesByCategoryEvent extends RecipeEvent {
  final String category;

  const GetRecipesByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class SearchRecipesByNameEvent extends RecipeEvent {
  final String query;

  const SearchRecipesByNameEvent(this.query);

  @override
  List<Object> get props => [query];
}

class GetRandomRecipesEvent extends RecipeEvent {
  final int number;
  final String? includeTags;
  final String? excludeTags;

  const GetRandomRecipesEvent(
      {required this.number, this.includeTags, this.excludeTags});

  @override
  List<Object> get props => [number, includeTags ?? '', excludeTags ?? ''];
}

class GetRecipeInformationEvent extends RecipeEvent {
  final int id;

  const GetRecipeInformationEvent(this.id);

  @override
  List<Object> get props => [id];
}
