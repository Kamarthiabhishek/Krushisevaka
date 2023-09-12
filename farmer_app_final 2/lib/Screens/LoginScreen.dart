import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Navigators/BottomNavBarScreen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _storage = FlutterSecureStorage();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/images/farmerlogo.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
                  ),
                  Row(
                    children: const [
                      Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: _emailcontroller,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        border: OutlineInputBorder( 
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Row(
                    children: const [
                      Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: _passwordcontroller,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      // pref.setString("email", _emailcontroller.text);
                      String? mail = _emailcontroller.text.trim();
                      String? pass = _passwordcontroller.text.trim();

                      if (mail.isEmpty && pass.isEmpty) {
                        var SnacBar =
                            SnackBar(content: Text("Enter Credentials"));
                        ScaffoldMessenger.of(context).showSnackBar(SnacBar);
                      } else {
                        try {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          final login = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: mail, password: pass)
                              .then((value) {
                            prefs.setString("email", _emailcontroller.text);
                            if (value != null) {
                              print(prefs.getString('email'));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BottomNavBarScreen()));
                            }
                          });
                          // await _storage.write(
                          //   key: 'uid',
                          //   value: login.user!.uid,
                          // );
                        } catch (e) {
                          print("Erorr $e");
                          var snk = SnackBar(
                              content: Text("Enter correct Credntials"));
                          ScaffoldMessenger.of(context).showSnackBar(snk);
                        }
                      }
                    },
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(280, 50),
                        backgroundColor: Color(0XFF089dae),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  Row(
                    children: [
                      Text("Forgot password?"),
                      TextButton(
                          onPressed: () {}, child: Text("Reset Password"))
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
