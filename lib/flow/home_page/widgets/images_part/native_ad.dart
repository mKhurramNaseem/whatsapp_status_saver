import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:whatsapp_status_saver/util/connectivity_manager.dart';

class NativeAdImages extends StatefulWidget {
  const NativeAdImages({super.key});

  @override
  State<NativeAdImages> createState() => _NativeAdImagesState();
}

class _NativeAdImagesState extends State<NativeAdImages> {
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;
  static const adUnitId = 'ca-app-pub-3940256099942544/2247696110';

  @override
  void initState() {
    super.initState();
    loadAd();    
  }

  loadAd() async{
    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('$ad Loaded');
          setState(() {
            _isNativeAdLoaded = true;
          });
        },
        onAdClosed: (ad) {
          ad.dispose();
        },
        onAdImpression: (ad) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
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
            size: 16.0),
      ),
    );
    final isConnected = await ConnectivityManager.isConnected();
    if(isConnected){
      _nativeAd?.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Builder(builder: (context) {
        if (_isNativeAdLoaded) {
          return ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 320, // minimum recommended width
                minHeight: 320, // minimum recommended height
                maxWidth: 400,
                maxHeight: 400,
              ),
              child: AdWidget(ad: _nativeAd!));
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
