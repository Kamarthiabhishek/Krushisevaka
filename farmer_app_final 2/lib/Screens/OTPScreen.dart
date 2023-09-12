import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../Navigators/BottomNavBarScreen.dart';
import 'SignUpScreen.dart';

class MyOtp extends StatefulWidget {
  const MyOtp({Key? key}) : super(key: key);
  @override
  State<MyOtp> createState() => _MyOtp();
}

class _MyOtp extends State<MyOtp> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //Pinput for otp reading//

    Widget buildPinPut() {
      return Pinput(
        onCompleted: (pin) => print(pin),
      );
    }

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    var code = "";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 0),
                  height: 400,
                  width: 400,
                  child: Icon(
                    Icons.manage_accounts,
                    size: 300,
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Phone Verification',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'You need to Verify your phone to get started!',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Pinput(
                          length: 6,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onChanged: (value) {
                            code = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 55,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  PhoneAuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: Register.Verify,
                                          smsCode: code);

                                  // Sign the user in (or link) with the credential
                                  await auth.signInWithCredential(credential);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BottomNavBarScreen()));
                                } catch (e) {
                                  print('Wrong OTP');
                                }
                              },
                              child: Text("Verify"),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(280, 50),
                                  backgroundColor: Color(0XFF089dae),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))),
                        ),
                        Row(
                          children: [
                            Text(
                              "Entered wrong mobile number?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Edit Number"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
