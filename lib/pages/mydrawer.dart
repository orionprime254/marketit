import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marketit/cards/drawer_list_tile.dart';
import 'package:marketit/components/cupertinoswitch.dart';
import 'package:marketit/pages/loginpage.dart';
import 'package:marketit/pages/pending_approve.dart';
import 'package:marketit/pages/sell_page.dart';

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
                color: Colors.white,
                size: 65,
              )),
              // DrawerListTile(
              //   icon: Icons.home,
              //   text: 'H O M E',
              //   onTap: () => Navigator.pop(context),
              // ),
              DrawerListTile(icon: Icons.add, text: 'S E L L', onTap: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SellPage(),
                ),
              );}),
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
              )
            ],
          ),
          Column(
            children: [
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
