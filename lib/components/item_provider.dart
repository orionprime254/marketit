import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'item_model.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _savedItems = [];

  List<Item> get savedItems => _savedItems;

  final CollectionReference _itemsCollection = FirebaseFirestore.instance.collection('uploads');

  ItemProvider() {
    _loadSavedItems();
  }

  Future<void> _loadSavedItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _itemsCollection
          .where('userId', isEqualTo: user.email)
          .where('isSaved', isEqualTo: true)
          .get();
      _savedItems = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Item(
          id: doc.id,
          title: data['Title'],
          imageUrl: data['images'][0],
          price: data['Price'].toString(),
          description: data['Description'],
          userId: data['userId'],
        );
      }).toList();
      notifyListeners();
    }
  }

  Future<void> addItemToSaved(Item item) async {
    var documentRef = _itemsCollection.doc(item.id);
    var docSnapshot = await documentRef.get();

    if (docSnapshot.exists) {
      // Only update the `isSaved` field if the item already exists
      _savedItems.removeWhere((existingItem) => existingItem.id == item.id); // Ensure no duplicate in list
      _savedItems.add(item);
      await documentRef.update({'isSaved': true});
    } else {
      await documentRef.set({
        'Title': item.title,
        'images': [item.imageUrl],
        'Price': item.price,
        'Description': item.description,
        'userId': item.userId,
        'isSaved': true,
      });
      _savedItems.add(item);
    }

    notifyListeners();
  }


  Future<void> removeItem(String id) async {
    var documentRef = _itemsCollection.doc(id);
    var docSnapshot = await documentRef.get();

    if (docSnapshot.exists) {
      _savedItems.removeWhere((item) => item.id == id);
      await documentRef.update({'isSaved': false});
    }

    notifyListeners();
  }
}
