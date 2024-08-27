import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:marketit/ads/openad.dart';
import 'package:marketit/pages/Clothes.dart';
import 'package:marketit/pages/rental_house.dart';
import 'package:provider/provider.dart';
import '../ads/custom_banner.dart';
import '../ads/nativead.dart';
import '../cards/objectcard.dart';
import '../components/item_model.dart';
import '../components/item_provider.dart';
import 'Bed.dart';
import 'Computers.dart';
import 'Food.dart';
import 'Furniture.dart';
import 'Gas.dart';
import 'Phones.dart';
import 'Services.dart';
import 'Stereo.dart';
import 'TVs.dart';
import 'displaypage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String _locality = 'Loading...';
  bool isLiked = false;
  var myContr = Get.put(NativeController());
   Stream<QuerySnapshot>? _stream;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  voiddidChangeAppLifecycleState(AppLifecycleState state) {
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
      _stream = FirebaseFirestore.instance.collection('uploads').where('county',isEqualTo: _locality).snapshots();
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
  void initState() {
    super.initState();
    _updateLocality();
    myContr.loadAd();

    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
    _stream = FirebaseFirestore.instance.collection('uploads').where('county',isEqualTo: _locality).snapshots();


  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(_locality),
          )
        ],
        // leading: CupertinoSwitcher(),
        elevation: 2,
        centerTitle: true,
        title: const Text('M A R K E T I T'),
      ),
      //drawer: MyDrawer(onProfileTap: goToProfilePage),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Obx(() => Container(
            //       child: myContr.isAdLoaded.value
            //           ? ConstrainedBox(
            //               constraints:
            //                   BoxConstraints(maxHeight: 100, minHeight: 100),
            //               child: AdWidget(
            //                 ad: myContr.nativeAd!,
            //               ),
            //             )
            //           : SizedBox(),
            //     )),
            const CustomBannerAd(),
            // const SizedBox(height: 10),
            // const SizedBox(height: 25),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: SearchBar(
            //     controller: _searchController,
            //     onChanged: (query) {
            //       setState(() {
            //         _searchQuery = query;
            //       });
            //     },
            //   ),
            // ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.only(right: 225.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  //color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ProductTile(
                    productName: 'Beds',
                    imagePath: 'lib/imgs/bed.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BedPage()),
                      );
                    },
                  ),
                  ProductTile(
                    productName: 'Computers',
                    imagePath: 'lib/imgs/laptop.png',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ComputersPage()));
                    },
                  ),
                  ProductTile(
                    productName: 'Stereos',
                    imagePath: 'lib/imgs/loudspeaker-box.png',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StereoPage()));
                    },
                  ),
                  ProductTile(
                    productName: 'Phones',
                    imagePath: 'lib/imgs/mobile-app.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PhonesPage()),
                      );
                    },
                  ),
                  ProductTile(productName: 'Clothing', imagePath: 'lib/imgs/fashion.png', onTap:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClothesPage()),
                    );
                  },),
                  ProductTile(
                    productName: 'Services',
                    imagePath: 'lib/imgs/air-mattress.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ServicesPage()),
                      );
                    },
                  ),
                  ProductTile(
                    productName: 'Food',
                    imagePath: 'lib/imgs/dinner.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FoodPage()),
                      );
                    },
                  ),

                  ProductTile(
                    productName: 'Rent/Hostel',
                    imagePath: "lib/imgs/home.png",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RentalsPage()),
                      );
                    },
                  ),
                  ProductTile(
                    productName: 'TVs',
                    imagePath: 'lib/imgs/television.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TvPage()),
                      );
                    },
                  ),
                  ProductTile(
                    productName: 'Gas Cylinder',
                    imagePath: 'lib/imgs/gas-stove.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GasPage()),
                      );
                    },
                  ),
                  ProductTile(
                    productName: 'Furniture',
                    imagePath: 'lib/imgs/armchair.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FurniturePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(right: 225.0),
              child: Text(
                'For you :p',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  //color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 6),
          //  _userPosition== null? const Center(child: CircularProgressIndicator(),):_filteredItems.isEmpty? const Center(child: Text('No items found in your area.')):
            StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Some error occurred ${snapshot.error}"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }else const Center(
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
                QuerySnapshot querySnapshot = snapshot.data!;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                List<Map> itemsFromFirestore =
                    documents.map((e) => e.data() as Map).toList();
                return GridView.builder(
                  itemCount: itemsFromFirestore.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10.0),
                  // Padding to avoid bottom navigation bar blocking
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = itemsFromFirestore[index];
                    String itemId = documents[index].id;
                    List<String> imageUrls =
                    List<String>.from(thisItem['images']);
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
                          itemId: itemId),
                    );
                  },
                );
             //    return GridView.builder(
             //
             //
             // //     itemCount: itemsFromFirestore.length +
             // //         (itemsFromFirestore.length ~/ 5),
             //      // Adjust the item count
             //      physics: const NeverScrollableScrollPhysics(),
             //      shrinkWrap: true,
             //      padding: const EdgeInsets.all(10.0),
             //      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
             //        crossAxisCount: 2,
             //        mainAxisSpacing: 10,
             //        childAspectRatio: 0.75,
             //      ),
             //      itemBuilder: (BuildContext context, int index) {
             //        // Determine the actual index for items
             //        int actualIndex = index - (index ~/ 5);
             //
             //        // Display the ad every 5th item
             //        if (index % 5 == 4) {
             //          return Obx(() {
             //            if (myContr.isAdLoaded.value &&
             //                myContr.nativeAd != null) {
             //              return Container(
             //                margin: EdgeInsets.symmetric(horizontal: 5),
             //                decoration: BoxDecoration(
             //                  borderRadius: BorderRadius.circular(10),
             //                  color: Theme.of(context).colorScheme.primary,
             //                  boxShadow: [
             //                    BoxShadow(
             //                      color: Colors.black.withOpacity(0.5),
             //                      blurRadius: 4,
             //                      offset: Offset(0, 4),
             //                    ),
             //                  ],
             //                ),
             //                child: Column(
             //                  crossAxisAlignment: CrossAxisAlignment.start,
             //                  children: [
             //                    Expanded(
             //                      child: ClipRRect(
             //                        borderRadius: BorderRadius.vertical(
             //                          top: Radius.circular(12),
             //                        ),
             //                        child: Container(
             //                          height: 155,
             //                          width: double.infinity,
             //                          child: AdWidget(ad: myContr.nativeAd!),
             //                        ),
             //                      ),
             //                    ),
             //                    Padding(
             //                      padding: EdgeInsets.all(8.0),
             //                      child: Column(
             //                        crossAxisAlignment:
             //                            CrossAxisAlignment.start,
             //                        children: [
             //                          Text(
             //                            "Sponsored Ad",
             //                            style: TextStyle(
             //                              fontWeight: FontWeight.bold,
             //                              fontSize: 16,
             //                            ),
             //                            maxLines: 1,
             //                            overflow: TextOverflow.ellipsis,
             //                          ),
             //                          SizedBox(height: 4),
             //                          Text(
             //                            "This is a sponsored advertisement.",
             //                            style: TextStyle(
             //                                fontSize: 14,
             //                                color: Colors.grey[700],
             //                                fontWeight: FontWeight.bold),
             //                          ),
             //                        ],
             //                      ),
             //                    ),
             //                  ],
             //                ),
             //              );
             //            } else {
             //              return SizedBox(); // Return an empty widget or placeholder
             //            }
             //          });
             //        }
             //
             //        // Handle the actual items
             //        Map thisItem = itemsFromFirestore[actualIndex];
             //        String itemId = documents[actualIndex].id;
             //        List<String> imageUrls =
             //            List<String>.from(thisItem['images']);
             //        return GestureDetector(
             //          onTap: () {
             //            Navigator.push(
             //              context,
             //              MaterialPageRoute(
             //                builder: (context) => DisplayPage(
             //                  imageUrls: imageUrls,
             //                  name: thisItem['Title'],
             //                  price: thisItem['Price'].toString(),
             //                  description: thisItem['Description'],
             //                  userEmail: thisItem['userId'],
             //                ),
             //              ),
             //            );
             //          },
             //          child: ProductContainer(
             //            imageUrls: imageUrls,
             //            thisItem: thisItem,
             //            itemId: itemId,
             //          ),
             //        );
             //      },
             //    );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductContainer extends StatelessWidget {
  const ProductContainer({
    super.key,
    required this.imageUrls,
    required this.thisItem,
    required this.itemId,
  });

  final List<String> imageUrls;
  final Map thisItem;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    var itemProvider = Provider.of<ItemProvider>(context);
    // bool isSaved = itemProvider.savedItems.any((item) => item.id == widget.name);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${thisItem['Title']}",
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
                      "Ksh ${thisItem['Price']}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                        itemProvider.savedItems.any((item) => item.id == itemId)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: itemProvider.savedItems
                                .any((item) => item.id == itemId)
                            ? Colors.red
                            : null,
                      ),
                      onPressed: () {
                        var currentItem = Item(
                          id: itemId,
                          title: thisItem['Title'],
                          imageUrl: imageUrls.first,
                          price: thisItem['Price'].toString(),
                          description: thisItem['Description'],
                          userId: thisItem['userId'],
                        );
                        if (itemProvider.savedItems
                            .any((item) => item.id == itemId)) {
                          itemProvider.removeItem(itemId);
                        } else {
                          itemProvider.addItemToSaved(currentItem);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
