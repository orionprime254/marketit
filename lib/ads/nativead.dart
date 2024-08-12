import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeController extends GetxController {
  NativeAd? nativeAd;
  RxBool isAdLoaded = false.obs;
  final String adUnit = "ca-app-pub-3940256099942544/2247696110";

  loadAd() {
    nativeAd = NativeAd(
      adUnitId: adUnit,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          isAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          isAdLoaded.value = false;
        },
      ),
      request: AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(templateType: TemplateType.small )
    );
    nativeAd!.load();
  }
  @override
  void dispose() {
    nativeAd?.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
