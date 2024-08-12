import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String productName;
  final String imagePath;

  final void Function()? onTap;

  const ProductTile(
      {super.key,
      required this.productName,
      required this.imagePath,

      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 13.0),
          child: GestureDetector(
            onTap: onTap,
            child: Container(

              height: 80,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(20),
                //boxShadow: [
                // BoxShadow(color: Colors.grey.shade800,blurRadius: 10)
                //]
              ),
              child: Image.asset(imagePath),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),

        Text(
          productName,
          style: TextStyle(
               fontSize: 18,color: Colors.grey[700],
              fontWeight: FontWeight.bold ),
        )
      ],
    );
  }
}
