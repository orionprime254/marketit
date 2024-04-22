import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  List goodList = [
    Good(
      title: 'Macbook pro 2019',
      briefDescription: 'i5/16gb/512gb',
      Price: '40,000',
      imagePath: 'lib/imgs/laptop.jpg',
    ),
    Good(
        title: 'Total Gas',
        briefDescription: 'half full',
        Price: '2000',
        imagePath: 'lib/imgs/gas.jpg'),
    Good(
        title: '3.5x6 Bed',
        briefDescription: 'No screeches',
        Price: '2400',
        imagePath: 'lib/imgs/bed.jpg'),
    Good(
        title: 'Sony Tv',
        briefDescription: '32 inch LED',
        Price: '69,000',
        imagePath: 'lib/imgs/tv.jpg'),
    Good(
        title: 'Home Theatre',
        briefDescription: 'Stereo Speakers',
        Price: '30,000',
        imagePath: 'lib/imgs/speakers.jpg')
  ];

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



  @override
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

        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
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
                            MaterialPageRoute(builder: (context) => const BedPage()),
                          );
                        },
                        child: ProductTile(
                          productName: 'Beds',
                          imagePath: 'lib/imgs/bed.png', onTap: () {  },
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
                            imagePath: 'lib/imgs/laptop.png', onTap: () { Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const BedPage())); },),
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
                            imagePath: 'lib/imgs/loudspeaker-box.png', onTap: () { Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const BedPage()) );},),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BedPage()),
                          );
                        },
                        child: ProductTile(
                            productName: 'Mattress',
                            imagePath: 'lib/imgs/air-mattress.png', onTap: () {  },),
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
                            imagePath: 'lib/imgs/mobile-app.png', onTap: () {  },),
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
                            imagePath: 'lib/imgs/television.png', onTap: () {  },),
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
                            imagePath: 'lib/imgs/gas-stove.png', onTap: () {  },),
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
                            imagePath: 'lib/imgs/armchair.png', onTap: () {  },),
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
                    itemCount: goodList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        mainAxisExtent: 200),
                    itemBuilder: (context, index) => GoodTile(
                          good: goodList[index],
                          onTap: () => navigatetoGoodDetails(index),
                        ))
              ],
            ),
          ),
        ));
  }
}
