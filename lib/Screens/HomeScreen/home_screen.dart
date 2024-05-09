import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_yarab/Screens/Favorites/favorite_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Styles/colors.dart';
import '../Category/SubCategory/categoryScreenMinmum.dart';
import '../Category/category_screen.dart';
import '../HomePage/home_page.dart';
import '../Products/Single_Product.dart';
import '../Products/product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
// final FirebaseAuth auth = FirebaseAuth.instance;
// final User? user = auth.currentUser;

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  List products = [];
  List categories = [];
  List<bool> isFavoriteList = List.generate(110, (index) => false);
  bool isFavorite = false;
  List<Map> favorites = [];
  List<Map> productsMap = [];
  List<String> favoriteDataList = [];

  final List<String> imgList = [
    'https://i.pinimg.com/564x/a6/42/08/a64208fddc05072cd08c78bca5cc0077.jpg',
    'https://i.pinimg.com/564x/18/d6/79/18d67976552f18d6c02d805c27632665.jpg',
    'https://i.pinimg.com/564x/a3/6a/1c/a36a1cf6447d0a2ffe508e211c7fbf70.jpg',
    // Add more asset paths here
  ];

  // void addToFavorites(Map productsMap) {
  //   // Check if the product is not already in the favorites list
  //   if (!favorites.any((item) => item['id'] == productsMap['id'])) {
  //     // Add the product to the favorites list
  //     favorites.add(productsMap);
  //     // Optionally, save the favorites list to local storage or a database
  //   }
  // }

  @override
  void initState() {
    super.initState();
    GetData();
    GetDataCategories();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    ///banners
                    CarouselSlider(
                      items: imgList.map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(item, fit: BoxFit.cover),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: screenHeight * 0.20,
                        initialPage: 0,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),

                    ///text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CategoryScreen()),
                              );
                            },
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: defaultColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///categories
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 7.0),
                      height: screenHeight * 0.13,
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
                                    CategoryIndex: category['id'],
                                  ),
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
                                child: Image.network(
                                  category['category_image_url'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    ///text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Products',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: defaultColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),

                    ///Products
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
                            childAspectRatio: 0.50,
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
                                      Spacer(),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(product['name']),
                                      ),
                                      Spacer(),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child:
                                            Text('${product['price'].toString()} l.e'),
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

  /// Get Data
  Future<void> GetData() async {
    setState(() {
      isLoading = false;
    });
    const url = 'https://graduation-project-nodejs.onrender.com/api/products/';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['data'] as List;
      setState(() {
        products = result;
      });
    } else {
      // Handle the case when the server response is not OK
      setState(() {
        isLoading = false;
      });
      const Text('we have some error');
    }
  }

  ///GetDataCategories
  Future<void> GetDataCategories() async {
    setState(() {
      isLoading = false;
    });
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
      // Handle the case when the server response is not OK
      setState(() {
        isLoading = false;
      });
      const Text('we have some error');
    }
  }

  ///POST Data
  // Future<void> PostData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   const url = 'https://graduation-project-nodejs.onrender.com/api/products/fav';
  //   final uri = Uri.parse(url);
  //
  //   final response = await http.post(uri);
  //   if (response.statusCode == 200) {
  //     final json = jsonEncode(response.body) as Map;
  //     final result = json['data'] as List;
  //     setState(() {
  //       products = result;
  //     });
  //   } else {
  //     // Handle the case when the server response is not OK
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

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

  ///PUT

  ///message for success
  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///message for Error
  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///Remove from favorites screen

// Future<void> _removeFromFavorites(String item) async {
//   final response = await http.delete('https://graduation-project-nodejs.onrender.com/api/products/fav/$item');
//   if (response.statusCode == 200) {
//     setState(() {
//       favorites.remove(item);
//     });
//   } else {
//     throw Exception('Failed to remove from favorites');
//   }
// }
}
