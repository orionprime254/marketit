import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomRewardAd {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
          print('Rewarded Ad loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded Ad failed to load: ${error.message}');
          _isAdLoaded = false;
          Future.delayed(Duration(seconds: 30), () {
            loadRewardedAd(); // Retry after a delay
          });
        },
      ),
    );
  }

  bool isAdLoaded() {
    return _isAdLoaded;
  }

  void showRewardedAd({required Function(dynamic) onAdDismissed}) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
        },
      );
      _rewardedAd = null;
      _isAdLoaded = false;
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {},
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          loadRewardedAd(); // Reload the ad on failure
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          onAdDismissed(ad);
        },
        onAdImpression: (RewardedAd ad) => print('$ad impression occurred'),
      );
    } else {
      onAdDismissed(null);
    }
  }

  void dispose() {
    _rewardedAd?.dispose();
  }
}
