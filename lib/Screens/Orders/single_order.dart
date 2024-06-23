import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../Styles/colors.dart';
import '../Products/Single_Product.dart';

class SingleOrderScreen extends StatefulWidget {
  final int orderIndex;

  SingleOrderScreen({Key? key, required this.orderIndex}) : super(key: key);

  @override
  State<SingleOrderScreen> createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen> {
  bool isLoading = true;
  List products = [];

  @override
  void initState() {
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context) {
    final product = products.firstWhere(
      (product) => product['orderId'] == widget.orderIndex,
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: defaultColor,
        ),
        centerTitle: true,
        title: Text(
          product['orderId'].toString(),
          style: const TextStyle(
            color: defaultColor,
            fontWeight: FontWeight.w400,
            fontSize: 21.0,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              RefreshIndicator(
                onRefresh: GetData,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0.5,
                        crossAxisSpacing: 0.5,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index] as Map;
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleProductScreen(
                                    productIndex: product['id'],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Image.network(
                                        product['product_image_url'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(product['name']),
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(product['price'].toString()),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> GetData() async {
    setState(() {
      isLoading = true;
    });

    // Retrieve the current user's ID from FirebaseAuth
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // Define the API endpoint with query parameters
      final url =
          'https://graduation-project-nodejs.onrender.com/api/order/users/${firebaseUser.uid}';
      final uri = Uri.parse(url);

      // Send a GET request
      final response = await http.get(uri);

      // Process the response
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        final result = json['orders'] as List;
        setState(() {
          products = result;
          isLoading = false;
        });
        print('Orders');
        print('Your ID is ${firebaseUser.uid}');
      } else {
        // Handle the case when the server response is not OK
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.body}'),
          ),
        );
        print('${response.body}');
        throw Exception('Failed to make a new order');
      }
    }
  }
}
