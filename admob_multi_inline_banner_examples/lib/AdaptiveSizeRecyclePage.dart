import 'dart:io';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdaptiveSizeRecyclePage extends StatefulWidget {
  const AdaptiveSizeRecyclePage({super.key});

  @override
  State<StatefulWidget> createState() => _AdaptiveSizeRecyclePageState();
}

class _AdaptiveSizeRecyclePageState extends State<AdaptiveSizeRecyclePage> {

  List<BannerAd> _banners = [];
  Map<BannerAd, AdSize> _bannerSizes = {};
  static const _cacheSize = 10;
  Map<BannerAd, int> _bannerPositions = {};

  BannerAd _createBannerAd() {
    final String bannerId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
    AdSize adSize = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(320);
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

  BannerAd _getRecycledBannerAd(int bannerPosition) {
    BannerAd? bannerAd = _banners.firstWhereOrNull((banner) => _bannerPositions[banner] == bannerPosition);
    if (bannerAd != null) {
      return bannerAd;
    } else {
      if (_banners.length < _cacheSize) {
        BannerAd bannerAd = _createBannerAd();
        _banners.add(bannerAd);
        _bannerPositions[bannerAd] = bannerPosition;
        return bannerAd;
      } else {
        BannerAd banner = _banners[bannerPosition % _cacheSize];
        if (banner.isMounted) {
          return _createBannerAd();
        } else {
          _bannerPositions[banner] = bannerPosition;
          return banner;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adaptive Size, Recycle')),
      body: ListView.builder(
        itemCount: 1000,
        itemBuilder: (BuildContext context, int index) {
          if (index % 3 == 0) {
            int bannerPosition = index ~/ 3;
            BannerAd bannerAd = _getRecycledBannerAd(bannerPosition);
            final AdSize? adSize = _bannerSizes[bannerAd];
            if (adSize == null) {
              return SizedBox(height: 50, child: Text("banner is loading"));
            } else {
              return SizedBox(width: adSize.width.toDouble(), height: adSize.height.toDouble(), child: AdWidget(ad: bannerAd));
            }
          } else {
            return SizedBox(height: 50, child: ColoredBox(color: Colors.yellow));
          }
        }),
    );
  }
}