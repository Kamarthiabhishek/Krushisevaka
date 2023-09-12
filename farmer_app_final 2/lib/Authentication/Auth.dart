import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_app_final/Authentication/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

  class Users {
    String? userId;

    Users(String uid, {this.userId});
  }

class AuthResults {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _userFromFirebaseUser(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? Users(user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetpass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }
  var myUser= UserModel().obs;
  getUserData(){
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).snapshots().listen((event) {
      myUser.value = UserModel.fromJson(event.data()!);
    });
  }
}

