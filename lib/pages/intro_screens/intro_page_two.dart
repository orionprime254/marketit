import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPageTwo extends StatelessWidget {
  const IntroPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // color: Theme.of(context).colorScheme.background,
      //  child: Column(
      //    children: [
      //      Container(height: 600,child: Lottie.asset('lib/animations/app animation.json'))
      //    ],
      //  ),
      children: [
        Lottie.asset('lib/animations/buying.json',
            height: 350, fit: BoxFit.fill),
        const Text(
          'A Large Online Market',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
        ),
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'No more selling in multiple different apps and groups browse and get what you want, zero hassle!',
            style: TextStyle(
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
