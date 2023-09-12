
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

late FirebaseAuth _auth;
final _user = Rxn<User>();
late Stream<User?> _authStateChanges;

void initAuth() async{
  _auth =FirebaseAuth.instance;
  _authStateChanges = _auth.authStateChanges();
  _authStateChanges.listen((User? user){
    _user.value = user;
    print("UserId ${user?.uid}");
  });
}