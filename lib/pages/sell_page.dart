import 'package:flutter/material.dart';
class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  String _selectedCategory = 'Bed';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('S E L L')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white30,
                    borderRadius: BorderRadius.circular(20),

            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: DropdownButton(value: _selectedCategory,
              icon: Icon(Icons.arrow_drop_down),
              isExpanded: true,
              iconSize: 24,
                elevation: 16,

                //style: TextStyle(color: Colors.blue),
                underline: SizedBox(),
                onChanged: (String? newValue){
                setState(() {
                  _selectedCategory = newValue!;
                });
                },
                items: [
                  'Bed',
                  'Computers',
                  'Stereos',
                  'Phones',
                  'TV',
                  'Gas',
                  'Furniture',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
