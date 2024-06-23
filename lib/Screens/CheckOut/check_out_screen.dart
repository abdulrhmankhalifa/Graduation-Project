import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Styles/colors.dart';
import '../HomePage/home_page.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  List<String> addresses = [];
  String selectedAddress = '';
  bool isLoading = true;
  List products = [];

  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    GetDataAddress();
    GetDataPhoneNumber();
    addressController = TextEditingController(
        text: selectedAddress.replaceAll('{', '').replaceAll('}', ''));
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectedAddress =
        addresses.isNotEmpty ? addresses.first : 'Default Address';
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: defaultColor,
      appBar: AppBar(
        backgroundColor: defaultColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Check Out',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 22,
                          color: defaultColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    FittedBox(
                      child: SizedBox(
                        height: screenHeight * 0.08,
                        child: DropdownButton<String>(
                          style: const TextStyle(
                            color: defaultColor,
                            fontSize: 18,
                          ),
                          value: selectedAddress,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedAddress = newValue!;
                              addressController.text = newValue;
                            });
                          },
                          items: addresses
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value
                                  .replaceAll('{', '')
                                  .replaceAll('}', '')),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'City-District-Street-Building...'),
                      style: const TextStyle(
                        color: defaultColor,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedAddress = newValue
                                .replaceAll('{', '')
                                .replaceAll('}',
                                    ''); // Remove braces from the selected value
                            addressController.text = newValue
                                .replaceAll('{', '')
                                .replaceAll('}',
                                    ''); // Remove braces from the addressController text
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.065,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mobile Number',
                        style: TextStyle(
                          fontSize: 22,
                          color: defaultColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    TextField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Your Number... '),
                      style: const TextStyle(
                        color: defaultColor,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.065,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 22,
                          color: defaultColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Cash On Delivery',
                              style: TextStyle(
                                  color: defaultColor, fontSize: 20.0),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: defaultColor,
                      ),
                      onPressed: () {
                        createNewOrder(
                            addressController.text, phoneNumberController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeDesign()),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Payment',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 24.0),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Post data to create order
  Future<void> createNewOrder(String address, String phoneNumber) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final url = Uri.parse(
        'https://graduation-project-nodejs.onrender.com/api/order/create');

    // Print the address to verify its value
    print('Address to be sent: $address');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "firebaseId": user!.uid,
        "address": address, // Ensure address is a string (or modify as needed)
        "phoneNumber": phoneNumber,
      }),
    );

    if (response.statusCode == 201) {
      print('Order Complete');
      print('Your ID is ${user.uid}');
    } else {
      print('Data not posted: ${response.body}');
      throw Exception('Failed to make a new order');
    }
  }

  Future<void> GetDataAddress() async {
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
        addresses = result.map((address) => address.toString()).toList();
        if (addresses.isNotEmpty) {
          selectedAddress = addresses.first;
          addressController.text = selectedAddress;
        }
        isLoading = false;
      });
    } else {
      // Handle the case when the server response is not OK
      setState(() {
        isLoading = false;
      });
      const Text('We have some error');
    }
  }

  Future<void> GetDataPhoneNumber() async {
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
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['user']['phoneNumber'] as String;
      setState(() {
        products = [
          {'phoneNumber': result}
        ];
        phoneNumberController.text = result;
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
      print('your id is ${user.uid}');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Address is not Added Successfully');
      throw Exception('Failed to Add Address');
    }
  }
}
