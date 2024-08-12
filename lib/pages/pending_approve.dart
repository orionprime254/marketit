import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'displaypage.dart';

class PendingApprovePage extends StatefulWidget {
  const PendingApprovePage({super.key});

  @override
  State<PendingApprovePage> createState() => _PendingApprovePageState();
}

class _PendingApprovePageState extends State<PendingApprovePage> {
  final CollectionReference _pendingItems = FirebaseFirestore.instance.collection('pending_items');
  final CollectionReference _uploads = FirebaseFirestore.instance.collection('uploads');

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Pending Approvals')),
        body: Center(child: Text('Please log in to view your pending items.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Pending Approvals')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _pendingItems.where('userId', isEqualTo: user.email).where('isApproved', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;
          if (items.isEmpty) {
            return Center(child: Text('No pending items.'));
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
                child: Container(
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
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          height: 155,
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
                              "${item['Title']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ksh ${item['Price']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
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
}
