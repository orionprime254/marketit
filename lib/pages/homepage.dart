import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marketit/ads/custom_banner.dart';
import 'package:marketit/ads/openad.dart';
import 'package:marketit/pages/profilepage.dart';
import 'package:marketit/pages/rental_house.dart';
import 'package:marketit/pages/savedpage.dart';
import 'package:provider/provider.dart';
import '../ads/nativead.dart';
import '../cards/objectcard.dart';
import '../components/cupertinoswitch.dart';
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
import 'mydrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool isLiked = false;
  var myContr = Get.put(NativeController());
  late Stream<QuerySnapshot> _stream;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
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

  @override
  void initState() {
    super.initState();
    myContr.loadAd();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance!.addObserver(this);
    _stream = FirebaseFirestore.instance.collection('uploads').snapshots();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Stream<QuerySnapshot> _performSearch(String query) {
    if (query.isEmpty) {
      return FirebaseFirestore.instance.collection('uploads').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('uploads')
          .where('Title', isGreaterThanOrEqualTo: query)
          .where('Title', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
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
            StreamBuilder<QuerySnapshot>(
              stream: _performSearch(_searchQuery),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Some error occurred ${snapshot.error}"),
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

                return GridView.builder(
                  itemCount: itemsFromFirestore.length +
                      (itemsFromFirestore.length ~/ 5),
                  // Adjust the item count
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    // Determine the actual index for items
                    int actualIndex = index - (index ~/ 5);

                    // Display the ad every 5th item
                    if (index % 5 == 4) {
                      return Obx(() {
                        if (myContr.isAdLoaded.value &&
                            myContr.nativeAd != null) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.primary,
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
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Container(
                                      height: 155,
                                      width: double.infinity,
                                      child: AdWidget(ad: myContr.nativeAd!),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sponsored Ad",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "This is a sponsored advertisement.",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox(); // Return an empty widget or placeholder
                        }
                      });
                    }

                    // Handle the actual items
                    Map thisItem = itemsFromFirestore[actualIndex];
                    String itemId = documents[actualIndex].id;
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
                        itemId: itemId,
                      ),
                    );
                  },
                );
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
