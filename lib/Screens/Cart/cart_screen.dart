import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../Styles/colors.dart';
import '../CheckOut/check_out_screen.dart';
import '../Products/Single_Product.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  List products = [];


  @override
  void initState() {
    super.initState();
    GetData();
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    for (var product in products) {
      totalPrice += double.parse(product['product']['price'].toString());
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: defaultColor, // Change your color here
          ),
          centerTitle: true,
          title: const Text('Cart',
            style: TextStyle(
              color: defaultColor,
            ),
          ),
          actions: [
            IconButton(
              onPressed:deleteCartItem,
              icon: const Icon(
                Icons.delete_outline,
                size: 30.0,
              ),
            ),
          ],
        ),
        body:
        SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [

                RefreshIndicator(
                  onRefresh: GetData,
                  child: GridView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0.5,
                        crossAxisSpacing: 0.5,
                        childAspectRatio: 0.45,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index] as Map;
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SingleProductScreen(
                                            productIndex: product['product']['id'],
                                          )
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                          onPressed: () {
                                            deleteItemFromCart(product['itemId'] , user!.uid);

                                          },
                                          icon: const Icon(
                                              Icons.remove_circle_outline ,
                                            color: defaultColor,
                                          )
                                      ),
                                    ),
                                    AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Image.network(
                                        product['product']['product_image_url'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(product['product']['name']),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Text('${product['product']['price'
                                              ].toString()} l.e'),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(' Total Price :',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: defaultColor,
                        fontWeight: FontWeight.bold,
                      ),),
                      Text(
                        ' ${getTotalPrice().toString()} l.e',
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: defaultColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),

                      ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: products.isNotEmpty ? () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return CheckOutScreen();
                          }));
                        } : null ,

                        child:  const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Check Out',
                              style: TextStyle(color: defaultColor, fontSize: 20.0),
                            ),
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
              ],
            ),
          ),
        ),
    );
  }

  Future<void> GetData() async {
    final userId = user!.uid;
    setState(() {
      isLoading = false;
    });
    final url = 'https://graduation-project-nodejs.onrender.com/api/cart/$userId';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      final json = jsonDecode(response.body) as Map;
      final result = json['cart'] as List;
      setState(() {
        products = result;
      });
    } else {
      // Handle the case when the server response is not OK
      setState(() {
        isLoading = false;
      });
      print('Error fetching data from the server'); // Replace with an appropriate error message
    }
  }

  Future<void> deleteCartItem() async {
    final userId = user!.uid;
    try {
      final response = await http.delete(
        Uri.parse('https://graduation-project-nodejs.onrender.com/api/cart/clear/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Item successfully deleted from the cart
        print('Items deleted from cart.');
      } else {
        // Handle error (e.g., item not found, server error)
        print('Error deleting item from cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> deleteItemFromCart(int itemId, String firebaseId) async {
    final url = 'https://graduation-project-nodejs.onrender.com/api/cart/remove-item/$itemId'; // Replace with your actual API endpoint

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'firebaseId': firebaseId});

    try {
      final response = await http.delete(
          Uri.parse(url),
          headers: headers,
          body: body);
      if (response.statusCode == 200) {
        print('Item deleted successfully');
      } else {
        print('Error deleting item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }






}

