import 'package:midterm/models/product.dart';
import 'package:midterm/models/transaction.dart';
import 'package:midterm/screens/cart_item.dart';

class ProductRepository {
  static List<Product> products = [];

  static List<CartItem> cartItems = [];
  static int totalQty = 0;

  static List<Transaction> allTransactions = [];
  static List<Transaction> recentTransactions = [];


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

  static double getTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item.totalPrice;
    }
    return totalPrice;
  }

  static void increaseQty(int id) {
    final index = cartItems.indexWhere((items) => items.id == id);
    cartItems[index].qty += 1;

    getTotalQty();
  }

  static void decreaseQty(int id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (cartItems[index].qty > 1) {
      cartItems[index].qty -= 1; // Decrease the quantity by 1
    } else {
      cartItems.removeAt(index); // If qty is 1 → remove item completely
    }

    getTotalQty();
  }

  static void clearCart() {
    cartItems.clear();
    totalQty = 0;
  }

  static void removeProductFromCart(int id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    cartItems.removeAt(index);

    getTotalQty();
  }

  static void getTotalQty() {
    totalQty = 0;
    for (var item in cartItems) {
      totalQty += item.qty;
    }
  }

  static void checkout(){
    int trxId = 1;
    if(allTransactions.isNotEmpty){
      trxId = allTransactions.last.id + 1;
    }
    Transaction trx = Transaction(id: trxId, code: 'Trx-$trxId', totalPrice: getTotalPrice(), items: cartItems, orderDate: DateTime.now());
    allTransactions.add(trx);
    clearCart();
    getRecentTransactions();
  }

  static void getRecentTransactions([int limit=5]){
    recentTransactions = allTransactions.reversed.take(limit).toList();
  }



}
