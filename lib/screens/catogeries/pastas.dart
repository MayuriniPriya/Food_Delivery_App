import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/product_card.dart';
import '../../widgets/product_list.dart';
import '../product_page.dart';

class Pastas extends StatefulWidget {
  const Pastas({Key? key}) : super(key: key);

  @override
  State<Pastas> createState() => _PastasState();
}

class _PastasState extends State<Pastas> {
  final CollectionReference _productRef =
  FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: _productRef
            .where('type', isEqualTo: 'Pasta')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }

          // Collection data ready to display
          if (snapshot.connectionState == ConnectionState.done) {
            // Display the data inside a list view
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 8),

              //padding: EdgeInsets.only(top: 108.0, bottom: 12.0),
              children: snapshot.data!.docs.map<Widget>((document) {
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

                return ProductList(
                  title: data['name'],
                  price: data['price'],
                  productId: document.id,
                  imageUrl: data['images'][0],
                  desc: data['desc'],
                );
              }).toList(),
            );
          }

          // Loading state
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
