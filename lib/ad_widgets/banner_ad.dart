import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppBannerAd extends StatefulWidget {
  const AppBannerAd({super.key});

  @override
  State<AppBannerAd> createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  BannerAd? _bannerAd;
  final adUnit = 'ca-app-pub-3940256099942544/6300978111';

  loadAd() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: adUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            log('$ad loaded.');
          },
          onAdFailedToLoad: (ad, error) {
            log('$ad disposed');
            ad.dispose();
          },
        ),
        request: const AdRequest())
      ..load();
  }

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  void dispose() {
    if (_bannerAd != null) {
      _bannerAd!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(key: UniqueKey(), ad: _bannerAd!),
        );
      },
    );
  }
}
