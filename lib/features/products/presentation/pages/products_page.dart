// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mobile_freeze/features/products/domain/entities/product.dart';
// import 'package:mobile_freeze/features/products/presentation/bloc/product_bloc.dart';
// import 'package:mobile_freeze/features/products/presentation/bloc/product_event.dart';
// import 'package:mobile_freeze/features/products/presentation/bloc/product_state.dart';
// import 'package:riverpod/riverpod.dart';

// import '../../domain/usecases/implementations/add_product_impl.dart';
// import '../../domain/usecases/implementations/delete_all_expired_impl.dart';
// import '../../domain/usecases/implementations/delete_product_impl.dart';
// import '../../domain/usecases/implementations/get_products_impl.dart';
// import '../../domain/usecases/implementations/search_products_impl.dart';
// import '../../domain/usecases/implementations/update_product_impl.dart';

// class ProductPage extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final productBloc = watch(productBlocProvider);

//     return BlocProvider(
//       create: (context) => productBloc..add(LoadProducts()),
//       child: Scaffold(
//         appBar: AppBar(title: Text('Products')),
//         body: BlocBuilder<ProductBloc, ProductState>(
//           builder: (context, state) {
//             if (state is ProductLoadInProgress) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is ProductLoadSuccess) {
//               return ListView.builder(
//                 itemCount: state.products.length,
//                 itemBuilder: (context, index) {
//                   final product = state.products[index];
//                   return ListTile(
//                     title: Text(product.name),
//                     subtitle: Text('Expiry: ${product.expiryDate}'),
//                   );
//                 },
//               );
//             } else if (state is ProductLoadFailure) {
//               return Center(child: Text('Failed to load products'));
//             } else {
//               return Center(child: Text('Press the button to load products'));
//             }
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             final product = Product(
//                 id: '1',
//                 name: 'Product 1',
//                 expiryDate: DateTime.now().add(Duration(days: 1)));
//             context.read<ProductBloc>().add(AddProduct(product));
//           },
//           child: Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }

// final productBlocProvider = Provider((ref) => ProductBloc(
//       addProduct: ref.read(addProductUsecaseImplProvider.notifier),
//       updateProduct: ref.read(updateProductUsecaseImplProvider.notifier),
//       deleteProduct: ref.read(deleteProductUsecaseImplProvider.notifier),
//       getProducts: ref.read(getProductsUsecaseImplProvider.notifier),
//       searchProducts: ref.read(searchProductsUsecaseImplProvider.notifier),
//       deleteAllExpired: ref.read(deleteAllExpiredUsecaseImplProvider.notifier),
//     ));
