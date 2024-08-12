import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketit/pages/homepage.dart';

import '../cards/goods.dart';
import '../cards/goodtile.dart';
import 'displaypage.dart';

class ClothesPage extends StatefulWidget {
  const ClothesPage({super.key});

  @override
  State<ClothesPage> createState() => _ClothesPageState();
}

late Stream<QuerySnapshot> _stream;

class _ClothesPageState extends State<ClothesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _stream = FirebaseFirestore.instance
        .collection('uploads')
        .where('Category', isEqualTo: 'Clothes')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle:true,
          title: const Text('C L O T H E S'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Some error occured ${snapshot.error}"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              List<Map> itemsFromFirestore =
              documents.map((e) => e.data() as Map).toList();
              // final containsBed = snapshot.data!.docs.any((doc) => (doc['Category'] as String).toLowerCase().contains("Bed"));
              //   if (containsBed){
              if (documents.isEmpty) {
                return const Center(child: Text("No Clothes Uploaded"));
              }
              return SingleChildScrollView(
                  child: Column(
                    children: [

                      GridView.builder(
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
                                thisItem: thisItem,
                                itemId: itemId
                            )
                          );
                        },
                      )
                    ],
                  ));
            }));
  }
}
