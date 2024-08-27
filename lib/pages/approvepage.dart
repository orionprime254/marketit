import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'displaypage.dart';
import 'homepage.dart';

class AdminApprovalPage extends StatefulWidget {
  @override
  _AdminApprovalPageState createState() => _AdminApprovalPageState();
}

class _AdminApprovalPageState extends State<AdminApprovalPage> {
  final CollectionReference _pendingItems =
      FirebaseFirestore.instance.collection('pending_items');
  final CollectionReference _uploads =
      FirebaseFirestore.instance.collection('uploads');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Approval')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _pendingItems.where('isApproved', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;
          if (items.isEmpty) {
            return Center(child: Text('No items to approve'));
          }

          return GridView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              List<String> imageUrls = List<String>.from(item['images']);
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayPage(
                          imageUrls: imageUrls,
                          name: item['Title'],
                          price: item['Price'].toString(),
                          description: item['Description'],
                          userEmail: item['userId'],
                        ),
                      ),
                    );
                  },
                  child: SingleChildScrollView(
                    child: Container(
                    //  height: MediaQuery.of(context).size.height,
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
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: imageUrls.first,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              height: 155,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Text(
                                      "${item['Title']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text("${item['county']}")
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ksh ${item['Price']}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${item['Category']}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.check),
                                      onPressed: () async {
                                        await _approveItem(item.id,
                                            item.data() as Map<String, dynamic>);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () async {
                                        await _declineItem(item.id);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
              // return ListTile(
              //   title: Text(item['Title']),
              //   subtitle: Text('Price: \$${item['Price']}'),
              //   trailing: IconButton(
              //     icon: Icon(Icons.check),
              //     onPressed: () async {
              //       await _approveItem(item.id, item.data() as Map<String, dynamic>);
              //     },
              //   ),
              // );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
          );
        },
      ),
    );
  }

  Future<void> _approveItem(
      String itemId, Map<String, dynamic> itemData) async {
    // Move item to uploads collection
    await _uploads.doc(itemId).set(itemData);

    // Remove item from pending_items collection
    await _pendingItems.doc(itemId).delete();
  }

  Future<void> _declineItem(String itemId) async {
    await _pendingItems.doc(itemId).delete();
  }
}
