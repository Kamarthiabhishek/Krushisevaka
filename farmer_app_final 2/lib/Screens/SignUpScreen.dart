import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_app_final/Screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OTPScreen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  static String Verify = "";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _storage = FlutterSecureStorage();

  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _dateofbirth = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _checkpassword = TextEditingController();

  String _Gender = "Male";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? phoneNumber, verificationId;
  String? otp, Authstatus = "";

  void _autoLogin() async {
    final uid = await _storage.read(key: 'uid');
    if (uid != null) {
      try {
        final email = await _storage.read(key: 'email');
        final password = await _storage.read(key: 'password');
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      }
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          Authstatus = "Your account is successfully verified";
          const snackBar =
              SnackBar(content: Text("Your account is successfully verified"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      },
      verificationFailed: (FirebaseAuthException authException) {
        setState(() {
          Authstatus = "Authentication failed";
          const snackBar = SnackBar(content: Text("Authentication failed"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      },
      codeSent: (String verId, [int? forceCodeResent]) {
        verificationId = verId;
        setState(() {
          Authstatus = "OTP has been successfully send";
          const snackBar =
              SnackBar(content: Text("OTP has been successfully send"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        //otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          Authstatus = "TIMEOUT";
          const snackBar = SnackBar(content: Text("TIMEOUT"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Text(
              "Registration",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            Row(
              children: const [
                Text(
                  'Name',
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
                controller: _firstname,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            // TextFormField(
            //   controller: _lastname,
            //   decoration: InputDecoration(
            //       border: OutlineInputBorder(), labelText: "Last Name"),
            // // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 30,
            // ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text("Gender"),
            //     SizedBox(
            //       height: 5,
            //     ),
            //     Row(
            //       children: [
            //         Expanded(
            //           child: ListTile(
            //             leading: Radio<String>(
            //               value: "Male",
            //               groupValue: _Gender,
            //               onChanged: (value) {
            //                 setState(() {
            //                   _Gender = value!;
            //                   print(value);
            //                 });
            //               },
            //             ),
            //             title: Text("Male"),
            //             tileColor: Color.fromARGB(255, 145, 238, 249),
            //             dense: true,
            //           ),
            //         ),
            //         SizedBox(
            //           width: 10,
            //         ),
            //         Expanded(
            //           child: ListTile(
            //             leading: Radio<String>(
            //               value: "Female",
            //               groupValue: _Gender,
            //               onChanged: (value) {
            //                 setState(() {
            //                   _Gender = value!;
            //                   print(value);
            //                 });
            //               },
            //             ),
            //             title: Text("Female"),
            //             tileColor: Color.fromARGB(255, 145, 238, 249),
            //             dense: true,
            //           ),
            //         )
            //       ],
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 30,
            // ),
            //

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
                controller: _email,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
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
                controller: _password,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      String? _name = _firstname.text.trim();
                      String? _mail = _email.text.trim();
                      String? _pass = _password.text.trim();
                      if (_name.isNotEmpty &&
                          _mail.isNotEmpty &&
                          _pass.isNotEmpty) {
                        try {
                          final UserCredential userCredential =
                              await _auth.createUserWithEmailAndPassword(
                            email: _mail,
                            password: _pass,
                          );

                          final String userId = userCredential.user!.uid;
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc()
                              .set({
                            "First name": _name,
                            "Last name": " ",
                            "Date of Birth": " ",
                            "Gender": " ",
                            "Mobile": " ",
                            "Email": _mail,
                            "Password": _pass,
                            "Profile ": " ",
                            "uid": userId
                          });
                          await _storage.write(
                              key: 'email', value: _email.text);
                          await _storage.write(
                              key: 'password', value: _password.text);
                          await _storage.write(
                              key: 'uid', value: userCredential.user!.uid);
                          var snk = SnackBar(
                              content: Text("Registered Successfully"));
                          await ScaffoldMessenger.of(context).showSnackBar(snk);
                        } catch (e) {
                          var snk = SnackBar(content: Text("Error Occured"));
                          await ScaffoldMessenger.of(context).showSnackBar(snk);
                        }
                      }
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                          // fontFamily: roboto
                          ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(280, 50),
                        backgroundColor: Color(0XFF089dae),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Color(0XFF089dae), fontSize: 14),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.black54,
                  width: 100,
                  height: 3,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("OR"),
                SizedBox(
                  width: 20,
                ),
                Container(
                  color: Colors.black54,
                  width: 100,
                  height: 3,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Login with mobile number',
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
                onChanged: (Value) {
                  phoneNumber = Value;
                },
                keyboardType: TextInputType.number,
                controller: _phonenumber,
                onTap: () {
                  _firstname.text = "";
                  _email.text = "";
                  _password.text = "";
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Mobile number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      String? mobile = phoneNumber.toString();
                      if (mobile.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '${"+91" + phoneNumber!}',
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent:
                                (String verificationId, int? resendToken) {
                              Register.Verify = verificationId;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyOtp()));
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                          createUserDocument(mobile);
                          print(mobile);
                          var snk =
                              SnackBar(content: Text("Login Successfully"));
                          await ScaffoldMessenger.of(context).showSnackBar(snk);
                        } catch (e) {
                          var snk = SnackBar(content: Text("$e"));
                          await ScaffoldMessenger.of(context).showSnackBar(snk);
                        }
                      }
                    },
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(280, 50),
                        backgroundColor: Color(0XFF089dae),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Future<void> createUserDocument(String mobileNumber) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(mobileNumber).set({
        'uid': user.uid,
        'Mobile': mobileNumber,
        "First name": " ",
        "Last name": " ",
        "Date of birth": " ",
        "Gender": " ",
        "Email": " ",
        "Password": " ",
        "Profile ": " ",
      });
    }
  }

  // Future<void> saveDataLocally(
  //   BuildContext context,
  //   User currentUser,
  //   dynamic collName,
  //   TextEditingController emailCont,
  //   String role,
  // ) async {
  //   // Fetch user data from Firestore based on the user's UID
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection(collName)
  //       .doc(currentUser.uid)
  //       .get();

  //   // Store data in SharedPreferences
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // Store the user ID, email, and username locally using SharedPreferences
  //   final data = snapshot.data();
  //   if (data != null) {
  //     await prefs.setString("useruid", currentUser.uid);
  //     await prefs.setString('collectionName', collName);
  //     await prefs.setString('username', data['userName']);
  //     await prefs.setString('email', emailCont.text);
  //     await prefs.setString('role', role);
  //   }
  // }
}
