import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String text;
final  void Function()? onTap;
  const DrawerListTile({super.key, required this.icon, required this.text,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        leading: Icon(icon,),
        onTap: onTap,
        title: Text(text,),
      ),
    );
  }
}
