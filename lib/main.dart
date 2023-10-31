import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'native_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MaterialApp(
    home: Ads(),
    debugShowCheckedModeBanner: false,
  ));
}

class Ads extends StatefulWidget {
  const Ads({super.key});

  @override
  State<Ads> createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isLoaded = false;

  void loadBannerAd() {
    final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadInterstitialAd() {
    final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/4411468910';
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  void loadRewardedAd() {
    final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/5224354917'
        : 'ca-app-pub-3940256099942544/1712485313';

    RewardedAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }


  @override
  void initState() {
    loadBannerAd();
    loadInterstitialAd();
    loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADS Tutorials'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                _interstitialAd!.show();
              },
              child: Text('Interstitial ADS')),
          ElevatedButton(
              onPressed: () {
                _rewardedAd!.show(
                  onUserEarnedReward: (ad, reward) {},
                );
              },
              child: Text('Video/Rewarded ADS')),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Native(),));
          }, child: Text('Native ADS')),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                (_bannerAd != null)
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      )
                    : Text('')
              ],
            ),
          )
        ],
      ),
    );
  }
}
