import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DemoConnect extends StatefulWidget {
  const DemoConnect({Key? key}) : super(key: key);

  @override
  State<DemoConnect> createState() => _DemoConnectState();
}

class _DemoConnectState extends State<DemoConnect> {
  TextEditingController _productNamecontroller = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CurrentUser = FirebaseAuth.instance;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Products")
              .where("UserID", isNotEqualTo: CurrentUser.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              List<Map> items = documents.map((e) => e.data() as Map).toList();
              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = items[index];
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Container(
                            height: 380,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade300,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Container(
                                        width: 400,
                                        height: 200,
                                        child: thisItem.containsKey('Image')
                                            ? Image.network(
                                                '${thisItem['Image']}',
                                                fit: BoxFit.fill,
                                              )
                                            : Container()),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${thisItem['Product Name']}',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${thisItem['Price']}',
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text('Contact:  ' +
                                          '${thisItem['Phone Number']}',
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
