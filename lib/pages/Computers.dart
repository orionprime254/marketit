import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'displaypage.dart';
class ComputersPage extends StatefulWidget {
  const ComputersPage({super.key});

  @override
  State<ComputersPage> createState() => _BedPageState();
}
late Stream<QuerySnapshot> _stream;
class _BedPageState extends State<ComputersPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _stream = FirebaseFirestore.instance.collection('uploads').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Center(child: Text('C O M P U T E R S')),
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              List<Map> itemsFromFirestore =
              documents.map((e) => e.data() as Map).toList();
              final containsBed = snapshot.data!.docs.any((doc) => (doc['Category'] as String).toLowerCase().contains('Computers&Hardware'));
              if (containsBed){
                return SingleChildScrollView(child:
                Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: itemsFromFirestore.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        mainAxisExtent: 200,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        Map thisItem = itemsFromFirestore[index];
                        String itemId = documents[index].id;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisplayPage(
                                  imageUrl: thisItem['image'],
                                  name: thisItem['Title'],
                                  price: thisItem['Price'].toString(),
                                  description: thisItem['Description'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 300,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black54),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.network(
                                      "${thisItem['image']}",
                                      //errorWidget: (context, url, error) => Icon(Icons.error),
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      alignment: FractionalOffset.center,
                                      //imageUrl:  "${thisItem['image']}",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "${thisItem['Title']}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "Ksh ${thisItem['Price']}",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(right: 10.0),
                                    //   child: IconButton(
                                    //     onPressed: () {
                                    //       toggleWishlist(itemId);
                                    //     },
                                    //     icon: wishlist.contains(itemId)
                                    //         ? Icon(
                                    //       Icons.favorite,
                                    //       color: Colors.red,
                                    //     )
                                    //         : Icon(Icons.favorite_border),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                )
                );
              }
              else {
                return Text("No Bed Uploaded");
              }
            }

        )
    );
  }
}
