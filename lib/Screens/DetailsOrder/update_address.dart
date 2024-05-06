import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../Styles/colors.dart';

class UpdateAddressScreen extends StatefulWidget {
  const UpdateAddressScreen({super.key});

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  TextEditingController newAddressController = TextEditingController();
  bool isLoading = true;
  List products = [];

  @override
  void initState() {
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    int IndexNum = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: defaultColor,
          size: 25,
        ),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Address',
          style: TextStyle(
            color: defaultColor,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                addNewAddress(newAddressController.text);
                Navigator.pop(context);
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  color: defaultColor,
                ),
              ))
        ],
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
                        childAspectRatio: 5,
                      ),
                      itemBuilder: (context, index) {
                        IndexNum = IndexNum + 1;
                        final product = products[index] as Map;
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              const Spacer(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    const Text(
                                      '  Address No : ',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '$IndexNum',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      const Text(
                                        '  the address: ',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          product['address'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )),
                              const Spacer(),
                            ],
                          ),
                        );
                      }),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: newAddressController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: defaultColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: '  New Address.. City-District-Street-Building',
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> GetData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    setState(() {
      isLoading = false;
    });
    final url =
        'https://graduation-project-nodejs.onrender.com/api/users/$userId';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['user']['addresses'] as List;
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

  Future<void> addNewAddress(String newAddress) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final url = Uri.parse(
        'https://graduation-project-nodejs.onrender.com/api/users/address');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'User-Agent': 'PostmanRuntime/7.37.3',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
      },
      body: jsonEncode(<String, dynamic>{
        'address': newAddress,
        'firebaseId': user!.uid,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('Address Add Successfully');
      print('your id is ${user!.uid}');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Address is not Added Successfully');
      throw Exception('Failed to Add Address');
    }
  }
}
