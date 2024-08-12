import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPageOne extends StatelessWidget {
  const IntroPageOne({super.key});

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
        Lottie.asset('lib/animations/app animation.json',
            height: 350, fit: BoxFit.fill),
        const Text(
          'Welcome to MarketIt!',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30),
        ),
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'A place where students over Kenya can buy and sell their second-hand items for affordable prices!',
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
