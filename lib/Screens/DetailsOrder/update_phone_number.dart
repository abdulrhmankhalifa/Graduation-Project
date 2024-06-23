import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../Styles/colors.dart';

class UpdatePhoneNumberScreen extends StatefulWidget {
  const UpdatePhoneNumberScreen({super.key});

  @override
  State<UpdatePhoneNumberScreen> createState() =>
      _UpdatePhoneNumberScreenState();
}

class _UpdatePhoneNumberScreenState extends State<UpdatePhoneNumberScreen> {
  TextEditingController newPhoneNumberController = TextEditingController();
  bool isLoading = true;
  List products = [];

  @override
  void initState() {
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context) {
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
          'Phone Number',
          style: TextStyle(
            color: defaultColor,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                UpdatePhoneNumber(newPhoneNumberController.text);
                Navigator.pop(context);
              },
              child: const Text(
                'Update',
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
              SizedBox(
                height: screenHeight * 0.2,
              ),
              RefreshIndicator(
                onRefresh: GetData,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: defaultColor, width: 3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Text(
                            'Phone Number : ',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            products.isNotEmpty
                                ? products[IndexNum]['phoneNumber']
                                : 'N/A',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: defaultColor, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Update Your Phone Number :',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        TextField(
                          controller: newPhoneNumberController,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: defaultColor,
                                width: 2.0,
                              ),
                            ),
                            hintText: '  New Phone Number...',
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
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
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['user']['phoneNumber'] as String;
      setState(() {
        products = [
          {'phoneNumber': result}
        ];
      });
    } else {
      // Handle the case when the server response is not OK
      setState(() {
        isLoading = false;
      });
      const Text('we have some error');
    }
  }

  Future<void> UpdatePhoneNumber(String newNumber) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final url = Uri.parse(
        'https://graduation-project-nodejs.onrender.com/api/users/phoneNumber');
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
        'phoneNumber': newNumber,
        'firebaseId': user!.uid,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('Phone Number Update or added Successfully');
      print('your id is ${user.uid}');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Phone Number is not Updated or added Successfully');
      throw Exception('Failed to Add Address');
    }
  }
}
