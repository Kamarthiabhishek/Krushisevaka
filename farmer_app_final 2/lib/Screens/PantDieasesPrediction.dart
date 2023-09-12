import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';

class DemoPlants extends StatefulWidget {
  const DemoPlants({Key? key}) : super(key: key);

  @override
  State<DemoPlants> createState() => _DemoPlantsState();
}

class _DemoPlantsState extends State<DemoPlants> {
  @override
  Widget build(BuildContext context) {
    var _file;
    return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                color: Colors.grey.shade300,
                child: _file == null
                    ? Center(child: Text("Select Image!"))
                    : Image.file(_file),
                height: 330,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.add_event,
          backgroundColor: Color(0XFF089dae),
          children: [
            SpeedDialChild(
                child: Icon(Icons.photo_camera),
                label: "Camera",
                onTap: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _file = File(file!.path);
                  });
                  if (file == null) return;
                }),
            SpeedDialChild(
                child: Icon(Icons.image),
                label: "Gallery",
                onTap: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _file = File(file!.path);
                  });
                  if (file == null) return;
                }),
          ],
        ));
  }
}
