import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketit/ads/custom_banner.dart';
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
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('uploads');
  String? imageUrl;
  bool _isWhatsappMissing = false;
  String? _whatsappNumber;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _getUserWhatsappNumber() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(user.email)
          .get();
      setState(() {
        _whatsappNumber = userDoc.data()?['whatsapp'];
        _isWhatsappMissing =
            _whatsappNumber == null || _whatsappNumber!.isEmpty;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserWhatsappNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sell Item', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isWhatsappMissing) ...[
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.red,
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
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
                                  builder: (context) => ProfilePage()),
                            );
                          },
                          child: Text('Go to Profile',
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
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
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload Image', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                if (imageUrl != null) ...[
                  const SizedBox(height: 20),
                  Image.file(File(imageUrl!)),
                ],
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
                    margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                   decoration: BoxDecoration(
                     color: Colors.orange,
                     borderRadius: BorderRadius.circular(10)
                   ),
                    
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Center(child: Text('Submit', style: TextStyle(fontSize: 18)))),
                  ),
                ),
              ],
            ),
            CustomBannerAd()
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value,
      ValueChanged<String?> onChanged, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      value: value,
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  void _pickImage() async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;

    setState(() {
      imageUrl = file.path;
    });

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
  }

  void _submitForm() async {
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

    if (_isWhatsappMissing) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please add your WhatsApp number in your profile page.'),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
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
      await _items.add({
        "Title": title,
        "Price": price,
        "Description": description,
        "image": imageUrl,
        "userId": user?.email,
        "Condition": condition,
        "Category": category,
        'Likes': [],
        'whatsapp': whatsappNumber,
      });

      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
      setState(() {
        imageUrl = null;
        _selectedCategory = 'Bed';
        _selectedCondition = 'New';
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Uploaded Successfully')));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavBar()));
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
      decoration: InputDecoration(labelText: 'Size'),
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
