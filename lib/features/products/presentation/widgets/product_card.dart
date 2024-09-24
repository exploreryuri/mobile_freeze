import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../routes/hero_dialog_route.dart';
import 'product_detail_card.dart';
import 'product_progress_indicator.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final String userId;

  ProductCard({required this.product, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          HeroDialogRoute(
            builder: (context) => ProductDetailCard(
              product: product,
              userId: userId,
            ),
          ),
        );
      },
      child: Hero(
        tag: 'hero-${product.id}',
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ProductProgressIndicator(
                      addedDate: product.addedDate,
                      expiryDate: product.expiryDate,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
