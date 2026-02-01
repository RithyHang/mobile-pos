import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:midterm/repositories/product_repository.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  dynamic detailedProduct;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  // Requirement: Fetch product detail by ID
  Future<void> _fetchProductDetails() async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products/${widget.product.id}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        detailedProduct = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Requirement: Display Image
                  Center(
                    child: Image.network(detailedProduct['image'], height: 250),
                  ),
                  const SizedBox(height: 20),

                  // Requirement: Display Name
                  Text(
                    detailedProduct['title'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Requirement: Display Price
                  Text(
                    '\$${detailedProduct['price']}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF00A63E),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Requirement: Display Description
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(detailedProduct['description']),

                  const SizedBox(height: 30),

                  // Add to cart button
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00A63E)),
                  //     onPressed: () {
                  //       ProductRepository.addToCart(widget.product);

                  //       // Providing feedback
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(content: Text("Added to Cart!")),
                  //       );
                  //     },
                  //     child: const Text("Add to Cart", style: TextStyle(color: Colors.white)),
                  //   ),
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A63E),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // 1. Add the product to your repository
                        ProductRepository.addToCart(widget.product);

                        // 2. Show a quick snackbar on the Home Screen so they know it worked
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${widget.product.name} added to cart!",
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color(0xFF00A63E),
                          ),
                        );

                        // 3. Go back to the Home Screen immediately
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
