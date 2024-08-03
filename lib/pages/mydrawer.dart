import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketit/cards/drawer_list_tile.dart';
import 'package:marketit/components/cupertinoswitch.dart';

class MyDrawer extends StatelessWidget {
  //final void Function()? onProfileTap;
  //final void Function()? onSignOut;
  const MyDrawer({super.key,
   // required this.onSignOut
  });
  void signUserOut(){
    FirebaseAuth.instance.signOut();

  }

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
              DrawerListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),
              DrawerListTile(
                icon: Icons.add,
                text: 'S E L L',
                onTap: (){}
              ),
            ],
          ),
         Column(
           children: [
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 25.0),
               child: Row(
                 children: [
                   CupertinoSwitcher(),
                   Text('Light/Dark Mode')
                 ],
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(bottom: 25.0),
               child: DrawerListTile(

                   icon: Icons.logout,
                   text: 'L O G O U T',
                   onTap: signUserOut
               ),
             ),
           ],
         )

        ],
      ),
    );
  }
}
