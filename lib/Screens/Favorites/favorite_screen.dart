import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_project_yarab/Styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../Products/Single_Product.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool isLoading = true;
  List products = [];
  List<bool> isFavoriteList = List.generate(10, (index) => false);
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: defaultColor,
        ),
        backgroundColor: Colors.grey[100],
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: defaultColor,
            fontSize: 25,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ///Products
                      RefreshIndicator(
                        onRefresh: GetData,
                        child: GridView.builder(
                            itemCount: products.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.50,
                            ),
                            itemBuilder: (context, index) {
                              final product = products[index];
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
                                            onPressed: () {
                                              setState(() {
                                                product['isFavourite'] =
                                                    !product['isFavourite'];
                                                addToFavorites(
                                                    user!.uid, product['id']);
                                              });
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
                                        const Spacer(),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(product['name']),
                                        ),
                                        const Spacer(),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                              '${product['price'].toString()} EGP'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  ///Get data
  Future<void> GetData() async {
    final userId = user!.uid;
    final url =
        'https://graduation-project-nodejs.onrender.com/api/products/fav/user/$userId';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      final json = jsonDecode(response.body) as Map;
      final result = json['favoriteProducts'] as List;
      setState(() {
        products = result;
        isLoading = false;
      });
    } else {
      // Handle the case when the server response is not OK
      print(
          'Error fetching data from the server'); // Replace with an appropriate error message
    }
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
      print('Product is not added or removed from favorites successfully');
      throw Exception('Failed to add product to favorites');
    }
  }
}
