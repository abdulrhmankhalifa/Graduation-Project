import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  //instance of user
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;






  ///sign user in
  Future<UserCredential> signInWithEmailandPassword(
      String email , String password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      ///if not exist
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid' : userCredential.user!.uid,
        'email' : email,
      }, SetOptions(merge: true));

      return userCredential;
    }
    on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }

  }

  ///creat new user
  Future<UserCredential> signUpWithEmailandPassword(
      String email , String password) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ///After create new user , create a new  document for the user in the user collection
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid' : userCredential.user!.uid,
        'email' : email,
      });

      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);

    }
  }





 /// sign user out
 Future<void> signOut() async {

      return await FirebaseAuth.instance.signOut();

 }


}