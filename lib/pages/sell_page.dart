import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketit/ads/custom_banner.dart';
import 'package:marketit/ads/custom_rewardads.dart';
import 'package:marketit/components/textbox.dart';
import 'package:marketit/pages/btmnavbar.dart';
import 'package:marketit/pages/pending_approve.dart';
import 'package:marketit/pages/profilepage.dart';
import 'package:marketit/pages/uploadingprogress.dart';

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
  final CollectionReference _pendingitems = FirebaseFirestore.instance.collection('pending_items');
  List<File> _selectedImages = [];
  bool _isWhatsappMissing = false;
  String? _whatsappNumber;
  bool _isUploading = false;
  double _uploadProgress = 0;

  CustomBannerAd customBannerAd = CustomBannerAd();
  CustomRewardAd _rewardAd = CustomRewardAd();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  // Define category-specific hints
  Map<String, String> categoryHints = {
    'Bed': 'e.g. 3.5 by 6, comes with drawer',
    'Computers & Hardware': 'e.g. i5 6th gen, 8GB DDR4, 500GB SSD, 14 inch display',
    'Stereos': 'e.g. 3.1 channel, 3 CD changer',
    "Phone & Accesories":'e.g earphones,chargers,screen protectors for different models',
    'Rentals':'e.g Bedsitter/sngle rooms near galilaya,westgate,pasgat',
    'Tv':'32 inch smart tv,sony brand',
    'Gas':'half full keygas,refill and free delivery',
    'Furniture':'study table,office chair',
    'Clothes':'XL,Tshirt,size 40 shoes',
    'Services':'KRA returns,laundry,bodaboda',
    'Food':''

    // Add more categories as needed
  };

  @override
  void initState() {
    super.initState();
    _getUserWhatsappNumber();
    _rewardAd.loadRewardedAd();
    _requestLocationPermission();
  }
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
    }
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
      setState(() {
        _isUploading = true;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadProgressPage(
            progress: 0,
            errorMessage: null,
            isSuccess: false,
          ),
        ),
      );

      List<String> imageUrls;
      try {
        imageUrls = await _uploadImages(
          onProgress: (progress) {
            setState(() {
              _uploadProgress = progress;
            });
            // Update the progress on the UploadProgressPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UploadProgressPage(
                  progress: _uploadProgress,
                  errorMessage: null,
                  isSuccess: false,
                ),
              ),
            );
          },
        );
      } catch (e) {
        // Handle the error by showing it on the UploadProgressPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UploadProgressPage(
              progress: _uploadProgress,
              errorMessage: e.toString(),
              isSuccess: false,
            ),
          ),
        );
        return;
      }
      // Get the user's location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      String county = placemarks[0].locality ?? 'Unknown';



      await _pendingitems.add({
        "Title": title,
        "Price": price,
        "Description": description,
        "images": imageUrls,
        "userId": user?.email,

        "Category": category,
        'whatsapp': whatsappNumber,
        'isApproved': false,
        'county':county,
      });

      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedImages = [];
        _selectedCategory = 'Bed';

        _isUploading = false;
        _uploadProgress = 0;
      });

      // Update the progress page to show success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UploadProgressPage(
            progress: 1.0,
            errorMessage: null,
            isSuccess: true,
          ),
        ),
      );
    }
  }

  Future<List<String>> _uploadImages({required Function(double) onProgress}) async {
    List<String> imageUrls = [];

    for (int i = 0; i < _selectedImages.length; i++) {
      File image = _selectedImages[i];
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDireImages = referenceRoot.child('images');
      Reference referenceImagetoUpload = referenceDireImages.child(fileName);

      UploadTask uploadTask = referenceImagetoUpload.putFile(image);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble()) * (i + 1) / _selectedImages.length;
        onProgress(progress);
      });

      await uploadTask.whenComplete(() async {
        String imageUrl = await referenceImagetoUpload.getDownloadURL();
        imageUrls.add(imageUrl);
      });
    }

    return imageUrls;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                            'Please add your correct WhatsApp number in your profile page for easy contact.',textAlign: TextAlign.center,
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
                  'Rentals',
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
                Text('Pick 4 images'),
                SizedBox(height: 10,),
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
                //MyTextBox(text:  user?['whatsapp'] ?? '', sectionName:  'Whatsapp Phone Number', onPressed: (){}),
                const SizedBox(height: 20),
                _isUploading
                    ? Column(
                  children: [
                    //LinearProgressIndicator(value: _uploadProgress),
                    const SizedBox(height: 20),
                  ],
                )
                    : GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: const Center(
                            child: Text('Submit', style: TextStyle(fontSize: 18)))),
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
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () => _removeImage(file),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.cancel, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  void _removeImage(File file) {
    setState(() {
      _selectedImages.remove(file);
    });
  }


  // Widget _buildImagePreview(File file) {
  //   return Container(
  //     width: 100,
  //     height: 100,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       border: Border.all(color: Colors.grey),
  //       image: DecorationImage(
  //         image: FileImage(file),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   );
  // }

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

          ],
        );
      case 'Computers & Hardware':
      case 'Phones & Accessories':
        return Container();
      case 'TV':
        return Container();
      case 'Food':
        return Container();
      case 'Gas':
      case 'Furniture':
        return Container();
      case 'Clothes':
        return Container();
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
