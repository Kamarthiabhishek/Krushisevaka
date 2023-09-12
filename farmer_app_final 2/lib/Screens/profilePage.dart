import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final CurrentUser = FirebaseAuth.instance;
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  final TextEditingController _datetext = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String? dropdownValue = 'Male';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color(0XFF089dae),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("uid", isEqualTo: CurrentUser.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'First Name',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                onChanged: (value) {
                                  _fname.text = value;
                                },
                                initialValue: data['First name'],
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'First Name',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 30,
                            ),
                            Row(
                              children: const [
                                Text(
                                  'Last Name',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                onChanged: (value) {
                                  _lname.text = value;
                                },
                                initialValue: data['Last name'],
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Last Name',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 30,
                            ),
                            Row(
                              children: const [
                                Text(
                                  'Gender',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
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
                                      'Male',
                                      'Female',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 30,
                            ),
                            Row(
                              children: const [
                                Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                controller: _datetext,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                  prefixIcon: Icon(Icons.calendar_month),
                                      //icon of text field
                                      hintText:
                                          "Date of birth"
                                ),
                                readOnly: true,
                                //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    //you can implement different kind of Date Format here according to your requirement

                                    setState(() {
                                      _datetext.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {
                                    print("Date is not selected");
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 30,
                            ),
                            Row(
                              children: const [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                onChanged: (value) {
                                  _email.text = value;
                                },
                                readOnly: true,
                                initialValue: data['Email'],
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 30,
                            ),
                            Row(
                              children: const [
                                Text(
                                  'Mobile',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                onChanged: (value) {
                                  _phonenumber.text = value;
                                },
                                initialValue: data['Mobile'],
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Mobile',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 30,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                 String? date =  _datetext.text;
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(data.id)
                                      .update({
                                    'First name': _fname.text,
                                    'Last name': _lname.text,
                                    'Gender' :dropdownValue,
                                    'Date of Birth': date,
                                    'Mobile' : _phonenumber.text,
                                  });
                                  _fname.clear();
                                  _lname.clear();
                                },
                                child: Text("Update"),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(280, 50),
                                    backgroundColor: Color(0XFF089dae),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)))),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ));
  }
}
