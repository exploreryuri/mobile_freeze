import 'package:flutter/material.dart';

import 'recipe_list_view.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'titleRus': 'Первые блюда',
        'title': 'main course',
        'image': 'assets/first_course.jpg'
      },
      {
        'titleRus': 'Вторые блюда',
        'title': '',
        'image': 'assets/second_course.jpg'
      },
      {
        'titleRus': 'Закуска',
        'title': 'appetizer',
        'image': 'assets/appetizer.jpg'
      },
      {'titleRus': 'Салаты', 'title': 'salad', 'image': 'assets/salad.jpg'},
      {'titleRus': 'Соусы', 'title': 'sauce', 'image': 'assets/sauces.jpg'},
      {'titleRus': 'Напитки', 'title': 'drink', 'image': 'assets/drinks.jpg'},
      {
        'titleRus': 'Десерты',
        'title': 'dessert',
        'image': 'assets/desserts.jpg'
      },
      {'titleRus': 'Выпечки', 'title': 'bread', 'image': 'assets/bakery.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeListScreen(category: category['title']!),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(category['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          category['titleRus']!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
