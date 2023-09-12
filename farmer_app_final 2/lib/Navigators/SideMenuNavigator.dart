import 'package:farmer_app_final/Viewers/ViewProducts.dart';
import 'package:farmer_app_final/Viewers/ViewRentals.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/SignUpScreen.dart';
import '../Screens/profilePage.dart';

class SideMenuBar extends StatefulWidget {
  @override
  _SideMenuBarState createState() => _SideMenuBarState();
}

class _SideMenuBarState extends State<SideMenuBar> {
  final CurrentUser = FirebaseAuth.instance;
  String ImageUrl = '';
  var _file;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 270,
                  height: 65,
                  decoration: BoxDecoration(
                      color: Color(0XFF089dae),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Welcome!",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("uid", isEqualTo: CurrentUser.currentUser?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 120,
                                          ),
                                          // IconButton(
                                          //     onPressed: () {
                                          //       FirebaseAuth.instance.signOut();
                                          //       Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //               builder: (context) =>
                                          //                   Login()));
                                          //     },
                                          //     icon: Icon(Icons.logout))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      ListTile(
                                        title: Text(data['First name']),
                                        subtitle: Text(data['Mobile']),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              }),
          ListTile(
            title: Text("My Products"),
            leading: Icon(Icons.production_quantity_limits),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewProducts()));
            },
          ),
          ListTile(
            title: Text("My Rentals"),
            leading: Icon(Icons.build),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewRentals()));
            },
          ),
          ListTile(
            title: Text("Profile"),
            leading: Icon(Icons.person),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Register()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
