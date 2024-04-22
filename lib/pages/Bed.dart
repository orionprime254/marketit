

import 'package:flutter/material.dart';

import '../cards/goods.dart';
import '../cards/goodtile.dart';
import 'displaypage.dart';
class BedPage extends StatefulWidget {
  const BedPage({super.key});

  @override

  State<BedPage> createState() => _BedPageState();
}
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
void navigatetoGoodDetails(BuildContext context,int index) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DisplayPage(
            good: goodList[index],
          )));
}

class _BedPageState extends State<BedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Center(child: Text('B E D')),
      ),
      body: GridView.builder(
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
            onTap: () => navigatetoGoodDetails(context ,index),
          )),
    );
  }
}
