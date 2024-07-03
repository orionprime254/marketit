

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketit/pages/HomePage.dart';
import 'package:marketit/pages/btmnavbar.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  var  locationMessage = "";
  String _selectedCategory = 'Bed';
  String _selectedCondition = 'New';
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  final CollectionReference _items =
  FirebaseFirestore.instance.collection('uploads');
  String? imageUrl;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    
    super.dispose();
  }
  // void getCurrentLocation()async{
  //   var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   var lastPosition = await Geolocator.getLastKnownPosition();
  //   print(lastPosition);
  //   List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark place = placemarks[0];
  //   String address = "${place.street}, ${place.locality}";
  //
  //   setState(() {
  //     locationMessage = address;
  //   });
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title: Text('S E L L'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Category'),
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: [
                'Bed',
                'Computers&Hardware',
                'Stereos',
                'Phones&Accessories',
                'TV',
                'Gas',
                'Furniture',
                'Clothes',
                'Services',
                'Food'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20,),
            _buildCategorySpecificField(),
           // const SizedBox(height: 20),
            // DropdownButtonFormField<String>(
            //   decoration: const InputDecoration(labelText: 'Condition'),
            //   value: _selectedCondition,
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       _selectedCondition = newValue!;
            //     });
            //   },
            //   items: ['New', 'Used'].map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final XFile? file =
                await ImagePicker().pickImage(source: ImageSource.gallery);
                if (file == null) return;

                // Display the selected image
                setState(() {
                  imageUrl = file.path;
                });

                // Upload the image to Firebase Storage
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(width: 40,child: Icon(Icons.add)),
              ),
            ),
            // Show the preview of the selected image
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.file(File(imageUrl!)),
              ),
            SizedBox(height: 20,),
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
            // Row(
            //   children: [
            //     Expanded(child: Text(locationMessage)),
            //     GestureDetector(onTap:(){getCurrentLocation();},child: Image.asset('lib/imgs/google-maps (1).png',height: 30,)),
            //   ],
            // ),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;

                if (imageUrl == null ||
                    _titleController.text.isEmpty ||
                    _descriptionController.text.isEmpty ||
                    _priceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill in all fields and upload an image.'),
                  ));
                  return;
                }
                final String title = _titleController.text;
                final int? price = int.tryParse(_priceController.text);
                final String description = _descriptionController.text;
                final String category = _selectedCategory;
                final String condition = _selectedCondition;
                if (title != null) {
                  await _items.add({
                    "Title": title,
                    "Price": price,
                    "Description": description,
                    "image": imageUrl,
                    "userId": user?.email,
                    "Condition": condition,
                    "Category":category,
                    'Likes': [],
                   // "Location":locationMessage
                  });
                  _titleController.text = '';
                  _priceController.text = '';
                  _descriptionController.text = '';
                  setState(() {
                    imageUrl = null;
                    _selectedCategory = 'Bed';
                    _selectedCondition = 'New';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded Successfully :p')));
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => BottomNavBar()));
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCategorySpecificField(){
    switch (_selectedCategory){
      case 'Bed':
        return Row(
          children: [
            Expanded(child: _buildDropdownWithNumbers(2,6)),
            const SizedBox(width: 20,),
            Expanded(child: _buildDropdownWithNumbers(5,7))
          ],
        );
      case 'Computers&Hardware':
      case 'Phones&Accessories':
        return SizedBox(
          width: double.infinity,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Short description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLength: 20,
          ),
        );
      case 'TV':
        return SizedBox(
          width: double.infinity,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Screen size (inches)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        );
      case 'Food':
        return SizedBox(
          width: double.infinity,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Food in Kg/Pieces',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        );
      case 'Gas':
      case 'Furniture':
        return SizedBox(
          width: double.infinity,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Description (less than 20 characters)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLength: 20,
          ),
        );
      case 'Clothes':
        return SizedBox(width: double.infinity,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Size',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'e.g. S, M, L, XL',
            ),
          ),
        );
      default:
        return Container(); // Default case, no specific field needed
    }
    }
  Widget _buildDropdownWithNumbers(int start, int end) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Size'),
      value: start.toString(),
      onChanged: (String? newValue) {
        setState(() {
          // Handle dropdown value change
        });
      },
      items: List.generate(
        end - start + 1,
            (index) => DropdownMenuItem<String>(
          value: (start + index).toString(),
          child: Text((start + index).toString()),
        ),
      ),
    );
  }
  }

