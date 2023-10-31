import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Native extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NativeExampleState();
  }
}

class NativeExampleState extends State {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  /// Loads a native ad.
  void loadAd() {
    _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
          },
        ),
        request: const AdRequest(),
        // Styling'
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.purple,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 320, // minimum recommended width
          minHeight: 90, // minimum recommended height
          maxWidth: 400,
          maxHeight: 200,
        ),
        child: AdWidget(ad: _nativeAd!),
      )),
    );
  }
}
