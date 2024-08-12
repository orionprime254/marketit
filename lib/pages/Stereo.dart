import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketit/components/pricefilterwidget.dart';
import 'package:marketit/pages/homepage.dart';
import 'package:provider/provider.dart';

import '../cards/goods.dart';
import '../cards/goodtile.dart';
import '../components/item_provider.dart';
import 'displaypage.dart';

class StereoPage extends StatefulWidget {
  const StereoPage({super.key});

  @override
  State<StereoPage> createState() => _StereoPageState();
}

late Stream<QuerySnapshot> _stream;

class _StereoPageState extends State<StereoPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _stream = FirebaseFirestore.instance
        .collection('uploads')
        .where('Category', isEqualTo: 'Stereos')
        .snapshots();
  }
  void _updatePriceFilter(double minPrice, double maxPrice) {
    Provider.of<ItemProvider>(context, listen: false).setPriceFilter(minPrice, maxPrice);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle:true,
          title: const Text('S T E R E O'),
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
                  child: CircularProgressIndicator(),
                );
              }
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              List<Map> itemsFromFirestore =
              documents.map((e) => e.data() as Map).toList();
              // final containsBed = snapshot.data!.docs.any((doc) => (doc['Category'] as String).toLowerCase().contains("Bed"));
              //   if (containsBed){
              if (documents.isEmpty) {
                return const Center(child: Text("No sTEREo Uploaded"));
              }

              return SingleChildScrollView(
                  child: Column(
                    children: [
                      // PriceFilterWidget(
                      //   minPrice: 0,
                      //   maxPrice: 50000,
                      //   onPriceChanged: _updatePriceFilter,
                      // ),
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
                              itemId: itemId,
                              thisItem: thisItem,
                              imageUrls: imageUrls,
                            )
                          );
                        },
                      )
                    ],
                  ));
            }));
  }
}
