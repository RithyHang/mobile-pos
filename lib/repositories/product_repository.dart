import 'package:midterm/models/product.dart';
import 'package:midterm/screens/cart_item.dart';

class ProductRepository {
  static List<Product> products = [
    Product(
      id: 1,
      name: 'Premium Coffee Beans',
      category: 'Beverages',
      price: 12.99,
      stock: 50,
      image:
          'https://images.unsplash.com/photo-1675306408031-a9aad9f23308?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y29mZmVlJTIwYmVhbnN8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=500',
    ),
    Product(
      id: 2,
      name: 'Fresh Sourdough Bread',
      category: 'Bakery',
      price: 4.99,
      stock: 30,
      image:
          'https://images.unsplash.com/photo-1517141544637-42b300cb4ee9?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c291cmRvdWdoJTIwYnJlYWR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=500',
    ),
    Product(
      id: 3,
      name: 'Artisan Chocolate Bar',
      category: 'Snacks',
      price: 5.99,
      stock: 75,
      image:
          'https://images.unsplash.com/photo-1638194645412-1d0b4c53ffed?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y2hvY29sYXRlJTIwYmFyfGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
    ),
    Product(
      id: 4,
      name: 'Organic Green Tea',
      category: 'Berverages',
      price: 8.99,
      stock: 40,
      image:
          'https://plus.unsplash.com/premium_photo-1694540110881-84add98c0a75?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Z3JlZW4lMjB0ZWF8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=500',
    ),
    Product(
      id: 5,
      name: 'Croissant',
      category: 'Bakery',
      price: 3.49,
      stock: 25,
      image:
          'https://plus.unsplash.com/premium_photo-1661743823829-326b78143b30?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y3JvaXNzYW50fGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
    ),
    Product(
      id: 6,
      name: 'Mixed Nuts',
      category: 'Snacks',
      price: 6.99,
      stock: 60,
      image:
          'https://images.unsplash.com/photo-1543158181-1274e5362710?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWl4ZWQlMjBudXRzfGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
    ),
  ];

  static List<CartItem> cartItems = [];
  static int totalQty = 0;

  static void addToCart(Product product) {
    if (cartItems.isEmpty) {
      final CartItem item = CartItem(id: 1, product: product);
      item.qty = 1;
      cartItems.add(item);
      print(cartItems);
    } else {
      int existingItemIndex = cartItems.indexWhere(
        (element) => element.product.id == product.id,
      );
      if (existingItemIndex != -1) {
        CartItem item = cartItems[existingItemIndex]; // get item in cart
        item.qty += 1; // increase qty
        cartItems[existingItemIndex] = item; // assign new qty to cart
      } else {
        int id = 1;
        if (cartItems.isNotEmpty) {
          id = cartItems.last.id + 1;
        }
        CartItem item = CartItem(id: id, product: product);
        item.qty = 1;
        cartItems.add(item);
      }
    }
    getTotalQty();
  }

  static void increaseQty() {}

  static void decreaseQty() {}

  static void clearCart() {
    cartItems.clear();
    totalQty = 0;
  }

  static void removeProductFromCart(int id) {
    totalQty = 0;
    final index = cartItems.indexWhere((item) => item.id == id);
    cartItems.removeAt(index);
    for (var item in cartItems) {
      totalQty += item.qty;
      // print('${item.qty} : ${item.product.name}');
    }
    // print('----------- end ------------');
  }

  static void getTotalQty() {
    totalQty = 0;
    for (var item in cartItems) {
      totalQty += item.qty;
      // print('${item.qty} : ${item.product.name}');
    }
    // print('----------- end ------------');
  }
}
