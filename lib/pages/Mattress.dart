import 'package:flutter/material.dart';
class MattressPage extends StatefulWidget {
  const MattressPage({super.key});

  @override
  State<MattressPage> createState() => _MattressPageState();
}

class _MattressPageState extends State<MattressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Center(child: Text('B E D')),
      ),
    );
  }
}
