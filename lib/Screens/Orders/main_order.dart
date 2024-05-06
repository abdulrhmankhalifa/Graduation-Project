import 'package:flutter/material.dart';

import '../../Styles/colors.dart';
import 'current_order.dart';
import 'orders.dart';


class mainOrder extends StatefulWidget {
  const mainOrder({super.key});

  @override
  State<mainOrder> createState() => _mainOrderState();
}

class _mainOrderState extends State<mainOrder> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: defaultColor, // Change your color here
        ),
        title: const Center(
          child: Text(
            'Orders',
            style: TextStyle(
              fontSize: 21.0,
              color: defaultColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.2,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const CurrentOrderScreen();
                }));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Current Order',
                    style: TextStyle(color: defaultColor, fontSize: 15.0),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    color: defaultColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const OrdersScreen();
                }));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Orders History',
                    style: TextStyle(color: defaultColor, fontSize: 15.0),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    color: defaultColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
