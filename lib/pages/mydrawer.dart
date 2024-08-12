import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:marketit/cards/drawer_list_tile.dart';
import 'package:marketit/components/cupertinoswitch.dart';
import 'package:marketit/pages/loginpage.dart';
import 'package:marketit/pages/pending_approve.dart';
import 'package:marketit/pages/savedpage.dart';
import 'package:marketit/pages/sell_page.dart';
import 'package:share/share.dart';

import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatefulWidget {
  //final void Function()? onProfileTap;
  //final void Function()? onSignOut;
  const MyDrawer({
    super.key,
    // required this.onSignOut
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  _launchUrlLinkedIn()async{
     const url = 'https://www.linkedin.com/in/brian-amatalo-727a8721b?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app';
     if (await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
  }
  _launchUrlInstagram()async{
    const url = 'https://www.instagram.com/_amatalo_?igsh=cWV0aXV3a241MmVj';
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // void signUserOut() {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                  child: Icon(
                Icons.person,
                //color: Colors.white,
                size: 65,
              )),
              DrawerListTile(
                icon: Icons.favorite,
                text: 'S A V E D',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavedPage(),
                    ),
                  );
                },
              ),
              DrawerListTile(
                  icon: Icons.add,
                  text: 'S E L L',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SellPage(),
                      ),
                    );
                  }),

              DrawerListTile(
                icon: Icons.access_time_outlined,
                text: "P E N D I N G",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PendingApprovePage(),
                    ),
                  );
                },
              ),
            ],
          ),
          //Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Divider(),
              Text('Follow Me On'),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: _launchUrlInstagram,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Row(
                    children: [
                      Lottie.asset('lib/animations/instagram.json', height: 50),
                      Text('Instagram')
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: _launchUrlLinkedIn,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Lottie.asset('lib/animations/linkedin.json', height: 55),
                      Text('LinkedIn')
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Container(height: 20, child: CupertinoSwitcher()),
                    Text('Light/Dark Mode')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: DrawerListTile(
                    icon: Icons.logout,
                    text: 'L O G O U T',
                    onTap: signUserOut),
              ),
            ],
          )
        ],
      ),
    );
  }
}
