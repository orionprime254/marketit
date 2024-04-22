import 'package:flutter/material.dart';
import 'package:marketit/cards/drawer_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
 // final void Function()? onSignOut;
  const MyDrawer({super.key, required this.onProfileTap,
    //required this.onSignOut
  });

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
                icon: Icons.person,
                text: 'P R O F I L E',
                onTap: onProfileTap,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: DrawerListTile(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
