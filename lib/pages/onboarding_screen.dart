import 'package:flutter/material.dart';
import 'package:marketit/auth/auth.dart';
import 'package:marketit/pages/intro_screens/intro_page_three.dart';
import 'package:marketit/pages/intro_screens/intro_page_two.dart';
import 'package:marketit/pages/intro_screens/intro_pageone.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController();

  // Keeps track of the pages to see if we're on the last page
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            controller: _controller,
            children: const [IntroPageOne(), IntroPageTwo(), IntroPageThree()],
          ),
          Container(

            alignment: const Alignment(0, 0.80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Container(
                        width: 60,
                        height: 50,
                        decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey),
                      //color: Colors.grey[200]
                    ),child: Center(child: const Text('Skip')))),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                ),
                onLastPage
                    ? GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('onboardingComplete', true);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return AuthPage();
                          }));
                    },
                    child: Container(width: 60,
                        height: 50,decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey),
                      //color: Colors.grey[200]
                    ),child: Center(child: const Text('Done'))))
                    : GestureDetector(
                    onTap: () {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Container(width: 60,
                        height: 50,decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey),
                      //color: Colors.grey[200]
                    ),child: Center(child: const Text('Next'))))
              ],
            ),
          )
        ],
      ),
    );
  }
}
