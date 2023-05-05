import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black54,
        ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'lib/imgs/bed.png',
                  height: 67,
                  fit: BoxFit.fill,
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              'Bed',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
        width: 110,
      ),
    );
  }
}
