import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_state.dart';
import '../widgets/popular_recipe_card.dart';
import 'categorial_screen.dart';
import 'recipe_list_view.dart';
import 'search_results_screen.dart';

class RecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    final authState = context.watch<AuthBloc>().state;
    String userName = 'Пользователь'; // Имя по умолчанию

    if (authState is AuthAuthenticated) {
      userName = authState.user.name; // Предполагаем, что в user есть поле name
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Привет, $userName',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Чтобы вы хотели сегодня приготовить?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Паста карбонара',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: (query) {
                        if (query.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SearchResultsScreen(query: query),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      final query = _searchController.text;
                      if (query.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchResultsScreen(query: query),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Категории',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesScreen()),
                      );
                    },
                    child: const Text(
                      'Ещё',
                      style: TextStyle(fontSize: 18, color: Colors.green),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryCard(
                    label: 'Завтрак',
                    icon: Icons.breakfast_dining,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeListScreen(category: 'breakfast'),
                        ),
                      );
                    },
                  ),
                  CategoryCard(
                    label: 'Обед',
                    icon: Icons.rice_bowl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeListScreen(category: 'lunch'),
                        ),
                      );
                    },
                  ),
                  CategoryCard(
                    label: 'Ужин',
                    icon: Icons.dinner_dining,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeListScreen(category: 'dinner'),
                        ),
                      );
                    },
                  ),
                  CategoryCard(
                    label: 'Закуски',
                    icon: Icons.emoji_food_beverage,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeListScreen(category: 'appetizer'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Рецепты дня',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ещё',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BlocBuilder<RecipeBloc, RecipeState>(
                builder: (context, state) {
                  if (state is RecipeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RecipeLoaded) {
                    return Column(
                      children: state.recipes.map((recipe) {
                        return PopularRecipeCard(
                          id: recipe.id,
                          imageUrl: recipe.image,
                          title: recipe.title,
                        );
                      }).toList(),
                    );
                  } else if (state is RecipeError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(
                        child: Text('Введите запрос для поиска рецептов.'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  CategoryCard({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
