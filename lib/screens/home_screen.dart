import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midterm/repositories/product_repository.dart';
import 'package:midterm/screens/history_screen.dart';
import 'package:midterm/screens/new_sale_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard', style: TextStyle(fontSize: 20))),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Total Sale
          buildCard(
            startColor: Color(0xFF00C950),
            endColor: Color(0xFF00A63E),
            label: 'Total Sales (Today)',
            value: '\$0.00',
            icon: Icons.attach_money_sharp,
          ),
          SizedBox(height: 16),
          // Total Order
          buildCard(
            startColor: Color(0xFF2B7FFF),
            endColor: Color(0xFF155DFC),
            label: 'Total Order',
            value: '0',
            icon: Icons.shopping_bag_outlined,
          ),
          SizedBox(height: 16),
          // Top Selling
          buildCard(
            startColor: Color(0xFFF0B100),
            endColor: Color(0xFFD08700),
            label: 'Top-Selling Item',
            value: 'No Sales Yet',
            icon: Icons.show_chart,
            valueFontSize: 24,
          ),
          SizedBox(height: 24),
          // Quick Action
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              border: Border.all(
                width: 0.65,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick Action', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 3 / 2.25,
                  padding: EdgeInsets.zero,
                  children: [
                    // ---------- New Sales Button ----------
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewSaleScreen(),
                          ),
                        );
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF00A63E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'New Sale',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ---------- Add Product Button ----------
                    TextButton(
                      onPressed: null,
                      style: TextButton.styleFrom(
                        // backgroundColor: Color(0xFF00A63E),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.65,
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.cube,
                            color: Colors.black,
                            size: 20,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add Product',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ---------- History Button ----------
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryScreen(),
                          ),
                        );
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFF0B100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history, color: Colors.white, size: 20),
                          SizedBox(height: 8),
                          Text(
                            'History',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ---------- Print Last Button ----------
                    TextButton(
                      onPressed: null,
                      style: TextButton.styleFrom(
                        // backgroundColor: Color(0xFF00A63E),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.65,
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.money_dollar_circle,
                            color: Colors.black,
                            size: 20,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Print Last',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          //  -------------------- Recent Sale ------------------
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              border: Border.all(
                width: 0.65,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Sales', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                ProductRepository.recentTransactions.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'No transactions yet. Start a new sale!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF6A7282),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 300,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          physics: const BouncingScrollPhysics(),
                          // --- Using .map() here ---
                          children: ProductRepository.recentTransactions.map((
                            trx,
                          ) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  16,
                                ), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.blue
                                            .withOpacity(0.1),
                                        child: const Icon(
                                          Icons.receipt_long,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // code
                                          Text(
                                            trx.code,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${trx.orderDate.day}/${trx.orderDate.month}/${trx.orderDate.year}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "\$${trx.totalPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                // --------------------- Recent Sales List End -----------------
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildCard({
    required Color startColor,
    required Color endColor,
    required String label,
    String? value,
    IconData? icon,
    double? valueFontSize,
  }) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(colors: [startColor, endColor]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 16)),
              Icon(icon, color: Colors.white),
            ],
          ),
          SizedBox(height: 40),
          Text(
            value ?? '',
            style: TextStyle(
              fontSize: valueFontSize ?? 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
