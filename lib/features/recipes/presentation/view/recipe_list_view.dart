import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_freeze/features/recipes/presentation/widgets/popular_recipe_card.dart';
import '../../domain/usecases/ger_recipe_by_category.dart';
import '../../domain/usecases/get_random_recipes.dart';
import '../../domain/usecases/get_recipe_information.dart';
import '../../domain/usecases/search_recipes_by_name.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';

class RecipeListScreen extends StatelessWidget {
  final String category;

  const RecipeListScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рецепты: $category'),
      ),
      body: BlocProvider(
        create: (context) => RecipeBloc(
          getRecipesByCategory: context.read<GetRecipesByCategory>(),
          searchRecipesByName: context.read<SearchRecipesByName>(),
          getRandomRecipes: context.read<GetRandomRecipes>(),
          getRecipeInformation: context.read<GetRecipeInformation>(),
        )..add(GetRecipesByCategoryEvent(category)),
        child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RecipeLoaded) {
              return ListView.builder(
                itemCount: state.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.recipes[index];
                  return PopularRecipeCard(
                    id: recipe.id,
                    title: recipe.title,
                    imageUrl: recipe.image,
                  );
                },
              );
            } else if (state is RecipeError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Нет рецептов'));
            }
          },
        ),
      ),
    );
  }
}
