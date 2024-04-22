import 'package:flutter/material.dart';
class GasPage extends StatefulWidget {
  const GasPage({super.key});

  @override
  State<GasPage> createState() => _GasPageState();
}

class _GasPageState extends State<GasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Center(child: Text('G A S')),
      ),
    );
  }
}
