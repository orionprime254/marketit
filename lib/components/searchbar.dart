import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
       // style: TextStyle(color: Colors.white),  // Ensure the text color is visible
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search,
             // color: Colors.white
          ),
          hintText: 'Search...',
        //  hintStyle: TextStyle(color: Colors.white),  // Ensure the hint text color is visible
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),  // Customize the focused border color
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade600),  // Customize the enabled border color
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
