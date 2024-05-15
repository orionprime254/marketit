import 'package:flutter/material.dart';
class SavedPage extends StatelessWidget {
  final List<String> wishlist;
  const SavedPage({Key? key, required this.wishlist}) : super(key: key);

 // List<Map> wishListItems= [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('S A V E D')),
      ),
      body: ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          // Here you can display details of each item in the wishlist
          return ListTile(
              leading: Image.network(
             // thisItem['image'],
                '',
              width: 50, // Adjust the width as needed
              height: 50, // Adjust the height as needed
              fit: BoxFit.cover,), // Adjust the fit as needed
            title: Text(wishlist[index]), // Replace with actual item details
          );
        },
      ),

    );
  }
}
