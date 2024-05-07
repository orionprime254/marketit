import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketit/pages/HomePage.dart';
import 'package:marketit/pages/btmnavbar.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  String _selectedCategory = 'Bed';
  String _selectedCondition = 'New';
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  final CollectionReference _items =
  FirebaseFirestore.instance.collection('uploads');
  String imageUrl = '';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('S E L L')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Category'),
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: [
                'Bed',
                'Computers',
                'Stereos',
                'Phones',
                'TV',
                'Gas',
                'Furniture',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Condition'),
              value: _selectedCondition,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCondition = newValue!;
                });
              },
              items: ['New', 'Used'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (file == null) return;
                String fileName = DateTime.now().microsecondsSinceEpoch.toString();
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDireImages = referenceRoot.child('images');
                Reference referenceImagetoUpload = referenceDireImages.child(fileName);
                try {
                  await referenceImagetoUpload.putFile(File(file.path));
                  imageUrl = await referenceImagetoUpload.getDownloadURL();
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to upload image: $error'),
                  ));
                }
              },
              child: Icon(Icons.add),
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (less than 500 words)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 5, // Allow multiple lines
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number, // Allow only numbers
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;

                if (imageUrl.isEmpty || _titleController.text.isEmpty || _descriptionController.text.isEmpty || _priceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill in all fields and upload an image.'),
                  ));
                  return;
                }

                print('Category: $_selectedCategory');
                print('Condition: $_selectedCondition');
                print('Title: ${_titleController.text}');
                print('Description: ${_descriptionController.text}');
                print('Price: ${_priceController.text}');
                final String title = _titleController.text;
                final int? price = int.tryParse(_priceController.text);
                final String description = _descriptionController.text;
                if (title != null) {
                  await _items.add({
                    "Title": title,
                    "Price": price,
                    "Description": description,
                    "image": imageUrl,
                    "userId": user?.uid
                  });
                  _titleController.text = '';
                  _priceController.text = '';
                  _descriptionController.text = '';
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
