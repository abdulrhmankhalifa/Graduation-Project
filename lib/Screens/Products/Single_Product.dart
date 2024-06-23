// ignore: file_names
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Styles/colors.dart';

class SingleProductScreen extends StatefulWidget {
  final int productIndex;

  const SingleProductScreen({Key? key, required this.productIndex})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SingleProductScreenState createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  bool isLoading = true;
  List products = [];
  bool isFavorite = false;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context) {
    // Corrected the comparison to check against a property of the product.
    final product = products.firstWhere(
      (product) => product['id'] == widget.productIndex,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: defaultColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: defaultColor, // Change your color here
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : product != null
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () async {
                                addToFavorites(user!.uid, product['id']);
                              },
                              icon: product['isFavourite']
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 20,
                                    )
                                  : const Icon(Icons.favorite_border, size: 20),
                            ),
                          ),
                          Image.network(product['product_image_url']),
                          const Spacer(),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                product['name'],
                                style: const TextStyle(
                                  fontSize: 15.0,
                                ),
                              )),
                          const Spacer(),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${product['price'].toString()} EGP',
                                style: const TextStyle(
                                  fontSize: 15.0,
                                ),
                              )),
                          const Spacer(),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'DESCRIPTION',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                product['description'],
                                style: const TextStyle(
                                  fontSize: 11.0,
                                ),
                              )),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    backgroundColor: defaultColor,
                                  ),
                                  onPressed: () {
                                    addToCart(user!.uid, product['id']);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Add To Cart',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(child: Text('Product not found')),
    );
  }

  Future<void> GetData() async {
    const url = 'https://graduation-project-nodejs.onrender.com/api/products/';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final result = json['data'] as List<dynamic>;
        setState(() {
          products = result;
          isLoading = false;
        });
      } else {
        showError('Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      showError('An error occurred: $e');
    }
  }

  Future<void> addToCart(String userId, int productId) async {
    final url = Uri.parse(
        'https://graduation-project-nodejs.onrender.com/api/cart/add-item');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'User-Agent': 'PostmanRuntime/7.37.3',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Authorization':
            'Bearer{{eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7ImVtYWlsIjoibWFzeW0zQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIn0sImlhdCI6MTcxMzg5MTA5MiwiZXhwIjoxNzE0NjY4NjkyfQ.OhFcMk5DCKD5hB7UxV5GESUfx0RdsRf9qtZwa9LWGr8}}'
      },
      body: jsonEncode(<String, dynamic>{
        'firebaseId': userId,
        'productId': productId,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('Product added to Cart successfully');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Product is not added to Cart successfully');
      throw Exception('Failed to add product to Cart');
    }
  }

  Future<void> addToFavorites(String userId, int productId) async {
    final url = Uri.parse(
        'https://graduation-project-nodejs.onrender.com/api/products/fav/add');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'User-Agent': 'PostmanRuntime/7.37.3',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Authorization':
            'Bearer{{eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7ImVtYWlsIjoibWFzeW0zQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIn0sImlhdCI6MTcxMzg5MTA5MiwiZXhwIjoxNzE0NjY4NjkyfQ.OhFcMk5DCKD5hB7UxV5GESUfx0RdsRf9qtZwa9LWGr8}}'
      },
      body: jsonEncode(<String, dynamic>{
        'firebaseId': userId,
        'productId': productId,
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('Product added to favorites successfully');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Product is not added to favorites successfully');
      throw Exception('Failed to add product to favorites');
    }
  }

  Future<void> removeFromFavorites(String userId, int productId) async {
    final url = Uri.parse(
        'https://graduation-project-nodejs.onrender.com/api/products/fav/remove');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'User-Agent': 'PostmanRuntime/7.37.3',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
      },
      body: jsonEncode(<String, dynamic>{
        'firebaseId': userId,
        'productId': productId,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('Product removed from favorites successfully');
    } else {
      // If the server did not return a 200 OK response,
      // then print the error message.
      print('Failed to remove product from favorites: ${response.body}');
    }
  }

  void showError(String message) {
    // Using a snackbar to show errors.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
