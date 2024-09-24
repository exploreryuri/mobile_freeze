import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String userName = 'Пользователь'; // Имя по умолчанию
    String userProfileImage = 'profileImageURL';

    if (authState is AuthAuthenticated) {
      userName = authState.user.name;
      userProfileImage = authState.user.profileImageUrl;
      print(userProfileImage);
    }
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.black),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(AuthSignOutRequested());
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(userProfileImage),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // const Row(
                        //   children: [
                        //     Column(
                        //       children: [
                        //         Text('15',
                        //             style: TextStyle(
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.bold)),
                        //         Text('рецепты',
                        //             style: TextStyle(
                        //                 fontSize: 14, color: Colors.grey)),
                        //       ],
                        //     ),
                        //     SizedBox(width: 16),
                        //     Column(
                        //       children: [
                        //         Text('38',
                        //             style: TextStyle(
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.bold)),
                        //         Text('подписчики',
                        //             style: TextStyle(
                        //                 fontSize: 14, color: Colors.grey)),
                        //       ],
                        //     ),
                        //     SizedBox(width: 16),
                        //     Column(
                        //       children: [
                        //         Text('76',
                        //             style: TextStyle(
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.bold)),
                        //         Text('подписки',
                        //             style: TextStyle(
                        //                 fontSize: 14, color: Colors.grey)),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
                // const SizedBox(height: 16),
                // const Text(
                //   'Здесь я публикую вкусные блюда на каждый день, готовые удивить вашу вторую половинку или вашего ребёнка. Подписывайтесь к моей "Книге рецептов"! Всего вам светлого!',
                //   style: TextStyle(fontSize: 14),
                // ),
                // const SizedBox(height: 16),
                // const Text(
                //   'Моя семья',
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     FamilyMemberAvatar(
                //         label: 'М',
                //         imageUrl: 'https://via.placeholder.com/100'),
                //     FamilyMemberAvatar(
                //         label: 'Ю',
                //         imageUrl: 'https://via.placeholder.com/100'),
                //     FamilyMemberAvatar(
                //         label: 'Кот',
                //         imageUrl: 'https://via.placeholder.com/100'),
                //     FamilyMemberAvatar(
                //         label: 'Шеф',
                //         imageUrl: 'https://via.placeholder.com/100'),
                //   ],
                // ),
                const SizedBox(height: 16),
                const Text(
                  'Недавние рецепты',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    RecipeCard(
                        label: 'Пельмени',
                        imageUrl: 'https://via.placeholder.com/150'),
                    RecipeCard(
                        label: 'Сырники',
                        imageUrl: 'https://via.placeholder.com/150'),
                    RecipeCard(
                        label: 'Бургер',
                        imageUrl: 'https://via.placeholder.com/150'),
                    RecipeCard(
                        label: 'Бутерброд',
                        imageUrl: 'https://via.placeholder.com/150'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FamilyMemberAvatar extends StatelessWidget {
  final String label;
  final String imageUrl;

  FamilyMemberAvatar({required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String label;
  final String imageUrl;

  RecipeCard({required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
