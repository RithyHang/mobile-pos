import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midterm/models/product.dart';
import 'package:midterm/repositories/product_repository.dart';
import 'package:midterm/database/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  void addToCart(Product product) {
    // TODO: implement your cart logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.name} added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ProductRepository.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        padding: const EdgeInsets.all(16),
        childAspectRatio: 0.85,
        children: products.map((product) {
          return TextButton(
            onPressed: () => addToCart(product),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  width: 0.65,
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: double.infinity,
                          minHeight: 120,
                          maxHeight: 160,
                        ),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(CupertinoIcons.cube,
                              size: 48, color: Color(0xFF99A1AF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(product.name,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 14, color: Colors.black)),
                    Text(product.category,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6A7282))),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 16, color: Color(0xFF00A63E))),
                        Text('Stock: ${product.stock}',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF6A7282))),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () async {
                      if (product.isFavorite) {
                        await DbHelper.instance.removeFavorite(product.id);
                      } else {
                        await DbHelper.instance.saveProductToFavorite(product);
                      }
                      setState(() {
                        product.isFavorite = !product.isFavorite;
                      });
                    },
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: product.isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}