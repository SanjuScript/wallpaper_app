import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/PROVIDER/image_search_query_provider.dart';
import 'package:wallpaper_app/PROVIDER/trending_photos_provider.dart';
import 'package:wallpaper_app/SCREENS/my_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Google Admob
  Future<InitializationStatus> initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  await initGoogleMobileAds();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => TrendingWallpaperProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SearchProvider(),
      ),
    ],
    child: const MyApp(),
  ));
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
