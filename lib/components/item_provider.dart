import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_model.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _savedItems = [];

  List<Item> get savedItems => _savedItems;

  final CollectionReference _itemsCollection = FirebaseFirestore.instance.collection('uploads');
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('Users');

  ItemProvider() {
    _loadSavedItems();
  }

  Future<void> _loadSavedItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await _usersCollection.doc(user.email).get();
      List<dynamic> savedItemIds = userSnapshot['savedItems'] ?? [];

      if (savedItemIds.isNotEmpty) {
        QuerySnapshot itemsSnapshot = await _itemsCollection
            .where(FieldPath.documentId, whereIn: savedItemIds)
            .get();

        _savedItems = itemsSnapshot.docs.map((doc) {
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
  }

  Future<void> addItemToSaved(Item item) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userRef = _usersCollection.doc(user.email);
      await userRef.update({
        'savedItems': FieldValue.arrayUnion([item.id])
      });
      _savedItems.add(item);
      notifyListeners();
    }
  }

  Future<void> removeItem(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userRef = _usersCollection.doc(user.email);
      await userRef.update({
        'savedItems': FieldValue.arrayRemove([id])
      });
      _savedItems.removeWhere((item) => item.id == id);
      notifyListeners();
    }
  }
}
