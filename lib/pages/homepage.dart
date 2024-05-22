import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketit/pages/profilepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cards/objectcard.dart';
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
  List<String> wishlist = [];

  void toggleWishlist(String itemId) {
    setState(() {
      if (wishlist.contains(itemId)) {
        wishlist.remove(itemId);
      } else {
        wishlist.add(itemId);
      }
    });
    saveWishlist();
  }

  void loadWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      wishlist = prefs.getStringList('wishlist') ?? [];
    });
  }

  void saveWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('wishlist', wishlist);
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    loadWishlist();
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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: MyDrawer(onProfileTap: goToProfilePage),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Find Your New Property COMRADE!',
                style: GoogleFonts.bebasNeue(
                  fontSize: 50,
                ),
              ),
            ),
            SizedBox(height: 25),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: SearchBar(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            ),
                  SizedBox(
                    height: 25,
                  ),
                  //list  of product tiles
                  Padding(
                    padding: const EdgeInsets.only(right: 225.0),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TvPage()),
                            );
                          },
                          child: ProductTile(
                            productName: 'TVs',
                            imagePath: 'lib/imgs/television.png',
                            onTap: () {},
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
            // Categories and other UI elements...
            Padding(
              padding: const EdgeInsets.only(right: 225.0),
              child: Text(
                'For You :p',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            SizedBox(height: 6),
            Container(
              height: 500,
              child: StreamBuilder<QuerySnapshot>(
                stream: _performSearch(_searchQuery),
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
                  List<Map> itemsFromFirestore =
                  documents.map((e) => e.data() as Map).toList();

                  return GridView.builder(
                    itemCount: itemsFromFirestore.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
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
                                  height: 190,
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
                                      maxLines: 2,
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
            ),
          ],
        ),
      ),
    );
  }
}
