import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../../Styles/colors.dart';
import '../../Products/Single_Product.dart';
import '../../Search_Screen/search_screen.dart';

class CategoryScreen1 extends StatefulWidget {
  final int CategoryIndex;

  CategoryScreen1({Key? key, required this.CategoryIndex}) : super(key: key);

  @override
  _CategoryScreen1State createState() => _CategoryScreen1State();
}

class _CategoryScreen1State extends State<CategoryScreen1> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  List products = [];
  List categories = [];
  List<bool> isFavoriteList = List.generate(10, (index) => false);


  @override
  void initState() {
    super.initState();
    GetData();
    GetDataCategories();
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

  Future<void> GetDataCategories() async {
    const url =
        'https://graduation-project-nodejs.onrender.com/api/categories/';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['data'] as List;
      setState(() {
        categories = result;
      });
    } else {
      showError('Server responded with status code: ${response.statusCode}');
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
    List filteredProducts = products.where((product) {
      return product['categoryId'] == widget.CategoryIndex;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: defaultColor, // Change your color here
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  const Products(),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
              color: defaultColor,
              size: 25.0,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.01,),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Our Product',
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                       SizedBox(
                        height: screenHeight * 0.01,
                      ),

                      ///Category
                      Container(
                        height: screenHeight * 0.08,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            final category = categories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryScreen1(
                                        CategoryIndex: category['id']),
                                  ),
                                );
                              },
                              child: Container(
                                width: screenWidth * 0.33,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      category['name'],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                       SizedBox(
                        height: screenHeight * 0.01,
                      ),

                      ///Products
                      // Add your product list UI here
                      GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.50,
                          ),
                        itemCount: filteredProducts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context , index) {
                            final product = filteredProducts[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                  context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SingleProductScreen(productIndex: product['id'])
                                    )
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                          onPressed: ()  {
                                            setState(() {
                                              // Toggle the isFavourite boolean value
                                              product['isFavourite'] = !product['isFavourite'];
                                            });

                                            addToFavorites(user!.uid, product['id']);
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
                                        child:
                                        Text('${product['price'].toString()} EGP'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> addToFavorites(String userId, int productId) async {
    final url = Uri.parse('https://graduation-project-nodejs.onrender.com/api/products/toggleFavorite/');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'User-Agent' : 'PostmanRuntime/7.37.3',
        'Accept' : '*/*',
        'Accept-Encoding' : 'gzip, deflate, br',
        'Connection' : 'keep-alive',
        'Authorization' : 'Bearer{{eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7ImVtYWlsIjoibWFzeW0zQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIn0sImlhdCI6MTcxMzg5MTA5MiwiZXhwIjoxNzE0NjY4NjkyfQ.OhFcMk5DCKD5hB7UxV5GESUfx0RdsRf9qtZwa9LWGr8}}'


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
