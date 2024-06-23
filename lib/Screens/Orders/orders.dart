import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../Styles/colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isLoading = true;
  List products = [];

  @override
  void initState() {
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: defaultColor,
        ),
        centerTitle: true,
        title: const Text(
          'Orders History',
          style: TextStyle(
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
                        crossAxisCount: 1,
                        mainAxisSpacing: 0.5,
                        crossAxisSpacing: 0.5,
                        childAspectRatio: 2.5,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index] as Map;
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Price :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                        Text(
                                          product['totalAmount'].toString(),
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Address :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            product['address']['address'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Phone Number :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                        Text(
                                          product['phoneNumber'],
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Text(
                                      'Status Of Order : ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      product['status'],
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    const Text(' '),
                                    Icon(
                                      product['status'] == 'Pending'
                                          ? Icons.delivery_dining
                                          : Icons.done,
                                      color: product['status'] == 'Pending'
                                          ? Colors.red
                                          : Colors.green,
                                      size: 20,
                                    ),
                                  ],
                                )
                              ],
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
            content: Text('You have not placed any order'),
          ),
        );
        print('${response.body}');
        throw Exception('Failed to make a new order');
      }
    }
  }
}
