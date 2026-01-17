import 'package:flutter/material.dart';
import 'package:midterm/database/db_helper.dart';
import 'package:midterm/models/product.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Product> favoriteProducts = []; // To store your data
  bool isLoading = true; // To show a loading spinner

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    setState(() => isLoading = true);
    // Fetch data from local SQLite
    final data = await DbHelper.instance.getFavoriteProducts();

    setState(() {
      favoriteProducts = data;
      isLoading = false;
    });
  }

  void _removeFavorite(int id) async {
    final db = await DbHelper.instance.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);

    // Refresh the list after deleting
    initData();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Removed from favorites")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : favoriteProducts.isEmpty
          ? const Center(child: Text("No favorites added yet!")) // Empty state
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Logic to remove from favorite
                        _removeFavorite(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
