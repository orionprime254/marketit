import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketit/ads/custom_banner.dart';
import 'package:marketit/components/likebutton.dart';
import 'package:marketit/pages/profilepage.dart';
import 'package:marketit/pages/savedpage.dart';
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
  bool isLiked = false;

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

  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });
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

  void goToLikesPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SavedPage(wishlist: wishlist)));
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 2,
        centerTitle:true,
        title: Text('M A R K E T I T'),
      ),
      //drawer: MyDrawer(onProfileTap: goToProfilePage),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                CustomBannerAd(),
                SizedBox(height: 10),
                SizedBox(height: 25),
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
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(right: 225.0),
                  child: Text(
                    'categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //color: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BedPage()),
                      );
                    },
                    child: ProductTile(
                      color: Color(0xFFE4F3EA),
                      productName: 'Beds',
                      imagePath: 'lib/imgs/bed.png',
                      onTap: () {},
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ComputersPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Computers',
                      imagePath: 'lib/imgs/laptop.png',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ComputersPage()));
                      }, color: Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StereoPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Stereos',
                      imagePath: 'lib/imgs/loudspeaker-box.png',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BedPage()));
                      }, color: Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ServicesPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Services',
                      imagePath: 'lib/imgs/air-mattress.png',
                      onTap: () {}, color: Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FoodPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Food',
                      imagePath: 'lib/imgs/dinner.png',
                      onTap: () {}, color: Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PhonesPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Phones',
                      imagePath: 'lib/imgs/mobile-app.png',
                      onTap: () {}, color: Color(0xFFFFECE8),
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
                      onTap: () {}, color: Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GasPage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Gas Cylinder',
                      imagePath: 'lib/imgs/gas-stove.png',
                      onTap: () {}, color: Color(0xFFFFECE8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FurniturePage()),
                      );
                    },
                    child: ProductTile(
                      productName: 'Furniture',
                      imagePath: 'lib/imgs/armchair.png',
                      onTap: () {}, color: Color(0xFFFFECE8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 225.0),
                  child: Text(
                    'For you :p',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //color: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(height: 6),
              ],
            ),
          ),

          SliverFillRemaining(
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
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    //crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
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
                              userEmail: thisItem['userId'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Theme.of(context).colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(

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
                                  height: 180,
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
                                        //color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Ksh ${thisItem['Price']}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
