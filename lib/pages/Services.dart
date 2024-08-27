import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketit/cards/objectcard.dart';
import 'package:marketit/pages/homepage.dart';

import '../ads/custom_banner.dart';
import '../cards/goods.dart';
import '../cards/goodtile.dart';
import 'displaypage.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

 Stream<QuerySnapshot>? _stream;

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _stream = FirebaseFirestore.instance
        .collection('uploads')
        .where('Category', isEqualTo: 'Services')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        //backgroundColor: Colors.grey[900],
        appBar: AppBar(
            centerTitle:true,
          title: const Text('S E R V I C E S'),
        ),
        body: Stack(
          children: [SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Some error occured ${snapshot.error}"),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      QuerySnapshot querySnapshot = snapshot.data!;
                      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                      List<Map> itemsFromFirestore =
                      documents.map((e) => e.data() as Map).toList();
                      // final containsBed = snapshot.data!.docs.any((doc) => (doc['Category'] as String).toLowerCase().contains("Bed"));
                      //   if (containsBed){
                      if (documents.isEmpty) {
                        return const Center(child: Text("No Services"));
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: itemsFromFirestore.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          Map thisItem = itemsFromFirestore[index];
                          String itemId = documents[index].id;
                          List<String> imageUrls = List<String>.from(thisItem['images']);
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DisplayPage(
                                      imageUrls: imageUrls,
                                      name: thisItem['Title'],
                                      price: thisItem['Price'].toString(),
                                      description: thisItem['Description'],userEmail: thisItem['userId'],
                                    ),
                                  ),
                                );
                              },
                              child: ProductContainer(
                                imageUrls: imageUrls,
                                itemId: itemId,
                                thisItem: thisItem,
                              )
                          );
                        },
                      );
                    }),
              ],
            ),
          ),Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50, // Adjust height as needed
              color: Colors.transparent, // Or any color to fit your design
              child: CustomBannerAd(), // Your custom banner ad widget
            ),
          ),]
        ));
  }
}
