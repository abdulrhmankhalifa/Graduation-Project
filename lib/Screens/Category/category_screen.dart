import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../Styles/colors.dart';
import '../Search_Screen/search_screen.dart';
import 'SubCategory/categoryScreenMinmum.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
      body:
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02,),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Shop By Category',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                 SizedBox(height: screenHeight * 0.02,),
                ///Category

                ///Products
                RefreshIndicator(
                  onRefresh: GetDataCategories,
                  child: GridView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.70,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index] as Map;
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
                                    CategoryScreen1(CategoryIndex: category['id'],),
                                  )
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Image.network(
                                      category['category_image_url'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(category['name'],
                                    style: const TextStyle(
                                      fontSize: 15.0
                                    ),),
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
}
