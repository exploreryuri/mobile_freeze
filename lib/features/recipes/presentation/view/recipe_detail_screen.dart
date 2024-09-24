import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';

class RecipeDetailScreen extends StatelessWidget {
  final int id;

  RecipeDetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Логика добавления в избранное
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => RecipeBloc(
          getRecipesByCategory: context.read(),
          searchRecipesByName: context.read(),
          getRandomRecipes: context.read(),
          getRecipeInformation: context.read(),
        )..add(GetRecipeInformationEvent(id)),
        child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipeInformationLoaded) {
              final recipe = state.recipe;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(recipe.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        recipe.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.readyInMinutes} мин.',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.leaderboard, color: Colors.grey),
                          const SizedBox(width: 4),
                          const Text(
                            'Легко', // Уровень сложности
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          // const Icon(Icons.local_fire_department,
                          //     color: Colors.grey),
                          // const SizedBox(width: 4),
                          // Text(
                          //   '${recipe.servings} ккал', // Калорийность, если доступно
                          //   style: const TextStyle(
                          //       fontSize: 16, color: Colors.grey),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        recipe.summary,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const Text(
                        'Ингредиенты',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...recipe.ingredients
                          .map((ingredient) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  ingredient,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ))
                          .toList(),
                      const SizedBox(height: 16),
                      const Divider(),
                      const Text(
                        'Способ приготовления',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...recipe.instructions
                          .map((instruction) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  instruction,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              );
            } else if (state is RecipeError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Загрузка рецепта...'));
            }
          },
        ),
      ),
    );
  }
}
