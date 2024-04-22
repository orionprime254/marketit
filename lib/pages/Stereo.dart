import 'package:flutter/material.dart';
class StereoPage extends StatefulWidget {
  const StereoPage({super.key});

  @override
  State<StereoPage> createState() => _StereoPageState();
}

class _StereoPageState extends State<StereoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Center(child: Text('S T E R E O')),
      ),
    );
  }
}
