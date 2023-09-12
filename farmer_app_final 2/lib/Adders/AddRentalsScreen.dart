import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddRentalsScreen extends StatefulWidget {
  const AddRentalsScreen({super.key});

  @override
  State<AddRentalsScreen> createState() => _AddRentalsScreenState();
}

class _AddRentalsScreenState extends State<AddRentalsScreen> {
  final CollectionReference _rentals =
      FirebaseFirestore.instance.collection('Rentals');

  String? dropdownValue = 'Tractors';

  final TextEditingController _pname = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _location = TextEditingController();
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
                    controller: _pname,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Product Name"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    controller: _price,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Price"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(5)),
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(border: InputBorder.none),
                        isDense: true,
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        onChanged: (newValue) {
                          print(newValue);
                          setState(() {
                            dropdownValue = newValue as String?;
                          });
                        },
                        items: <String>[
                          'Tractors',
                          'Harvestors',
                          'Pestcides',
                          'Others'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    controller: _quantity,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Quantity"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    controller: _description,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Description"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    controller: _location,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Location"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    controller: _phone,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Phone number"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 55),
                          backgroundColor: Color(0XFF089dae)),
                      onPressed: () {
                        String? name = _pname.text.trim();
                        String? price = _price.text.trim();
                        String? quantity = _quantity.text.trim();
                        String? description = _description.text.trim();
                        String? location = _location.text.trim();
                        String? phone = _phone.text.trim();
                        final currentUser = FirebaseAuth.instance.currentUser;
                        final DocumentReference docRef = _rentals.doc();
                        final Uid = currentUser!.uid;
                        if (name.isNotEmpty &&
                            price.isNotEmpty &&
                            quantity.isNotEmpty &&
                            description.isNotEmpty &&
                            location.isNotEmpty&& phone.isNotEmpty) {
                          try {
                            _rentals.add({
                              "Product Name": name,
                              "Price": price,
                              "Quantity": quantity,
                              "Description": description,
                              "Image": ImageUrl,
                              "ProductId": docRef.id,
                              "UserID": Uid,
                              "Location": location,
                              "Phone Number": phone
                            });
                            _pname.text = "";
                            _price.text = "";
                            _description.text = "";
                            _quantity.text = "";
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
