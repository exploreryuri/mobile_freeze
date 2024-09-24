import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'features/auth/data/source/auth_remote_data_source.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/domain/usecases/get_user.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/products/data/repositories/product_rep_impl.dart';
import 'features/products/data/source/database/remote/product_remote_service.dart';
import 'features/products/domain/usecases/add_product.dart';
import 'features/products/domain/usecases/update_product.dart';
import 'features/products/domain/usecases/delete_product.dart';
import 'features/products/domain/usecases/get_products.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/view/product_screen.dart';
import 'features/profile/presentation/view/profile_view.dart';
import 'features/recipes/data/repositories/recipe_repository_impl.dart';
import 'features/recipes/data/source/recipe_remote_data_source.dart';
import 'features/recipes/domain/usecases/ger_recipe_by_category.dart';
import 'features/recipes/domain/usecases/get_random_recipes.dart';
import 'features/recipes/domain/usecases/get_recipe_information.dart';
import 'features/recipes/domain/usecases/search_recipes_by_ingredients.dart';
import 'features/recipes/domain/usecases/search_recipes_by_name.dart';
import 'features/recipes/presentation/bloc/recipe_bloc.dart';
import 'features/recipes/presentation/bloc/recipe_event.dart';
import 'features/recipes/presentation/view/recipe_view.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/view/login_screen.dart';
import 'features/auth/presentation/view/signup_screen.dart';
import 'features/auth/presentation/view/welcome_screen.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseFirestore>.value(value: FirebaseFirestore.instance),
        Provider<firebase_auth.FirebaseAuth>.value(
            value: firebase_auth.FirebaseAuth.instance),
        Provider<AuthRemoteDataSourceImpl>(
          create: (context) => AuthRemoteDataSourceImpl(
            firebaseAuth: context.read<firebase_auth.FirebaseAuth>(),
            firestore: context.read<FirebaseFirestore>(),
          ),
        ),
        Provider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSourceImpl>(),
          ),
        ),
        Provider<SignIn>(
          create: (context) => SignIn(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        Provider<SignUp>(
          create: (context) => SignUp(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        Provider<SignOut>(
          create: (context) => SignOut(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        Provider<GetUser>(
          create: (context) => GetUser(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            signIn: context.read<SignIn>(),
            signUp: context.read<SignUp>(),
            signOut: context.read<SignOut>(),
            getUser: context.read<GetUser>(),
          )..add(AuthCheckRequested()),
        ),
        Provider<ProductRemoteService>(
          create: (context) => ProductRemoteService(
            firestore: context.read<FirebaseFirestore>(),
          ),
        ),
        Provider<ProductRepositoryImpl>(
          create: (context) => ProductRepositoryImpl(
            remoteService: context.read<ProductRemoteService>(),
          ),
        ),
        Provider<AddProduct>(
          create: (context) => AddProduct(
            context.read<ProductRepositoryImpl>(),
          ),
        ),
        Provider<UpdateProduct>(
          create: (context) => UpdateProduct(
            context.read<ProductRepositoryImpl>(),
          ),
        ),
        Provider<DeleteProduct>(
          create: (context) => DeleteProduct(
            context.read<ProductRepositoryImpl>(),
          ),
        ),
        Provider<GetProducts>(
          create: (context) => GetProducts(
            context.read<ProductRepositoryImpl>(),
          ),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(
            addProduct: context.read<AddProduct>(),
            updateProduct: context.read<UpdateProduct>(),
            deleteProduct: context.read<DeleteProduct>(),
            getProducts: context.read<GetProducts>(),
          ),
        ),
        Provider<RecipeRemoteDataSourceImpl>(
          create: (context) => RecipeRemoteDataSourceImpl(
            client: http.Client(),
          ),
        ),
        Provider<RecipeRepositoryImpl>(
          create: (context) => RecipeRepositoryImpl(
            remoteDataSource: context.read<RecipeRemoteDataSourceImpl>(),
          ),
        ),
        Provider<GetRecipesByCategory>(
          create: (context) => GetRecipesByCategory(
            context.read<RecipeRepositoryImpl>(),
          ),
        ),
        Provider<SearchRecipesByName>(
          create: (context) => SearchRecipesByName(
            context.read<RecipeRepositoryImpl>(),
          ),
        ),
        Provider<SearchRecipesByIngredients>(
          create: (context) => SearchRecipesByIngredients(
            context.read<RecipeRepositoryImpl>(),
          ),
        ),
        Provider<GetRecipeInformation>(
          create: (context) => GetRecipeInformation(
            context.read<RecipeRepositoryImpl>(),
          ),
        ),
        Provider<GetRandomRecipes>(
          create: (context) => GetRandomRecipes(
            context.read<RecipeRepositoryImpl>(),
          ),
        ),
        BlocProvider<RecipeBloc>(
          create: (context) => RecipeBloc(
            getRecipesByCategory: context.read<GetRecipesByCategory>(),
            searchRecipesByName: context.read<SearchRecipesByName>(),
            getRandomRecipes: context.read<GetRandomRecipes>(),
            getRecipeInformation: context.read<GetRecipeInformation>(),
          )..add(GetRandomRecipesEvent(
              number: 3)), // Инициируем получение случайного рецепта
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return MyHomePage();
                  } else if (state is AuthUnauthenticated) {
                    return WelcomeScreen();
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => MyHomePage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    RecipesScreen(),
    ProductScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.receipt,
              color: Colors.black,
            ),
            label: 'Рецепты',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            label: 'Продукты',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
