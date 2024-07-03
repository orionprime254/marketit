import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketit/components/textbox.dart';
import 'package:marketit/pages/loginpage.dart';
import '../cards/goods.dart';
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
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: TextStyle(color: Colors.grey)),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () => Navigator.of(context).pop(newValue),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
//update in firestore
    if (newValue.trim().length > 0) {
      if (field == 'whatsapp') {
        newValue = '+254' + newValue.substring(1);
      }
      await usersCollection.doc(currentUser?.email).update({field: newValue});
    }
  }

//current logged in as user
  final User? currentUser = FirebaseAuth.instance.currentUser;

//future to fetch details
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
    Navigator.push(context,MaterialPageRoute(
        builder: (context) => const LoginPage()), );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('P R O F I L E')),
        actions: [
          ElevatedButton.icon(
              onPressed: signUserOut,
              icon: Icon(
                Icons.logout,
                color: Colors.orange,
              ),
              label: Text(
                "logout",
                style: TextStyle(color: Colors.orange),
              )),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: [
//     Container(
//       height: 100,
//       width: 100,
//       decoration: BoxDecoration(
//         color: Colors.grey[400],
//         shape: BoxShape.circle,
//       ),
//     ),
//     Column(
//       children: [
//         Text(
//           '10', // Placeholder value for the number of posts
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         Text('Posts'),
//       ],
//     )
//   ],
// ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser!.email!, // Check for nullability
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        MyTextBox(
                          text: user?["username"] ?? '',
                          sectionName: 'username',
                          onPressed: () => editField('username'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyTextBox(
                          text: user?['bio'] ?? '',
                          sectionName: 'bio',
                          onPressed: () => editField('bio'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyTextBox(
                          text: user?['whatsapp'] ?? '',
                          sectionName: ' Whatsapp Phone Number',
                          onPressed: () => editField('whatsapp'),
                        ),
                      ],
                    ),
                  ),
// Display uploaded items by the current user
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("uploads")
                        .where("userId", isEqualTo: currentUser!.email)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            mainAxisExtent: 200,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> item =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      item['image'],
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
                                            item['Title'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
//Text(item['Description']),
                                          Text('Ksh  ${item['Price']}'),
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
              ),
            );
          } else {
            return Text('No Data');
          }
        },
      ),
    );
  }
}
