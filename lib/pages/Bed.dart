import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marketit/ads/custom_banner.dart';
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

class _BedPageState extends State<BedPage> with WidgetsBindingObserver {
  String _locality = 'Loading...';
  bool isPaused = false;
  Stream<QuerySnapshot>? _stream;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  Future<void> _initStream() async {
    String locality = await getUserLocality();
    setState(() {
      _locality = locality;
      _stream = FirebaseFirestore.instance
          .collection('uploads')
          .where('Category', isEqualTo: 'Bed')
          .where('county', isEqualTo: _locality)
          .snapshots();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print('resumed=============');
      // Call your ad manager here if you have one
      isPaused = false;
    }
  }

  Future<void> _updateLocality() async {
    String locality = await getUserLocality();
    setState(() {
      _locality = locality;
      _stream = FirebaseFirestore.instance
          .collection('uploads')
          .where('Category', isEqualTo: 'Bed')
          .where('county', isEqualTo: _locality)
          .snapshots();
      print('...........................Querying for locality: $_locality');
    });
  }

  Future<String> getUserLocality() async {
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        return placemarks[0].locality ?? 'Unknown locality';
      }
    } catch (e) {
      print('Error getting location: $e');
    }
    return 'Unknown locality';
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50), // Space for the banner ad
                StreamBuilder<QuerySnapshot>(
                  stream: _stream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Some error occurred: ${snapshot.error}"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                    List<Map<String, dynamic>> itemsFromFirestore =
                    documents.map((e) => e.data() as Map<String, dynamic>).toList();

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
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: itemsFromFirestore.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> thisItem = itemsFromFirestore[index];
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
                                    description: thisItem['Description'],
                                    userEmail: thisItem['userId'],
                                  ),
                                ),
                              );
                            },
                            child: ProductContainer(
                              imageUrls: imageUrls,
                              thisItem: thisItem,
                              itemId: itemId,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50, // Adjust height as needed
              color: Colors.transparent, // Or any color to fit your design
              child: CustomBannerAd(), // Your custom banner ad widget
            ),
          ),
        ],
      ),
    );
  }
}
