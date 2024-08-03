import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketit/ads/custom_banner.dart';
import 'package:marketit/components/deletebutton.dart';
import 'package:marketit/components/textbox.dart';
import 'package:marketit/pages/loginpage.dart';
import 'package:marketit/pages/mydrawer.dart';
import 'package:marketit/pages/settingspage.dart';
import 'displaypage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit $field',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          keyboardType:
          field == 'whatsapp' ? TextInputType.number : TextInputType.text,
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(newValue);
              if (newValue.trim().isNotEmpty) {
                if (field == 'whatsapp') {
                  // Validate the phone number input
                  if (RegExp(r'^\d+$').hasMatch(newValue)) {
                    newValue = '+254' + newValue.substring(1);
                    await usersCollection
                        .doc(currentUser?.email)
                        .update({field: newValue});
                  } else {
                    // Show an error message if the input is not valid
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a valid phone number')),
                    );
                  }
                } else {
                  await usersCollection
                      .doc(currentUser?.email)
                      .update({field: newValue});
                }
                // Refresh user details after update
                setState(() {});
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    if (currentUser == null) {
      throw Exception("User is not logged in");
    }
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void deletePost(String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('uploads')
                  .doc(postId)
                  .delete();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('P R O F I L E')),
        actions: [
          // ElevatedButton.icon(
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => SettingsPage()));
          //   },
          //   icon: const Icon(
          //     Icons.settings,
          //     color: Colors.orange,
          //   ),
          //   label: const Text('settings'),
          // )
          // ElevatedButton.icon(
          //   onPressed: signUserOut,
          //   icon: const Icon(
          //     Icons.logout,
          //     color: Colors.orange,
          //   ),
          //   label: const Text(
          //     "logout",
          //     style: TextStyle(color: Colors.teal),
          //   ),
          // ),
        ],
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: getUserDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  Map<String, dynamic>? user = snapshot.data!.data();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser!.email!, // Check for nullability
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            MyTextBox(
                              text: user?["username"] ?? '',
                              sectionName: 'username',
                              onPressed: () => editField('username'),
                            ),
                            const SizedBox(height: 10),
                            MyTextBox(
                              text: user?['whatsapp'] ?? '',
                              sectionName: 'Whatsapp Phone Number',
                              onPressed: () => editField('whatsapp'),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("uploads")
                            .where("userId", isEqualTo: currentUser!.email)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                mainAxisExtent: 200,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                Map<String, dynamic> item =
                                snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                                String postId = snapshot.data!.docs[index].id;
                                List<String> imageUrls = item['images'] != null
                                    ? List<String>.from(item['images'])
                                    : [];
                                String firstImage = imageUrls.isNotEmpty
                                    ? imageUrls.first
                                    : 'https://via.placeholder.com/150';
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DisplayPage(
                                          imageUrls: imageUrls,
                                          name: item['Title'] ?? 'No Title',
                                          price: item['Price']?.toString() ??
                                              'No Price',
                                          description:
                                          item['Description'] ?? 'No Description',
                                          userEmail: item['userId'] ?? '',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          firstImage,
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['Title'] ?? 'No Title',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                  'Ksh  ${item['Price'] ?? 'No Price'}'),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  DeleteButton(
                                                    onTap: () =>
                                                        deletePost(postId),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  );
                } else {
                  return const Text('No Data');
                }
              },
            ),
            //Spacer(),
            // CustomBannerAd()
          ],
        ),
      ),
    );
  }
}
