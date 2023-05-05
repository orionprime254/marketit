import 'package:flutter/material.dart';
import 'package:marketit/cards/objectcard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        body: Column(
          children: [
            //find what's being sold
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Find Your New Property',
                style: TextStyle(fontSize: 36),
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
                        borderSide: BorderSide(color: Colors.grey.shade600))),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            //list  of product tiles
            Padding(
              padding: const EdgeInsets.only(right: 255.0),
              child: Text(
                'For You :p',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductTile(),
                    ProductTile(),
                    ProductTile(),
                    ProductTile(),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
