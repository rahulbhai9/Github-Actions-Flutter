import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1770077062185460/3851157049';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1770077062185460/3826272161';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3964253750';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1770077062185460/3288050267';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/7552160883';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
