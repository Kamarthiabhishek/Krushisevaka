import 'package:farmer_app_final/Controllers/SplashController.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService splash = SplashService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splash.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Text(
                'Agricultural Management',
                style: TextStyle(fontSize: 31, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            child: Center(
              child: Text(
                'Using ML Techniques',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
