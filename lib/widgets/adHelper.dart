import 'dart:io';

class AdHelper {
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      //My Ad Id
      return "ca-app-pub-8338859460861716/7816203199";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }
}
