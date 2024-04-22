import 'package:flutter/material.dart';
class PhonesPage extends StatefulWidget {
  const PhonesPage({super.key});

  @override
  State<PhonesPage> createState() => _PhonesPageState();
}

class _PhonesPageState extends State<PhonesPage> {
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
