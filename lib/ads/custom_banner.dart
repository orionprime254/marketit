import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomBannerAd extends StatefulWidget {
  const CustomBannerAd({super.key});

  @override
  State<CustomBannerAd> createState() => _CustomBannerAdState();
}

class _CustomBannerAdState extends State<CustomBannerAd> {
  BannerAd? bannerAd;
  bool isBannerAdLoaded=  false;
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    bannerAd = BannerAd(size: AdSize.banner, adUnitId: "ca-app-pub-3940256099942544/6300978111", listener: BannerAdListener(onAdFailedToLoad: (ad,error){
      print('ad failed to load');
      ad.dispose();
    },onAdLoaded: (ad){
      print('ad loaded');
      setState(() {
        isBannerAdLoaded =  true;
      });
    }
    ), request: AdRequest());
    bannerAd!.load();
  }
  @override
  Widget build(BuildContext context) {
    return isBannerAdLoaded? SizedBox(
      width: double.infinity,
      height: 50,
      child: AdWidget(
        ad: bannerAd!,
      ),
    ): SizedBox();
  }
}
