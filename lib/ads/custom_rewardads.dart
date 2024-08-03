import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomRewardAd {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'YOUR_AD_UNIT_ID',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
          print('Rewarded Ad loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded Ad failed to load: $error');
        },
      ),
    );
  }

  bool isAdLoaded() {
    return _isAdLoaded;
  }

  void showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('User earned reward: ${reward.amount} ${reward.type}');
      });
      _rewardedAd = null;
      _isAdLoaded = false;
    }
  }
}
