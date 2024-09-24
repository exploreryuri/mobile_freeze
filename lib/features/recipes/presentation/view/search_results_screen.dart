import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import '../widgets/popular_recipe_card.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  SearchResultsScreen({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Результаты поиска'),
      ),
      body: BlocProvider(
        create: (context) => RecipeBloc(
          getRecipesByCategory: context.read(),
          searchRecipesByName: context.read(),
          getRandomRecipes: context.read(),
          getRecipeInformation: context.read(),
        )..add(SearchRecipesByNameEvent(query)),
        child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SearchRecipeLoaded) {
              return ListView.builder(
                itemCount: state.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.recipes[index];
                  return PopularRecipeCard(
                    id: recipe.id,
                    imageUrl: recipe.image,
                    title: recipe.title,
                  );
                },
              );
            } else if (state is RecipeError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Введите запрос для поиска рецептов.'));
            }
          },
        ),
      ),
    );
  }
}
