

import 'package:flutter/material.dart';

import '../cards/goods.dart';
import '../cards/goodtile.dart';
import 'displaypage.dart';
class BedPage extends StatefulWidget {
  const BedPage({super.key});

  @override

  State<BedPage> createState() => _BedPageState();
}


class _BedPageState extends State<BedPage> {
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
