import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayPage extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String description;
  final String userEmail; // Added field for userEmail

  const DisplayPage({
    super.key, required this.imageUrl, required this.name, required this.price, required this.description, required this.userEmail,
  });

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
          // Removing the first '0' and adding '+254' prefix
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
                Image.network(
                  widget.imageUrl,
                  height: 400,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    '\Ksh ' + widget.price.toString(),
                    style: TextStyle(
                        color: Colors.grey[100],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    widget.description,
                    style: TextStyle(fontSize: 16),
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
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
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
