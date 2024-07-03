import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'displaypage.dart';
class SavedPage extends StatelessWidget {
  final List<String> wishlist;
  SavedPage({Key? key, required this.wishlist}) : super(key: key);
  List<Map> wishListItems= [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('S A V E D')),
      ),
      body:wishlist.isEmpty
          ? Center(
        child: Text(
          'No liked items yet!',
          style: TextStyle(color: Colors.white),
        ),
      )
          : FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('uploads').get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Some error occurred ${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          QuerySnapshot querySnapshot = snapshot.data!;
          List<QueryDocumentSnapshot> documents = querySnapshot.docs;
          List<Map> likedItems = documents
              .where((doc) => wishlist.contains(doc.id))
              .map((e) => e.data() as Map)
              .toList();

          return GridView.builder(
            itemCount: likedItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (BuildContext context, int index) {
              Map thisItem = likedItems[index];
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
                        userEmail: thisItem['userId'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black54,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: "${thisItem['image']}",
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          alignment: FractionalOffset.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${thisItem['Title']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Ksh ${thisItem['Price']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),


    );
  }
}
