//
//
// import 'package:flutter/material.dart';
// import 'package:marketit/pages/displaypage.dart';
//
// import 'goods.dart';
//
// class GoodTile extends StatelessWidget {
// final Good good;
// //final bool isLiked;
//
//   final void Function()? onTap;
//
//   const GoodTile({
//     Key? key,
//     this.onTap,  required this.good,
//     //required this.isLiked,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return  GestureDetector(
//       onTap: onTap,
//       child: Padding(
//
//         padding: const EdgeInsets.only(left: 5.0, bottom: 5),
//         child: Container(
//           // padding: EdgeInsets.all(5),
//           height: 300,
//           width: 200,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: Colors.black54,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: AspectRatio(
//                     aspectRatio: 16 / 9,
//                     child: Image.network(
//                         fit: BoxFit.cover,
//
//                         alignment: FractionalOffset.center,
//                       "${thisItem['image']}",)),
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0),
//                 child: Text(
//                     "${thisItem['Title']}",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               // Padding(
//               //   padding: const EdgeInsets.only(left: 10.0),
//               //   child: Text(
//               //     good.briefDescription,
//               //     style: TextStyle(color: Colors.grey[700]),
//               //   ),
//               // ),
//               SizedBox(
//                 height: 5,
//               ),
//               Row(
//                 mainAxisAlignment:
//                 MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left:8.0),
//
//                     child: Text(
//                       'Ksh ' + ${thisItem['Price']},
//                       style: TextStyle(fontSize: 13),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 10.0),
//                     child: Icon(
//
//                         Icons.favorite_border),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
