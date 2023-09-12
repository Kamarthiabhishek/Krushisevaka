import 'dart:convert';

import 'package:farmer_app_final/Screens/LoginScreen.dart';
import 'package:farmer_app_final/models/yeildpredictionmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DemoCrop extends StatefulWidget {
  const DemoCrop({Key? key});

  @override
  State<DemoCrop> createState() => _DemoCropState();
}

class _DemoCropState extends State<DemoCrop> {
  Yeildprediction yeild = Yeildprediction();
  String value = "";

  getUSer(String n_soil, String p_soil, String k_soil, String temparature,
      String humidity, String ph, String rainfall) async {
    Map data = {
      "N_SOIL": n_soil,
      "N_SOIL": n_soil,
      "P_SOIL": p_soil,
      "K_SOIL": k_soil,
      "TEMPARATURE": temparature,
      "HUMIDITY": humidity,
      "PH": ph,
      "RAINFALL": rainfall
    };
    final response = await http.post(
        Uri.parse("https://crop-prediction-c88p.onrender.com/api/analyze/"),
        headers: {
          'Authorization': 'Token dc7e96ed776bc44d013b44fdfe560a616c64646f',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      yeild = Yeildprediction.fromJson(jsonDecode(response.body));
      print("the data is $yeild");
      setState(() {
        // value = yeild;
      });
    }
  }

  final TextEditingController _nsoil = TextEditingController();
  final TextEditingController _psoil = TextEditingController();
  final TextEditingController _ksoil = TextEditingController();
  final TextEditingController _temp = TextEditingController();
  final TextEditingController _humidity = TextEditingController();
  final TextEditingController _soilph = TextEditingController();
  final TextEditingController _rainfall = TextEditingController();

  String _Gender = "Male";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 45,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Crop Yeild Prediction",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            TextFormField(
              controller: _nsoil,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "N_SOIL"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            TextFormField(
              controller: _psoil,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "P_SOIL"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            TextFormField(
              controller: _ksoil,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "K_SOIL"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            TextFormField(
              controller: _temp,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "TEMPERATURE"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            TextFormField(
              controller: _humidity,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "AIR HUMIDITY"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            TextFormField(
              controller: _soilph,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "SOIL PH"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            TextFormField(
              controller: _rainfall,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "RAINFALL"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      try {
                        getUSer(
                            _nsoil.text,
                            _psoil.text,
                            _ksoil.text,
                            _temp.text,
                            _humidity.text,
                            _soilph.text,
                            _rainfall.text);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("The Predicted Crop"),
                              content: SizedBox(
                                width: 300,
                                height: 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Center(
                                      child: Text(
                                        yeild.prediction!,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Color(0XFF089dae)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        print("Plant Error: $e");
                      }
                    },
                    child: Text(
                      "Start prediction",
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
          ]),
        ),
      ),
    );
  }
}
