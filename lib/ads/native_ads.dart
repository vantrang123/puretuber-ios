import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/colors.dart';

class NativeAds extends StatefulWidget {
  final String type;

  NativeAds({required this.type});

  @override
  _NativeAdsState createState() => _NativeAdsState();
}

class _NativeAdsState extends State<NativeAds> {
  // NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  final double _adAspectRatioMedium = (330 / 355);
  final double _adAspectRatioSmall = (91 / 355);

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  // id ca-app-pub-7730748664456234/2990608343

  // test ca-app-pub-3940256099942544/2247696110

  final String _adUnitId = Platform.isAndroid
      ? ''
      : '';

  /// Loads a native ad.
  void loadAd() {
    /*_nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            print('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          // Called when a click is recorded for a NativeAd.
          onAdClicked: (ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (ad) {},
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (ad) {},
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (ad) {},
          // For iOS only. Called before dismissing a full screen view
          onAdWillDismissScreen: (ad) {},
          // Called when an ad receives revenue value.
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: AppColors.backgroundColor,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                backgroundColor: AppColors.backgroundColor,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                backgroundColor: AppColors.backgroundColor,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColors.textColorGray,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColors.textColorGray,
                backgroundColor: AppColors.backgroundColor,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();*/
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
    /*if (_nativeAdIsLoaded && _nativeAd != null)
      return ConstrainedBox(
        constraints: widget.type == 'Small' ? const BoxConstraints(
          minWidth: 320,
          minHeight: 90,
          maxWidth: 400,
          maxHeight: 200,
        ) : const BoxConstraints(
          minWidth: 320,
          minHeight: 320,
          maxWidth: 400,
          maxHeight: 320,
        ),
        child: AdWidget(ad: _nativeAd!),
      );
    else return SizedBox.shrink();*/
  }

  @override
  void dispose() {
    // _nativeAd?.dispose();
    super.dispose();
  }
}
