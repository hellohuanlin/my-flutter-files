import 'dart:io';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdaptiveSizeNoRecyclePage extends StatefulWidget {
  const AdaptiveSizeNoRecyclePage({super.key});

  @override
  State<StatefulWidget> createState() => _AdaptiveSizeNoRecyclePageState();
}

class _AdaptiveSizeNoRecyclePageState extends State<AdaptiveSizeNoRecyclePage> {

  List<BannerAd> _banners = [];
  Map<BannerAd, AdSize> _bannerSizes = {};

  BannerAd _createBannerAd() {
    final String bannerId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
    AdSize adSize = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(320);
    print("Create a new banner");
    final BannerAd bannerAd = BannerAd(
      adUnitId: bannerId,
      request: const AdRequest(),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          BannerAd bannerAd = (ad as BannerAd);
          final AdSize? adSize = await bannerAd.getPlatformAdSize();
          if (adSize != null && adSize != _bannerSizes[bannerAd]) {
            setState(() {
              _bannerSizes[bannerAd] = adSize;
            });
          }
        },
      ),
    );
    bannerAd.load();
    return bannerAd;
  }

  BannerAd _getBannerAd(int bannerPosition) {
    if (bannerPosition < _banners.length) {
      return _banners[bannerPosition];
    } else {
      BannerAd bannerAd = _createBannerAd();
      _banners.add(bannerAd);
      return bannerAd;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adaptive Size, No Recycle')),
      body: ListView.builder(
        itemCount: 1000,
        itemBuilder: (BuildContext context, int index) {
          if (index % 3 == 0) {
            BannerAd bannerAd = _getBannerAd(index ~/ 3);
            AdSize? adSize = _bannerSizes[bannerAd];
            if (adSize == null) {
              return SizedBox(height: 50, child: Text("banner is loading"));
            } else {
              return SizedBox(width: adSize.width.toDouble(), height: adSize.height.toDouble(), child: AdWidget(ad: bannerAd));
            }
          } else {
            return SizedBox(height: 200, child: ColoredBox(color: Colors.yellow));
          }
        },
      ),
    );
  }
}