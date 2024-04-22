import 'package:flutter/material.dart';
import 'package:marketit/cards/goodtile.dart';

import '../cards/goods.dart';

class DisplayPage extends StatefulWidget {
  final Good good;

  const DisplayPage({
    super.key,
    required this.good,
    //required this.goodTile
  });

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
              child: ListView(
            children: [
              Image.asset(
                widget.good.imagePath,
                height: 400,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      widget.good.title,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Icon(Icons.favorite_border),
                  )
                ],
              ),
              // SizedBox(
              //   height: 10,
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  '\Ksh ' + widget.good.Price,
                  style: TextStyle(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.w400,
                      fontSize: 25),
                ),
              ),
              //  SizedBox(
              //    height: 20,
              //  ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(widget.good.briefDescription),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  'Lorem ipsum dolor sit amet. Ad obcaecati quia est sint odio qui quaerat dolorum. Vel maiores sunt sit neque ipsam et sunt reprehenderit ea corporis sunt nam ullam eveniet est vitae doloremque. Sit fuga animi non inventore voluptate cum quasi doloribus et dolore ipsa. Est reprehenderit animi sed quod minus quo consequatur molestiae aut ducimus quae qui atque quidem est doloremque pariatur.',
                  style: TextStyle(height: 2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  //height: 75,

                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text('0793997999',style: TextStyle(
                    fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold

                      ),),
                    ),
                  ),
                ),
              )
              //     SizedBox(
              //      height: 10,
              //    ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Container(
              //         color: Colors.red,
              //         padding: const EdgeInsets.all(25),
              //         child: Column(
              //           children: [
              //             Row(
              //               children: [
              //                 Text(
              //                   '\$' + widget.good.Price,
              //                   style: TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 10,
              //                       fontWeight: FontWeight.bold),
              //                 ),
              //               ],
              //             )
              //           ],
              //         ),
              //       ),
              //     )
            ],
          ))
        ],
      ),
    );
  }
}
