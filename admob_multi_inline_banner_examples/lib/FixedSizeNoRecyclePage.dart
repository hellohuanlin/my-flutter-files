import 'package:flutter/material.dart';


class FixedSizeNoRecyclePage extends StatefulWidget {

  const FixedSizeNoRecyclePage({super.key});

  @override
  State<StatefulWidget> createState() => _FixedSizeNoRecyclePageState();
}
class _FixedSizeNoRecyclePageState extends State<FixedSizeNoRecyclePage> {

  @override
  Widget build(BuildContext context) {
    BannerAd _createBannerAd() {
      final String bannerId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';

      final BannerAd bannerAd = BannerAd(

      )

    }

  }
}

