import 'package:flutter/cupertino.dart';
import 'package:midterm/screens/cart_item.dart';

class Transaction {
  final int id;
  final String code;
  final double totalPrice;
  final List<CartItem> items;
  final DateTime orderDate;

  Transaction({required this.id, required this.code, required this.totalPrice, required this.items, required this.orderDate});
}