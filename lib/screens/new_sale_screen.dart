import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:midterm/api/domain/domain.dart';
import 'package:midterm/api/end_point/api_end_point.dart';
import 'package:midterm/database/db_helper.dart';
import 'package:midterm/models/product.dart';
import 'package:midterm/repositories/product_repository.dart';
import 'package:http/http.dart' as http;

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  // list variables
  bool isCartEmpty = false;
  final TextEditingController _searchController = TextEditingController();
  int qty = 0;
  List<Product> products = [];

  void addToCart(Product product) {
    ProductRepository.addToCart(product);
    setState(() {});
  }

  _showLoadings() {
    showDialog(
      context: context,
      builder: (context) => SizedBox(
        width: 120,
        height: 120,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          constraints: BoxConstraints(maxHeight: 120, maxWidth: 120),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // CircularProgressIndicator(),
                // CupertinoActivityIndicator(),
                CircularProgressIndicator.adaptive(),
                SizedBox(height: 8),
                Text(
                  'please wait',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initData() async {
    final response = await http.get(
      Uri.parse(ApiDomain.domain + ApiEndPoint.products),
      // headers: {
      //   "Authorization": "Bearer ${AuthRepository.token}",
      //   "ngrok-skip-browser-warning": "true",
      // },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body) as List;
      for (var item in data) {
        products.add(Product.fromJson(item));
      }
      ProductRepository.products = products;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Sale'), centerTitle: false),
      body: ListView(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CupertinoSearchTextField(
              placeholder: 'Search products or scan barcode',
              padding: EdgeInsets.all(12),
              prefixInsets: EdgeInsets.only(left: 16),
              suffixIcon: Icon(Icons.center_focus_strong_outlined),
              suffixMode: OverlayVisibilityMode.always,
              controller: _searchController,
              placeholderStyle: TextStyle(
                fontSize: 16,
                color: Color(0xFF717182),
              ),
            ),
          ),

          SizedBox(height: 16),

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
                .map(
                  // ---------- make product a clickable button --------
                  (product) => TextButton(
                    onPressed: () => addToCart(product),
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
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
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
                            Text(
                              product.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6A7282),
                              ),
                            ),
                            SizedBox(height: 4),

                            // ------------- product price and stock --------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            onPressed: () async{
                              await DbHelper.instance.saveProductToFavorite(product);
                            },
                            icon: Icon(Icons.favorite_outline),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          // ------ Products List End --------

          // ------ Top Cart Row Start --------
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withValues(alpha: 0.1),
                  width: 0.65,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.shopping_cart, color: Color(0xFF4A5565)),
                SizedBox(width: 8),
                Text(
                  'Cart (${ProductRepository.totalQty})',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // ------ Top Cart Row END --------

          // ------ Middle Cart Row Start --------
          Container(
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ProductRepository.cartItems.isEmpty
                ? Column(
                    children: [
                      Lottie.asset('assets/lotties/empty_box.json'),
                      SizedBox(height: 8),
                      Text(
                        'Cart is empty',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6A7282),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: ProductRepository.cartItems
                        .map(
                          // ------------ Cart Product -------------
                          (item) => Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // === Name & Delete
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ProductRepository.removeProductFromCart(
                                          item.id,
                                        );
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),

                                // === Price
                                Text(
                                  '\$ ${item.product.price.toStringAsFixed(2)} each',
                                ),

                                // === QTY and Subtotal
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        ProductRepository.decreaseQty(item.id);
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.remove),
                                    ),
                                    Text(item.qty.toString()),
                                    IconButton(
                                      onPressed: () {
                                        ProductRepository.increaseQty(item.id);
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    Spacer(),
                                    Text(
                                      '\$ ${item.totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          // ------ Middle Cart Row END --------

          // ------ Total Start --------
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: TextStyle(fontSize: 18)),
                    Text(
                      //Price TOTAL
                      '\$ ${ProductRepository.getTotalPrice().toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, color: Color(0xFF00A63E)),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                Row(
                  children: [
                    //------------- Clear Button ---------------
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          ProductRepository.clearCart();
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            side: BorderSide(
                              width: 0.65,
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    //------------- Clear Button END ---------------
                    SizedBox(width: 8),

                    //------------- Checkout Button ---------------
                    Expanded(
                      child: Opacity(
                        opacity: ProductRepository.cartItems.isEmpty ? 0.5 : 1,
                        child: TextButton(
                          onPressed: ProductRepository.cartItems.isEmpty
                              ? null
                              : () async {
                                  ProductRepository.checkout();
                                  _showLoadings();
                                  await Future.delayed(
                                    Duration(seconds: 2),
                                    () {
                                      Navigator.pop(context);
                                    },
                                  );
                                  Navigator.pop(context);
                                },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            backgroundColor: Color(0xFF00A63E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                          ),
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //------------- Checkout Button END ---------------
                  ],
                ),
              ],
            ),
          ),
          // ------ Total END --------
        ],
      ),
    );
  }
}
