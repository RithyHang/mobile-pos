import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midterm/screens/new_sale_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewSaleScreen(),
                          ),
                        );
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
                          Icon(Icons.history, color: Colors.black, size: 20),
                          SizedBox(height: 8),
                          Text(
                            'History',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
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
          // Recent Sale
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
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No transactions yet. Start a new sale!',
                    style: TextStyle(fontSize: 18, color: Color(0xFF6A7282)),
                  ),
                ),
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
