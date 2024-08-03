import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:marketit/components/item_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/item_model.dart';

class DisplayPage extends StatefulWidget {
  final List<String> imageUrls;
  final String name;
  final String price;
  final String description;
  final String userEmail;


  const DisplayPage({
    Key? key,
    required this.imageUrls,
    required this.name,
    required this.price,
    required this.description,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  Uri? whatsapp;
  Uri? phoneNumber;
  String? whatsappNumber;

  @override
  void initState() {
    super.initState();
    fetchWhatsappNumber();
  }

  Future<void> fetchWhatsappNumber() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userEmail)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      final data = userDoc.data() as Map<String, dynamic>;
      if (data.containsKey("whatsapp")) {
        setState(() {
          whatsappNumber = data["whatsapp"];
          if (whatsappNumber != null && whatsappNumber!.startsWith('0')) {
            whatsappNumber = '+254' + whatsappNumber!.substring(1);
          }
          whatsapp = Uri.parse('https://wa.me/$whatsappNumber');
          phoneNumber = Uri.parse('tel:$whatsappNumber');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var itemProvider = Provider.of<ItemProvider>(context);
    bool isSaved = itemProvider.savedItems.any((item) => item.title == widget.name);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.imageUrls.length > 1
                    ? CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: widget.imageUrls.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
                    : Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls.first,
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     var currentItem = Item(
                    //       //id: widget.itemId, // Use a unique ID
                    //       title: widget.name,
                    //       imageUrl: widget.imageUrls.first,
                    //       price: widget.price,
                    //       description: widget.description,
                    //       userId: widget.userEmail, id: '',
                    //     );
                    //     if (isSaved) {
                    //       itemProvider.removeItem(widget.name);
                    //     } else {
                    //       itemProvider.addItemToSaved(currentItem);
                    //     }
                    //     setState(() {});
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(right: 25.0),
                    //     child: Icon(
                    //       isSaved ? Icons.favorite : Icons.favorite_border,
                    //       color: isSaved ? Colors.red : null,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Ksh ' + widget.price.toString(),
                    style: TextStyle(
                        color: Colors.grey[100],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: (() async {
                      if (phoneNumber != null) {
                        await launchUrl(phoneNumber!);
                      }
                    }),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          whatsappNumber ?? 'Loading...',
                          style: const TextStyle(
                              fontSize: 22,
                              //color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (() async {
                    if (whatsapp != null) {
                      await launchUrl(whatsapp!);
                    }
                  }),
                  child: Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: 60,
                      child: Image.asset('lib/imgs/whatsapp.png', height: 40)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
