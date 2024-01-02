import 'dart:io';

import 'package:flutter/material.dart';

class InterstitialAds {
  // InterstitialAd? get interstitialAd => _interstitialAd;
  // InterstitialAd? _interstitialAd;

  // id
  // ca-app-pub-7730748664456234/5800550619

  // id test
  // ca-app-pub-3940256099942544/1033173712

  final adUnitId = Platform.isAndroid
      ? ''
      : '';

  void loadAd({VoidCallback? callback}) {
    callback?.call();
    /*InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
            callback?.call();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));*/
  }

  Future<void> showAds(VoidCallback? onNext) async {
    onNext?.call();
    /*try {
      if (_interstitialAd != null) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {},
            // Called when an impression occurs on the ad.
            onAdImpression: (ad) {},
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              ad.dispose();
              onNext?.call();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              loadAd();
              ad.dispose();
              onNext?.call();
            },
            // Called when a click is recorded for an ad.
            onAdClicked: (ad) {});
        _interstitialAd!.show();
      } else {
        loadAd(callback: () {
        });
        onNext?.call();
      }
    } catch (e) {
      loadAd(callback: () {
        showAds(onNext);
      });
      onNext?.call();
    }*/
  }
}
