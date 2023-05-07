import 'package:flutter/material.dart';

class GoodTile extends StatelessWidget {
  final String title;
  final String briefDescription;
  final  String Price;
  final String imagePath;
  const GoodTile({Key? key, required this.title, required this.briefDescription, required this.Price, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List <GoodTile> cardList = [
      GoodTile(title: 'Macbook pro 2019', briefDescription: 'i5/16gb/512gb', Price: '40,000', imagePath: 'lib/imgs/laptop.jpg'),
      GoodTile(title: 'Total Gas', briefDescription: 'half full', Price: '2000', imagePath: 'lib/imgs/gas.jpg'),
     GoodTile(title: '3.5x6 Bed', briefDescription: 'No screeches', Price: '2400', imagePath: 'lib/imgs/bed.jpg'),
     GoodTile(title: 'Sony Tv', briefDescription: '32 inch LED', Price: '69,000', imagePath: 'lib/imgs/tv.jpg'),
     GoodTile(title: 'Home Theatre', briefDescription: 'Stereo Speakers', Price: '30,000', imagePath: 'lib/imgs/speakers.jpg')
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 5.0, bottom: 5),
      child: Container(
        padding: EdgeInsets.all(6),
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
                child: Image.asset(imagePath)),
            SizedBox(height: 3,),
            Text(title,style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 4,),
            Text(briefDescription,style: TextStyle(color: Colors.grey[700]),),
            SizedBox(height: 15,),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ksh '+ Price,style: TextStyle(fontSize: 13),),
                Icon(Icons.favorite_border)
              ],
            )
            

          ],
        ),
      ),
    );
  }
}
