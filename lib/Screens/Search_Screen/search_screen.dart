import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../Styles/colors.dart';
import '../Products/Single_Product.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final _searchController = TextEditingController(); // Create a TextEditingController
  final User? user = FirebaseAuth.instance.currentUser;

  List products = [];
  // Declare and initialize searchTerm
  String searchTerm = '';

  // Replace with your actual API endpoint URL
  final String baseUrl = 'https://graduation-project-nodejs.onrender.com/api/products/search/';

  Future<void> searchProducts(String term) async {
    final url = Uri.parse('$baseUrl$term');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // Assuming 'data' is a nested object and the list is under a key called 'items'
      if (json['data'] is Map && json['data']['products'] is List) {
        setState(() {
          // Extract the list from the nested object
          products = json['data']['products'];
        });
      } else {
        print('The "data" key is not a nested object with a list');
        setState(() {
          products = []; // Set products to an empty list if the structure is not as expected
        });
      }
    } else {
      print('Error fetching products: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        iconTheme: const IconThemeData(
          color: defaultColor,
        ),
        title: const Text(
          'Search For Product',
          style: TextStyle(
            color: defaultColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController, // Use the TextEditingController
                  decoration: const InputDecoration(
                    hintText: 'Search Products...',
                  ),
                  onChanged: (text) {
                    setState(() {
                      searchTerm = text;
                      if (searchTerm.isNotEmpty) {
                        searchProducts(searchTerm);
                      } else {
                        products = ' ' as List; // Clear product on empty search
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GridView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.45,
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
                                    builder: (context) =>
                                        SingleProductScreen(
                                            productIndex: product['id']),
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          product['isFavourite'] =
                                          !product['isFavourite'];
                                        });
                                        addToFavorites(
                                            user!.uid, product['id']);
                                      },
                                      icon: product['isFavourite']
                                          ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 20,
                                      )
                                          : const Icon(
                                          Icons.favorite_border,
                                          size: 20),
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Image.network(
                                      product['product_image_url'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(product['name']),
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child:
                                    Text(product['price'].toString()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                  // Column(
                  //   children: [
                  //     Text('ID: ${product!.id}'),
                  //     Text('Name: ${product!.name}'),
                  //     Text('Price: \$ ${product!.price.toStringAsFixed(2)}'),
                  //     // Format price
                  //     Image.network(product!.productImageUrl),
                  //     // Display image
                  //   ],
                  // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addToFavorites(String userId, int productId) async {
    final url = Uri.parse(
        'https://graduation-project-nodejs.onrender.com/api/products/toggleFavorite/');
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

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('Product added or removed from favorites successfully');
      print('your id is $userId');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Product is not added or removed from  favorites successfully');
      throw Exception('Failed to add product to favorites');
    }
  }

}