import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final TextEditingController _pnameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final CollectionReference   _products =
      FirebaseFirestore.instance.collection('Products');
  var _file;
  String ImageUrl = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF089dae),
        title: Text("Add Products"),
        centerTitle: true,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    child: _file == null
                        ? Center(child: Text("Select Image!"))
                        : Image.file(_file),
                    height: 330,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.camera);
                            setState(() {
                              _file = File(file!.path);
                            });
                            if (file == null) return;
                            String uniqueFile = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImage =
                                referenceRoot.child('images');
                            Reference referenceDirImages =
                                referenceDirImage.child('name');
                            Reference referenceImageToUpload =
                                referenceDirImage.child(uniqueFile);

                            await referenceImageToUpload
                                .putFile(File(file.path));
                            ImageUrl =
                                await referenceImageToUpload.getDownloadURL();
                          },
                          icon: Icon(Icons.photo_camera)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                      ),
                      IconButton(
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              _file = File(file!.path);
                            });
                            if (file == null) return;
                            String uniqueFile = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImage =
                                referenceRoot.child('images');
                            Reference referenceDirImages =
                                referenceDirImage.child('name');
                            Reference referenceImageToUpload =
                                referenceDirImage.child(uniqueFile);

                            await referenceImageToUpload
                                .putFile(File(file.path));
                            ImageUrl =
                                await referenceImageToUpload.getDownloadURL();
                          },
                          icon: Icon(Icons.image)),
                    ],
                  ),
                  TextFormField(
                    controller: _pnameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Product Name"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Price"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Quantity"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Description"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  TextFormField(
                    controller: _phoneNumber,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Mobile number"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 55),
                          backgroundColor: Color(0XFF089dae)),
                      onPressed: () {
                        String? name = _pnameController.text.trim();
                        String? price = _priceController.text.trim();
                        String? quantity = _quantityController.text.trim();
                        String? description =
                            _descriptionController.text.trim();
                        String? phonenumber = _phoneNumber.text.trim();
                        final currentUser = FirebaseAuth.instance.currentUser;
                        final DocumentReference docRef = _products.doc();
                        final Uid = currentUser!.uid;
                        if (name.isNotEmpty &&
                            price.isNotEmpty &&
                            quantity.isNotEmpty &&
                            description.isNotEmpty && phonenumber.isNotEmpty) {
                          try {
                            _products.add({
                              "Product Name": name,
                              "Price": price,
                              "Quantity": quantity,
                              "Description": description,
                              "Image": ImageUrl,
                              "Phone Number": phonenumber,
                              "ProductId": docRef.id,
                              "UserID": Uid,
                            });
                            _pnameController.text = "";
                            _priceController.text = "";
                            _descriptionController.text = "";
                            var snk = SnackBar(
                                content: Text("Product Added Successfully"));
                            ScaffoldMessenger.of(context).showSnackBar(snk);
                            Navigator.of(context).pop();
                          } catch (e) {
                            var snk =
                                SnackBar(content: Text("Try after sometime"));
                            ScaffoldMessenger.of(context).showSnackBar(snk);
                          }
                        }
                      },
                      child: Text("Add Products"))
                ],
              ),
            ),
          )),
    );
  }
}
