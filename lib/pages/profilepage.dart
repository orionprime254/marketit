import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('P R O F I L E')),
      ),
      body: ListView(
        children: [
          SizedBox(height: 40,),
          Icon(Icons.person,size: 80,),
          SizedBox(height: 40,),
          Text('Nemesis Prime',textAlign: TextAlign.center,),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text('My Details'),
          )
        ],
      ),
    );
  }
}
