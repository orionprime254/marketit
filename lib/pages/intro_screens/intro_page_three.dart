import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPageThree extends StatelessWidget {
  const IntroPageThree({super.key});

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
        Lottie.asset('lib/animations/handshake.json',
            height: 350, fit: BoxFit.fill),
        const Text(
          'Easy contact at the tap of a button!',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30),
        ),
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Call or Whatsapp a seller, seal the deal and go home smiling!',
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
