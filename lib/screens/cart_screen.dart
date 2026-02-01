import 'package:flutter/material.dart';
import 'package:http/http.dart' as CupertinoIcons;
import 'package:lottie/lottie.dart';
import 'package:midterm/database/db_helper.dart';
import 'package:midterm/repositories/product_repository.dart';
import 'package:midterm/screens/page_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Sale'), centerTitle: false),
      body: ListView(
        children: [
          SizedBox(height: 16),

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
                Icon(Icons.shopping_cart, color: Color(0xFF4A5565)),
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
                          (item) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                item.product.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // 1. Wrap the Text in Expanded to force it to take only available space
                                  Expanded(
                                    child: Text(
                                      item.product.name,
                                      maxLines: 1, // Keeps it on one line
                                      overflow: TextOverflow
                                          .ellipsis, // Adds "..." at the end if too long
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // 2. Add some spacing so the text doesn't touch the delete icon
                                  SizedBox(width: 10),
                                  IconButton(
                                    onPressed: () {
                                      ProductRepository.removeProductFromCart(
                                        item.id,
                                      );
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
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
                                  _showLoadings(); // Show your existing loading dialog

                                  // 1. Fake API Delay (Requirement 3.5)
                                  await Future.delayed(
                                    const Duration(seconds: 2),
                                  );

                                  // 2. Clear the cart logic
                                  ProductRepository.clearCart();

                                  if (mounted) {
                                    // 3. Close the loading dialog
                                    Navigator.pop(context);

                                    // 4. Show the Success Message (Requirement 3.5)
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Success!"),
                                        content: const Text(
                                          "Your order has been placed successfully.",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // 1. Close the dialog
                                              Navigator.pop(context);

                                              // 2. Instead of popping the screen, jump to the first tab (Home)
                                              // This prevents the black screen
                                              Navigator.of(
                                                context,
                                              ).pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const MyHome(),
                                                ),
                                                (route) => false,
                                              );
                                            },
                                            child: const Text("Back to Home"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            backgroundColor: const Color(0xFF00A63E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
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
