import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FixedSizeNoRecyclePage extends StatefulWidget {
  const FixedSizeNoRecyclePage({super.key});

  @override
  State<StatefulWidget> createState() => _FixedSizeNoRecyclePageState();
}
class _FixedSizeNoRecyclePageState extends State<FixedSizeNoRecyclePage> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text('Fixed Size, No Recycle'),),
        body: ListView.builder(
          itemCount: 1000,
          itemBuilder: (BuildContext context, int index) {
            if (index % 3 == 0) {
              BannerAd bannerAd = _createBannerAd();
              return SizedBox(width: 320, height: 50, child: AdWidget(ad: bannerAd));
            } else {
              return SizedBox(height: 50, child: ColoredBox(color: Colors.yellow));
            }
          },
        ),
    );
  }
}

