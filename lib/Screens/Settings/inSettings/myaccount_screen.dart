

import 'package:flutter/material.dart';

import '../../../Styles/colors.dart';
import '../../Cart/cart_screen.dart';
import '../../DetailsOrder/update_address.dart';
import '../../DetailsOrder/update_phone_number.dart';
import '../../Firebase_Screens/chat_screen.dart';
import '../../Orders/main_order.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: defaultColor, // Change your color here
        ),
        title: const Center(
          child: Text(
            'Account',
            style: TextStyle(
              fontSize: 25.0,
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
                  return CartScreen();
                }));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'My Cart',
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
            SizedBox(height: screenHeight * 0.01,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UpdatePhoneNumberScreen();
                }));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Update Phone Number',
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
            SizedBox(height: screenHeight * 0.01,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UpdateAddressScreen();
                }));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Update Address',
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
            SizedBox(height: screenHeight * 0.01,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return mainOrder();
                }));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Orders',
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
            SizedBox(height: screenHeight * 0.01,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HomeChatScreen();
                }));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Have a Questions ?',
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
