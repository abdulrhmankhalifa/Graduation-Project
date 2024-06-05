import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../Styles/colors.dart';
import '../Category/SubCategory/categoryScreenMinmum.dart';
import '../Search_Screen/search_screen.dart';
import 'Single_Product.dart';


class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  List products = [];
  List categories = [];
  List<bool> isFavoriteList = List.generate(50, (index) => false);

  @override
  void initState() {
    super.initState();
    GetData();
    GetDataCategories();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
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
                  builder: (context) => Products(),
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
      body:
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            'Our Products',
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                       SizedBox(height: screenHeight * 0.01,),
                      ///Category
                      Container(
                        height: screenHeight * 0.07,
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
                                    builder: (context) => CategoryScreen1(CategoryIndex: category['id'],),
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
                       SizedBox(height: screenHeight * 0.01,),
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
                                               SingleProductScreen(productIndex: product['id']),
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
                                            onPressed: () async  {
                                              setState(() {
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
                                        Spacer(),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(product['name']),
                                        ),
                                        Spacer(),
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
        isFavoriteList = List.generate(products.length, (index) => false);
      });
    } else {
      // Handle the case when the server response is not OK
      setState(() {
        isLoading = false;
      });
      const Text('we have some error');
    }
  }

///Get data from category
  Future<void> GetDataCategories() async {
    setState(() {
      isLoading = false;
    });
    const url = 'https://graduation-project-nodejs.onrender.com/api/categories/';
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
      print('Product is not added or removed from favorites successfully');
      throw Exception('Failed to add product to favorites');
    }
  }

}
