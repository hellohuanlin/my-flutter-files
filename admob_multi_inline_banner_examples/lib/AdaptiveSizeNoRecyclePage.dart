import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdaptiveSizeNoRecyclePage extends StatefulWidget {
  const AdaptiveSizeNoRecyclePage({super.key});

  @override
  State<StatefulWidget> createState() => _AdaptiveSizeNoRecyclePageState();
}

class _AdaptiveSizeNoRecyclePageState extends State<AdaptiveSizeNoRecyclePage> {


  // A list of all the banners created.
  final List<BannerAd> _banners = [];
  // Keep track of sizes of the banners (since they can be different sizes).
  final Map<BannerAd, AdSize> _bannerSizes = {};

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
          // When the banner size is updated, we want to rebuild.
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
      // If we already created a banner for this position, just reuse it.
      return _banners[bannerPosition];
    } else {
      // Otherwise, create a new banner.
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
        // Arbitrary example of 1000 items in the list.
        itemCount: 1000,
        itemBuilder: (BuildContext context, int index) {
          if (index % 3 == 0) {
            // We show a banner every 3 rows (i.e. row index 0, 3, 6, 9, 12, etc will be banner row)
            BannerAd bannerAd = _getBannerAd(index ~/ 3);
            AdSize? adSize = _bannerSizes[bannerAd];
            if (adSize == null) {
              // Null adSize means the banner's content is not fetched yet.
              return SizedBox(height: 50, child: Text("banner is loading"));
            } else {
              // Now this banner is loaded with ad content and corresponding ad size.
              return SizedBox(width: adSize.width.toDouble(), height: adSize.height.toDouble(), child: AdWidget(ad: bannerAd));
            }
          } else {
            // Show your regular non-ad content.
            return SizedBox(height: 200, child: ColoredBox(color: Colors.yellow));
          }
        },
      ),
    );
  }
}