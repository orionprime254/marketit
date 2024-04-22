import 'package:flutter/material.dart';
class ComputersPage extends StatefulWidget {
  const ComputersPage({super.key});

  @override
  State<ComputersPage> createState() => _BedPageState();
}

class _BedPageState extends State<ComputersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Center(child: Text('C O M P U T E R S')),
      ),
    );
  }
}
