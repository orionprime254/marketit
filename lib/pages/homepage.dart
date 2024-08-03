import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketit/ads/custom_banner.dart';
import 'package:marketit/pages/profilepage.dart';
import 'package:marketit/pages/savedpage.dart';
import 'package:provider/provider.dart';
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

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool isLiked = false;

  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
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
        leading: CupertinoSwitcher(),
        elevation: 2,
        centerTitle: true,
        title: const Text('M A R K E T I T'),
      ),
      //drawer: MyDrawer(onProfileTap: goToProfilePage),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomBannerAd(),
            const SizedBox(height: 10),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SearchBar(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.only(right: 225.0),
              child: Text(
                'categories',
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BedPage()),
                      );
                    },
                    child: ProductTile(
                      color: const Color(0xFFE4F3EA),
                      productName: 'Beds',
                      imagePath: 'lib/imgs/bed.png',
                      onTap: () {},
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ComputersPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Computers',
                      imagePath: 'lib/imgs/laptop.png',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ComputersPage()));
                      },
                      color: const Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StereoPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Stereos',
                      imagePath: 'lib/imgs/loudspeaker-box.png',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BedPage()));
                      },
                      color: const Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ServicesPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Services',
                      imagePath: 'lib/imgs/air-mattress.png',
                      onTap: () {},
                      color: const Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FoodPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Food',
                      imagePath: 'lib/imgs/dinner.png',
                      onTap: () {},
                      color: const Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PhonesPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Phones',
                      imagePath: 'lib/imgs/mobile-app.png',
                      onTap: () {},
                      color: const Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TvPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'TVs',
                      imagePath: 'lib/imgs/television.png',
                      onTap: () {},
                      color: const Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GasPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Gas Cylinder',
                      imagePath: 'lib/imgs/gas-stove.png',
                      onTap: () {},
                      color: const Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FurniturePage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Furniture',
                      imagePath: 'lib/imgs/armchair.png',
                      onTap: () {},
                      color: const Color(0xFFFFECE8),
                    ),
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
