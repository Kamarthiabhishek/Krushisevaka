import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> uploadProductToFirestore(String collectionName, String productId,
    Map<String, dynamic> productData) async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(productId)
        .set(productData);
}
