import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class AppOpenAdManager{
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  static bool isLoaded= false;

  void loadAd(){
    AppOpenAd.load(adUnitId: 'ca-app-pub-3940256099942544/9257395921',
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad){print('ad loaded..............');
          _appOpenAd = ad;
          isLoaded = true;
          }, onAdFailedToLoad: (error){

        }),
        orientation: AppOpenAd.orientationPortrait

    );
  }
  bool get isAdAvailable{
    return _appOpenAd != null;
  }
  void showAdIfAvailable(){
    print('called.........');
    if(_appOpenAd == null){
      print('tried to show ad before available');
      loadAd();
      return;
    }
    if(_isShowingAd){
      print('tried tp shpw an ad while already showing an ad');
      return;
    }
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad){
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');

      },
      onAdFailedToShowFullScreenContent: (ad,error){
        print('$ad onAdfailedtoshpwfulscreencontent: $error');
        _isShowingAd  = false;
        ad.dispose();
        _appOpenAd = null;
    },
      onAdDismissedFullScreenContent: (ad){
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd=null;
        loadAd();
      }

    );
    _appOpenAd!.show();
  }
}