import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'item_model.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _allItems = [];
  List<Item> _savedItems = [];
  List<Item> _filteredItems = [];

  List<Item> get savedItems => _savedItems;
  List<Item> get filteredItems => _filteredItems;

  final CollectionReference _itemsCollection = FirebaseFirestore.instance.collection('uploads');

  double? _minPrice;
  double? _maxPrice;

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

  void setItems(List<Item> items) {
    _allItems = items;
    _applyFilters();
  }

  void setPriceFilter(double minPrice, double maxPrice) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredItems = _allItems.where((item) {
      double price = double.tryParse(item.price) ?? 0;
      bool matchesPrice = (_minPrice == null || price >= _minPrice!) && (_maxPrice == null || price <= _maxPrice!);
      return matchesPrice;
    }).toList();
    notifyListeners();
  }

  Future<void> addItemToSaved(Item item) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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
          'userId': user.email, // Set the userId to the current user's email
          'isSaved': true,
        });
        _savedItems.add(item);
      }

      notifyListeners();
    }
  }

  Future<void> removeItem(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var documentRef = _itemsCollection.doc(id);
      var docSnapshot = await documentRef.get();

      if (docSnapshot.exists) {
        _savedItems.removeWhere((item) => item.id == id);
        await documentRef.update({'isSaved': false});
      }

      notifyListeners();
    }
  }
}
