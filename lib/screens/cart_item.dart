import 'package:midterm/models/product.dart';

class CartItem {
  final int id;
  final Product product;

  CartItem({required this.id, required this.product});

  int _qty = 0;
  final double _totalPrice = 0;

  set qty(int value) => _qty = value;
  int get qty => _qty;

  double get totalPrice => _qty * product.price;
  set totalPrice(double value) => _totalPrice;
}
