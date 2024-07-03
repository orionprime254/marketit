import 'package:flutter/material.dart';
class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
   MyTextBox({super.key, required this.text, required this.sectionName,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.only(left: 15,bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionName,style: TextStyle(color: Colors.grey[400]),),
              IconButton(onPressed: onPressed, icon: Icon(Icons.settings,color: Colors.grey,))
            ],
          ),
          Text(text),

        ],
      ),
    );
  }
}
