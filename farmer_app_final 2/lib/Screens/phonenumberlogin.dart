import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LoginScreen.dart';
import 'OTPScreen.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key? key}) : super(key: key);
  static String Verify = "";

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  TextEditingController CountryCode = TextEditingController();
  String? phoneNumber, verificationId;
  String? otp, Authstatus = "";

  Future<void> signIn(String otp) async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
      verificationId: verificationId.toString(),
      smsCode: otp,
    ));
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
  void initState() {
    // TODO: implement initState
    CountryCode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("!!"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "You need to verify number to Continue",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: 40,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: CountryCode,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "|",
                      style: TextStyle(
                        fontSize: 45,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            phoneNumber = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: '${CountryCode.text + phoneNumber!}',
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int? resendToken) {
                      PhoneNumber.Verify = verificationId;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyOtp()));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple,
                  ),
                  child: Center(
                    child: Text(
                      "Send",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        "Login with Password",
                        style: TextStyle(color: Colors.purple),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
