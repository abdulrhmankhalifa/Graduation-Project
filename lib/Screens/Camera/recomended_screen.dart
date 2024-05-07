import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:graduation_project_yarab/Styles/colors.dart';

import '../Products/Single_Product.dart';

class RecomendedProductsScreen extends StatefulWidget {
  const RecomendedProductsScreen({super.key});

  @override
  State<RecomendedProductsScreen> createState() => _RecomendedProductsScreenState();
}

class _RecomendedProductsScreenState extends State<RecomendedProductsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;
  List products = [];
  String skinType = " ";
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
        iconTheme: const IconThemeData(
          color: defaultColor,
        ),
        centerTitle: true,
        title: const Text(
          'Recommendation List',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: defaultColor,
          ),
        ),

      ),
      body:
      isLoading
          ? const Center(child: CircularProgressIndicator())
      :
      SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.01,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Text(
                      'Your Skin Type : ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                        color: defaultColor,
                      ),
                    ),
                    Text(
                    skinType,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                      color: defaultColor,
                    ),

                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02,),
              RefreshIndicator(
                onRefresh: GetData,
                child: GridView.builder(
                    itemCount: products.length > 10 ? products.length = 10 : products.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.55,
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> GetData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId  = user!.uid;
    final url = 'https://graduation-project-nodejs.onrender.com/api/products/recommended/$userId';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['data']['products'] as List;
      final resultSkin = json['skinType'];
      setState(() {
        products = result;
        skinType = resultSkin;
        isLoading = false;

      });
    } else {
      // Handle the case when the server response is not OK
      setState(() {
        isLoading = false;
      });
      const Text('we have some error');
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
      print('Product is not added or removed from  favorites successfully');
      throw Exception('Failed to add product to favorites');
    }
  }
}
