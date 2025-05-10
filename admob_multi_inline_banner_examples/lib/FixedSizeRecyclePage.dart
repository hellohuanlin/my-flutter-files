import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:collection/collection.dart';

class FixedSizeRecyclePage extends StatefulWidget {
  const FixedSizeRecyclePage({super.key});

  @override
  State<StatefulWidget> createState() => _FixedSizeRecyclePageState();
}

class _FixedSizeRecyclePageState extends State<FixedSizeRecyclePage> {

  final List<BannerAd> _banners = [];

  BannerAd _createBannerAd() {
    final String bannerId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
    final BannerAd bannerAd = BannerAd(
      adUnitId: bannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(),
    );
    bannerAd.load();
    return bannerAd;
  }

  BannerAd _getRecycledBannerAd() {
    BannerAd? bannerAd = _banners.firstWhereOrNull((banner) => !banner.isMounted);
    if (bannerAd != null) {
      print('found a reusable banner ad');
    } else {
      print('create a new banner ad');
      bannerAd = _createBannerAd();
      _banners.add(bannerAd);
    }
    return bannerAd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fixed Size, Recycle')),
      body: ListView.builder(
          itemCount: 1000,
          itemBuilder: (BuildContext context, int index) {
            if (index % 3 == 0) {
              BannerAd bannerAd = _getRecycledBannerAd();
              return SizedBox(width: 320, height: 50, child: AdWidget(ad: bannerAd));
            } else {
              return SizedBox(height: 200, child: ColoredBox(color: Colors.yellow));
            }
          },
      ),
    );
  }
}