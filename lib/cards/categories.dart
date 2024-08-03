import 'package:flutter/material.dart';
 class CategoryCard extends StatelessWidget {
   final String categoryName;
   final color;
   final imagePath;

   const CategoryCard({Key? key, required this.categoryName, this.color, this.imagePath}) : super(key: key);
 
   @override
   Widget build(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.only(left: 20.0),
       child: Container(
         padding: const EdgeInsets.all(20),
         width: 100,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(12),
           color: color,
         ),
         child: Column(
           children: [
             Image.asset(imagePath),
             const SizedBox(
               height: 20,
             ),
             Text(
               categoryName,
               style: TextStyle(fontSize: 20, color: Colors.brown[700]),
             ),
             const SizedBox(
               height: 10,
             ),

           ],
         ),
       ),
     );
   }
 }
 