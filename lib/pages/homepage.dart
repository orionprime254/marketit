import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketit/cards/categories.dart';
import 'package:marketit/cards/goods.dart';
import 'package:marketit/cards/goodtile.dart';
import 'package:marketit/cards/objectcard.dart';
import 'package:marketit/pages/Bed.dart';
import 'package:marketit/pages/TVs.dart';
import 'package:marketit/pages/displaypage.dart';
import 'package:marketit/pages/messagespage.dart';
import 'package:marketit/pages/notificationspage.dart';
import 'package:marketit/pages/profilepage.dart';
import 'package:marketit/pages/savedpage.dart';
import 'package:marketit/pages/sell_page.dart';

import 'Computers.dart';
import 'Furniture.dart';
import 'Gas.dart';
import 'Phones.dart';
import 'Stereo.dart';
import 'mydrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('uploads');
  String imageUrl = '';

  void navigatetoGoodDetails(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayPage(
                  good: goodList[index],
                )));
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stream = FirebaseFirestore.instance.collection('uploads').snapshots();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading: Icon(Icons.menu),
        // actions: [
        //   Padding(
        //    padding: const EdgeInsets.only(right: 25.0),
        //     child: Icon(Icons.person),
        //   )
        //],
      ),
      drawer: MyDrawer(onProfileTap: goToProfilePage),
      body: StreamBuilder<QuerySnapshot>(
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
            }
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            List<Map> itemsFromFirestore =
                documents.map((e) => e.data() as Map).toList();
            return SingleChildScrollView(
              child: Column(children: [
                //find what's being sold
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Find Your New Property',
                    style: TextStyle(
                      fontSize: 36,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                //search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: '  Search...',
                        focusedBorder: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade600))),
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
                                    builder: (context) => const BedPage()));
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
                                builder: (context) => const BedPage()),
                          );
                        },
                        child: ProductTile(
                          productName: 'Mattress',
                          imagePath: 'lib/imgs/air-mattress.png',
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
                Padding(
                  padding: const EdgeInsets.only(right: 225.0),
                  child: Text(
                    'For You :p',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: itemsFromFirestore.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 200,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = itemsFromFirestore[index];
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 300,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black54),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  "${thisItem['image']}",
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "${thisItem['Title']}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Ksh ${thisItem['Price']}",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.favorite_border),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ]),
            );
          }),
    );
  }
}
