import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_app_final/Adders/AddProducts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewProducts extends StatefulWidget {
  const ViewProducts({Key? key}) : super(key: key);

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  TextEditingController _productName = TextEditingController();
  TextEditingController _PriceController = TextEditingController();
  TextEditingController _qunatityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Products');

  final CurrentUser = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("View Products"),
          backgroundColor: Color(0XFF089dae),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0XFF089dae),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddProducts()));
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Products")
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
                    child: Column(
                      children: [
                        Container(
                          height: 400,
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
                                      child: Image.network(
                                        '${documentSnapshot['Image']}',
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${documentSnapshot['Product Name']}',
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
                                      '${documentSnapshot['Price']}' +
                                          " / "
                                              '${documentSnapshot['Quantity']}',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${documentSnapshot['Phone Number']}',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    )
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
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
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
