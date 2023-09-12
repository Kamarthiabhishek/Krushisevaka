import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewScreen extends StatefulWidget {
  static String routeName = "/new-screen";

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  int count = 0;

  List<String> listOfImage = [
    'assets/images/CornCommonRust1.JPG',
    // 'assets/images/CornHealthy.JPG',
    'assets/images/PotatoEarlyBlight2.JPG',
    'assets/images/PotatoHealthy1.JPG',
    'assets/images/TomatoEarlyBlight1.JPG',
    'assets/images/TomatoHealthy1.JPG'
  ];

  int number = -1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   // onPressed: _addImages,
        //   onPressed: () {},
        // ),
        body: Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.6,
              width: double.maxFinite,
              child: GridView.builder(
                itemCount: listOfImage.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        number = index;
                      });
                    },
                    child: Container(
                      height: size.height * 0.2,
                      // width: size.width * 0.2,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(listOfImage[index]),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0, top: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  number == index ? Colors.pink : Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            number == 0
                ? Text(
                    'CornCommonRust \n \n Cure: Spray of mancozeb@ 2.5g/litre of water at first appearance of pustules. Prefer early maturing varieties.')
                : number == 1
                    ? Text(
                        'PotatoEarlyBlight \n \n Cure: Avoid overhead irrigation. Do not dig tubers until they are fully mature in order to prevent damage. Do not use a field for potatoes that was used for potatoes or tomatoes the previous year.')
                    : number == 2
                        ? Text(
                            'PotatoHealthy \n \n Cure: Your plant is already healthy. take good care use proper fertilizers')
                        : number == 3
                            ? Text(
                                'TomatoEarlyBlight \n \n Cure:Treat organically with copper spray. Follow label directions. You can apply until the leaves are dripping, once a week and after each rain. Or you can treat it organically with a biofungicide like Serenade.')
                            : Text(
                                'TomatoHealthy \n \n Cure: Your plant is already healthy. take good care use proper fertilizers')
          ],
        ),
      ),
    ));
  }
}









// List<String> listOfImage = [
//       
//  ];