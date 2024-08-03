import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketit/ads/custom_banner.dart';
import 'package:marketit/ads/custom_rewardads.dart';
import 'package:marketit/pages/btmnavbar.dart';
import 'package:marketit/pages/profilepage.dart';

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
  final CollectionReference _items = FirebaseFirestore.instance.collection('uploads');
  List<File> _selectedImages = [];
  bool _isWhatsappMissing = false;
  String? _whatsappNumber;

  CustomBannerAd customBannerAd = CustomBannerAd();
  CustomRewardAd _rewardAd = CustomRewardAd();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getUserWhatsappNumber();
    _rewardAd.loadRewardedAd();
  }

  Future<void> _getUserWhatsappNumber() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .get();
      setState(() {
        _whatsappNumber = userDoc.data()?['whatsapp'];
        _isWhatsappMissing = _whatsappNumber == null || _whatsappNumber!.isEmpty;
      });
    }
  }

  Future<void> _submitForm() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (_selectedImages.isEmpty ||
        _titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields and upload an image.'),
      ));
      return;
    }

    if (_isWhatsappMissing) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please add your WhatsApp number in your profile page.'),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
      return;
    }

    final String title = _titleController.text;
    final int? price = int.tryParse(_priceController.text);
    final String description = _descriptionController.text;
    final String category = _selectedCategory;
    final String condition = _selectedCondition;
    final String whatsappNumber = _whatsappNumber!;

    if (price != null) {
      List<String> imageUrls = await _uploadImages();

      // Show rewarded ad before saving the form
      if (_rewardAd.isAdLoaded()) {
        _rewardAd.showRewardedAd();
        // Wait until the ad is completed
        // You may want to wait for a result or handle this better in a production app
        await Future.delayed(const Duration(seconds: 3));
      }

      await _items.add({
        "Title": title,
        "Price": price,
        "Description": description,
        "images": imageUrls,
        "userId": user?.email,
        "Condition": condition,
        "Category": category,
        'Likes': [],
        'whatsapp': whatsappNumber,
        'isSaved': false, // Add the isSaved property
      });

      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedImages = [];
        _selectedCategory = 'Bed';
        _selectedCondition = 'New';
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Uploaded Successfully')));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavBar()));
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];

    for (File image in _selectedImages) {
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDireImages = referenceRoot.child('images');
      Reference referenceImagetoUpload = referenceDireImages.child(fileName);

      await referenceImagetoUpload.putFile(image);
      String imageUrl = await referenceImagetoUpload.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sell Item', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isWhatsappMissing) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.red,
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.white),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Please add your WhatsApp number in your profile page.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()),
                            );
                          },
                          child: const Text('Go to Profile',
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                _buildDropdownField('Category', _selectedCategory, (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                }, [
                  'Bed',
                  'Computers & Hardware',
                  'Stereos',
                  'Phones & Accessories',
                  'TV',
                  'Gas',
                  'Furniture',
                  'Clothes',
                  'Services',
                  'Food'
                ]),
                const SizedBox(height: 20),
                _buildCategorySpecificField(),
                const SizedBox(height: 20),
                _buildImagePicker(),
                const SizedBox(height: 20),
                _buildTextField('Title', _titleController),
                const SizedBox(height: 20),
                _buildTextField(
                    'Description (less than 500 words)', _descriptionController,
                    maxLines: 5),
                const SizedBox(height: 20),
                _buildTextField('Price', _priceController,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: const Center(child: Text('Submit', style: TextStyle(fontSize: 18)))),
                  ),
                ),
              ],
            ),
            const CustomBannerAd()
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, String selectedValue, ValueChanged<String?> onChanged, List<String> items) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ..._selectedImages.map((file) => _buildImagePreview(file)).toList(),
            if (_selectedImages.length < 4)
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Icon(Icons.add, size: 50, color: Colors.grey),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview(File file) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
        image: DecorationImage(
          image: FileImage(file),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final List<XFile>? files = await ImagePicker().pickMultiImage();
    if (files != null) {
      setState(() {
        _selectedImages.addAll(files.map((file) => File(file.path)).toList());
        if (_selectedImages.length > 4) {
          _selectedImages = _selectedImages.sublist(0, 4);
        }
      });
    }
  }

  Widget _buildCategorySpecificField() {
    switch (_selectedCategory) {
      case 'Bed':
        return Row(
          children: [
            Expanded(child: _buildDropdownWithNumbers(2, 6)),
            const SizedBox(width: 20),
            Expanded(child: _buildDropdownWithNumbers(5, 7)),
          ],
        );
      case 'Computers & Hardware':
      case 'Phones & Accessories':
        return _buildShortDescriptionField();
      case 'TV':
        return _buildNumberField('Screen size (inches)');
      case 'Food':
        return _buildNumberField('Food in Kg/Pieces');
      case 'Gas':
      case 'Furniture':
        return _buildShortDescriptionField();
      case 'Clothes':
        return _buildSizeField();
      default:
        return Container();
    }
  }

  Widget _buildShortDescriptionField() {
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
  }

  Widget _buildNumberField(String label) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildSizeField() {
    return SizedBox(
      width: double.infinity,
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
  }

  Widget _buildDropdownWithNumbers(int start, int end) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Size'),
      value: start.toString(),
      onChanged: (String? newValue) {
        setState(() {});
      },
      items: List.generate(end - start + 1, (index) {
        final value = (start + index).toString();
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }),
    );
  }
}
