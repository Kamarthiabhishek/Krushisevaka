import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_app_final/Adders/AddRentalsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewRentals extends StatefulWidget {
  const ViewRentals({Key? key}) : super(key: key);

  @override
  State<ViewRentals> createState() => _ViewRentalsState();
}

class _ViewRentalsState extends State<ViewRentals> {
  TextEditingController _productName = TextEditingController();
  TextEditingController _PriceController = TextEditingController();
  TextEditingController _CategoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Rentals');
  final CurrentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Rentals"),
        backgroundColor: Color(0XFF089dae),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF089dae),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddRentalsScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Rentals")
            .where("UserID", isEqualTo: CurrentUser.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 200,
                                child: Image.network(
                                  '${documentSnapshot['Image']}',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 175,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Product Name :",
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${documentSnapshot['Product Name']}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Product Price :",
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${documentSnapshot['Price']}' +
                                            ' /Day',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Location : ",
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${documentSnapshot['Location']}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _update(documentSnapshot);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      SizedBox(
                                        width: 150,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _delete(documentSnapshot.id);
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _productName.text = documentSnapshot['Product Name'];
      _PriceController.text = documentSnapshot['Price'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _productName,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _PriceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = _productName.text;
                    final String? price = _PriceController.text;
                    if (price != null) {
                      await _products
                          .doc(documentSnapshot!.id)
                          .update({"Product Name": name, "Price": price});
                      _productName.text = '';
                      _PriceController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }
}
