import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:midterm/models/product.dart';
import 'package:midterm/screens/product_dtail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/domain/domain.dart';
import '../api/end_point/api_end_point.dart';
import '../database/db_helper.dart';
import '../repositories/product_repository.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  // ========== list variables ==========
  int _selectedIndex = 0; // <-- Track active icon in footer
  bool isFavorite = false;
  bool isCartEmpty = false;
  final TextEditingController _searchController = TextEditingController();
  int qty = 0;
  List<Product> products = [];
  String? username;
  List<String> categories = ['All']; // Default list
  String selectedCategory = 'All'; // Currently selected
  String searchQuery = "";

  Future<void> _fetchCategories() async {
    final response = await http.get(
      Uri.parse("https://fakestoreapi.com/products/categories"),
    );
    if (response.statusCode == 200) {
      setState(() {
        // Combines 'All' with the dynamic list from API
        categories = ['All', ...json.decode(response.body)];
      });
    }
  }

  Future<void> initData() async {
    final response = await http.get(
      Uri.parse(ApiDomain.domain + ApiEndPoint.products),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body) as List;
      for (var item in data) {
        products.add(Product.fromJson(item));
      }
      ProductRepository.products = products;
      setState(() {});
    }
    await applyFavoritesToProducts();
    await _getUsername();
    await _fetchCategories();
  }

  Future<void> _handleRefresh() async {
    // Clear lists so you don't just append duplicates
    products.clear();

    // Re-run existing data fetching logic
    await initData();
    selectedCategory = "All";
  }

  Future<void> applyFavoritesToProducts() async {
    final favoriteProducts = await DbHelper.instance.getFavoriteProducts();

    final favoriteIds = favoriteProducts.map((p) => p.id).toSet();

    for (final product in ProductRepository.products) {
      product.isFavorite = favoriteIds.contains(product.id);
    }
  }

  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch the string and provide a fallback if it's null
    final savedName = prefs.getString('pos.username');

    setState(() {
      username = savedName ?? "Guest";
    });
  }

  // ------ Add to Cart --------
  void addToCart(product) {
    // your cart logic here
  }

  void _onFooterItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to pages based on index
    switch (index) {
      case 0:
        // Already on HomeScreen, no need to navigate
        break;
      case 1:
        // Navigate to CartScreen
        // Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen()));
        break;
      case 2:
        // Navigate to ProfileScreen
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ================== APP BAR ==================
      appBar: AppBar(
        backgroundColor: const Color(0xFFDE302F),
        elevation: 0,

        // ---------- TOP BAR ----------
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ===== USER =====
            Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  username == null ? "Loading..." : "$username",
                  style: GoogleFonts.jaro(fontSize: 24, color: Colors.white),
                ),
              ],
            ),

            // ===== FAVORITE =====
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FavoriteScreen()),
                );
                await applyFavoritesToProducts();
                setState(() {});
              },
              icon: const Icon(Icons.favorite_outline, color: Colors.white),
            ),
          ],
        ),

        // ---------- SEARCH BAR ----------
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: CupertinoSearchTextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(30),
              placeholder: 'Search products or scan barcode',
            ),
          ),
        ),
      ),

      // ================== APP BAR END ==================
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // The function to run
        color: const Color(0xFFDE302F),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================== CATEGORY FILTER ==================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<String>(
                    initialValue: selectedCategory,
                    // 1. When a user picks a category:
                    onSelected: (String value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    // 2. This builds the list of options dynamically:
                    itemBuilder: (context) => categories
                        .map(
                          (cat) => PopupMenuItem(
                            value: cat,
                            child: Text(cat.toUpperCase()),
                          ),
                        )
                        .toList(),

                    // 3. This is existing UI acting as the "Trigger"
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedCategory, // Displays the selected one
                          style: GoogleFonts.jaro(
                            fontSize: 16,
                            color: const Color(0xFFDE302F),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFFDE302F),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ================== CATEGORY FILTER END ==================

              // ------ Products List Start --------
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                padding: EdgeInsets.all(16),
                childAspectRatio: 0.85,

                children: ProductRepository.products
                    .where((product) {
                      // 1. Check Category
                      bool matchesCategory =
                          (selectedCategory == 'All' ||
                          product.category == selectedCategory);

                      // 2. Check Search Text
                      bool matchesSearch = product.name.toLowerCase().contains(
                        searchQuery,
                      );

                      return matchesCategory && matchesSearch;
                    })
                    .map(
                      // ---------- make product a clickable button --------
                      (product) => TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(14),
                            side: BorderSide(
                              width: 0.65,
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                          ),
                        ),

                        // ------------- product image ----------
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minWidth: double.infinity,
                                      minHeight: 120,
                                      maxHeight: 160,
                                    ),
                                    child: Image.network(
                                      product.image,
                                      height: 16,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            CupertinoIcons.cube,
                                            size: 48,
                                            color: Color(0xFF99A1AF),
                                          ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 8),

                                // ------------- product detail --------------
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),

                                // ------------- product price and stock --------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF00A63E),
                                      ),
                                    ),
                                    Text(
                                      'Stock: ${product.stock}',
                                      style: TextStyle(
                                        color: Color(0xFF6A7282),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Favorite Button
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () async {
                                  // await DbHelper.instance.saveProductToFavorite(product);
                                  if (product.isFavorite) {
                                    await DbHelper.instance.removeFavorite(
                                      product.id,
                                    );
                                  } else {
                                    await DbHelper.instance
                                        .saveProductToFavorite(product);
                                  }

                                  setState(() {
                                    // Change ONLY this specific product's status
                                    product.isFavorite = !product.isFavorite;
                                  });
                                },
                                icon: Icon(
                                  product.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: product.isFavorite
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),

              // ------ Products List End --------
            ],
          ),
        ),
      ),

      // ================== FOOTER ==================
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFDE302F),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: _selectedIndex,
        onTap: _onFooterItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
