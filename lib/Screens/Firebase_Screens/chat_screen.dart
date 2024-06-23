import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Styles/colors.dart';
import 'chat_page.dart';

class HomeChatScreen extends StatefulWidget {
  const HomeChatScreen({super.key});

  @override
  State<HomeChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<HomeChatScreen> {
  /// instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: defaultColor, // Change your color here
          ),
          title: const Center(
            child: Text(
              'Chat Service',
              style: TextStyle(
                fontSize: 25.0,
                color: defaultColor,
              ),
            ),
          ),
        ),
        body: _buildUserList());
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }

          return ListView(
            children: snapshot.data!.docs
                .where((doc) => doc['email'] != 'adminapp@gmail.com')
                .map((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  ///build indvidual user list item
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all user except the current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          //pass the clicked
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverUserEmail: data['email'],
                  receiverUserID: data['uid'],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
