import 'package:farmer_app_final/Navigators/SideMenuNavigator.dart';
import 'package:farmer_app_final/Screens/YeildpredictionScreen.dart';
import 'package:farmer_app_final/Screens/RentalsScreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../Controllers/NavBarController.dart';
import '../Screens/SmartconnectScreen.dart';
import '../newScreen.dart';

class BottomNavBarScreen extends StatelessWidget {
  BottomNavBarScreen({Key? key}) : super(key: key);

  BottomNavBarController bottomNavigationController =
      Get.put(BottomNavBarController());
  final screens = [RentalsDemo(), NewScreen(), DemoCrop(), DemoConnect()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenuBar(),
      appBar: AppBar(
        title: Text("Farmer App"),
        centerTitle: true,
        backgroundColor: Color(0XFF089dae),
      ),
      body: Obx(() => IndexedStack(
            index: bottomNavigationController.SelectedIndex.value,
            children: screens,
          )),
      bottomNavigationBar: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 2, right: 2),
          child: Container(
            height: 65,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(      
                color: Color(0XFF089dae),
                borderRadius: BorderRadius.circular(20)),
            child: GNav(
              activeColor: Colors.white,
              iconSize: 25,
              gap: 3,
              textStyle: TextStyle(
                fontSize: 23,
                color: Colors.white,
              ),
              tabs: [
                GButton(
                  icon: Icons.build,
                  text: "Rentals",
                ),
                GButton(
                  icon: Icons.local_florist,
                  text: "Plant",
                ),
                GButton(
                  icon: Icons.attach_money,
                  text: "Crop",
                ),
                GButton(
                  icon: Icons.store,
                  text: "Connect",
                ),
              ],
              onTabChange: (value) {
                bottomNavigationController.ChangedIndex(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
