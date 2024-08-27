import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marketit/pages/homepage.dart';

import '../cards/goods.dart';
import '../cards/goodtile.dart';
import 'displaypage.dart';

class TvPage extends StatefulWidget {
  const TvPage({super.key});

  @override
  State<TvPage> createState() => _TvPageState();
}

 Stream<QuerySnapshot>? _stream;

class _TvPageState extends State<TvPage>with WidgetsBindingObserver {
  String _locality = 'Loading...';
  bool isPaused = false;

  get appOpenAdManager => null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initStream();

  }
  Future<void> _initStream()async{
    String locality = await getUserLocality();
    setState(() {
      _locality = locality;
      _stream = FirebaseFirestore.instance
          .collection('uploads')
          .where('Category', isEqualTo: 'TV')
          .where('county', isEqualTo: _locality)
          .snapshots();
    });
  }
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print('resumed=============');
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }
  }
  Future<void> _updateLocality() async {
    String locality = await getUserLocality();
    setState(() {
      _locality = locality;
      // _stream = FirebaseFirestore.instance.collection('uploads').where('county',isEqualTo: _locality).snapshots();
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
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle:true,
          title: Text('T V'),
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
                        return Center(
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
                        return Center(child: Text("No Tv Uploaded"));
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                      );
                    }),
              ],
            ),
          ),]
        ));
  }
}
