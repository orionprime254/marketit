import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketit/pages/homepage.dart';
import 'package:provider/provider.dart';

import '../components/item_model.dart';
import '../components/item_provider.dart';
import 'displaypage.dart';

class BedPage extends StatefulWidget {
  const BedPage({super.key});

  @override
  State<BedPage> createState() => _BedPageState();
}

late Stream<QuerySnapshot> _stream;

class _BedPageState extends State<BedPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _stream = FirebaseFirestore.instance
        .collection('uploads')
        .where('Category', isEqualTo: 'Bed')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var itemProvider = Provider.of<ItemProvider>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('B E D'),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
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
                  return const Center(child: Text("No Bed Uploaded"));
                }
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
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
                            ),
                            // child: Container(
                            //   height: 300,
                            //   width: 200,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(12),
                            //       ),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Expanded(
                            //         child: ClipRRect(
                            //           borderRadius: const BorderRadius.vertical(
                            //             top: Radius.circular(12),
                            //           ),
                            //           child: CachedNetworkImage(
                            //             imageUrl: imageUrls.first,
                            //             errorWidget: (context, url, error) => const Icon(Icons.error),
                            //             height: 155,
                            //             width: double.infinity,
                            //             fit: BoxFit.cover,
                            //             alignment: FractionalOffset.center,
                            //           ),
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         height: 5,
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(left: 10.0),
                            //         child: Text(
                            //           "${thisItem['Title']}",
                            //           style: const TextStyle(fontWeight: FontWeight.bold),
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         height: 4,
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Text(
                            //               "Ksh ${thisItem['Price']}",
                            //               style: TextStyle(
                            //                   fontSize: 14,
                            //                   color: Colors.grey[700],
                            //                   fontWeight: FontWeight.bold),
                            //             ),
                            //             IconButton(
                            //               icon: Icon(
                            //                 itemProvider.savedItems.any((item) => item.id == itemId)
                            //                     ? Icons.favorite
                            //                     : Icons.favorite_border,
                            //                 color: itemProvider.savedItems
                            //                     .any((item) => item.id == itemId)
                            //                     ? Colors.red
                            //                     : null,
                            //               ),
                            //               onPressed: () {
                            //                 var currentItem = Item(
                            //                   id: itemId,
                            //                   title: thisItem['Title'],
                            //                   imageUrl: imageUrls.first,
                            //                   price: thisItem['Price'].toString(),
                            //                   description: thisItem['Description'],
                            //                   userId: thisItem['userId'],
                            //                 );
                            //                 if (itemProvider.savedItems
                            //                     .any((item) => item.id == itemId)) {
                            //                   itemProvider.removeItem(itemId);
                            //                 } else {
                            //                   itemProvider.addItemToSaved(currentItem);
                            //                 }
                            //               },
                            //             ),
                            //           ],
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                          );
                        },
                      )
                    ],
                  ),
                );
              }),
        ));
  }
}
