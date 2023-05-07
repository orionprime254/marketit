import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String productName;
  final String imagePath;
  final color;
  const ProductTile({super.key, required this.productName, required this.imagePath, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Container(
            height: 80,
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
              //boxShadow: [
              // BoxShadow(color: Colors.grey.shade800,blurRadius: 10)
              //]
            ),
            child: Image.asset(imagePath),
          ),
        ),
        SizedBox(height: 5,),
        Text(productName,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),)
      ],
    );
  }
}
