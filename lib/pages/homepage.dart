import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketit/cards/categories.dart';
import 'package:marketit/cards/goodtile.dart';
import 'package:marketit/cards/objectcard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GoodTile> cardList = [
    GoodTile(
        title: 'Macbook pro 2019',
        briefDescription: 'i5/16gb/512gb',
        Price: '40,000',
        imagePath: 'lib/imgs/laptop.jpg'),
    GoodTile(
        title: 'Total Gas',
        briefDescription: 'half full',
        Price: '2000',
        imagePath: 'lib/imgs/gas.jpg'),
    GoodTile(
        title: '3.5x6 Bed',
        briefDescription: 'No screeches',
        Price: '2400',
        imagePath: 'lib/imgs/bed.jpg'),
    GoodTile(
        title: 'Sony Tv',
        briefDescription: '32 inch LED',
        Price: '69,000',
        imagePath: 'lib/imgs/tv.jpg'),
    GoodTile(
        title: 'Home Theatre',
        briefDescription: 'Stereo Speakers',
        Price: '30,000',
        imagePath: 'lib/imgs/speakers.jpg')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Icon(Icons.menu),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Icon(Icons.person),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          ],
        ),
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
                      ProductTile(
                          productName: 'Bed', imagePath: 'lib/imgs/bed.png'),
                      ProductTile(
                          productName: 'Computers',
                          imagePath: 'lib/imgs/laptop.png'),
                      ProductTile(
                          productName: 'Stereos',
                          imagePath: 'lib/imgs/loudspeaker-box.png'),
                      ProductTile(
                          productName: 'Mattress',
                          imagePath: 'lib/imgs/air-mattress.png'),
                      ProductTile(
                          productName: 'Phones',
                          imagePath: 'lib/imgs/mobile-app.png'),
                      ProductTile(
                          productName: 'TVs',
                          imagePath: 'lib/imgs/television.png'),
                      ProductTile(
                          productName: 'Gas Cylinder',
                          imagePath: 'lib/imgs/gas-stove.png'),
                      ProductTile(
                          productName: 'Furniture',
                          imagePath: 'lib/imgs/armchair.png'),
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
                    itemCount: cardList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        mainAxisExtent: 200),
                    itemBuilder: (BuildContext, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, bottom: 5),
                        child: Container(
                         // padding: EdgeInsets.all(5),
                          height: 300,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black54,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.asset(
                                        fit: BoxFit.cover,

                                        alignment: FractionalOffset.center,
                                        cardList[index].imagePath)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                cardList[index].title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                cardList[index].briefDescription,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ksh ' + cardList[index].Price,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  Icon(Icons.favorite_border)
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
