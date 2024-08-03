import 'package:flutter/material.dart';
class DeleteButton extends StatelessWidget {
  final void Function()? onTap;

  const DeleteButton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: GestureDetector(
        onTap: onTap,
        child: const Icon(Icons.delete,
          //color: Theme.of(context).colorScheme.tertiary,
        ),

      ),
    );
  }
}
