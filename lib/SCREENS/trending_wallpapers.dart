import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/PROVIDER/trending_photos_provider.dart';
import 'package:wallpaper_app/WIDGETS/trending_tile.dart';
import 'package:wallpaper_app/widgets/widgets.dart';

class TrendingWallpaperPage extends StatefulWidget {
  const TrendingWallpaperPage({super.key});

  @override
  TrendingWallpaperPageState createState() => TrendingWallpaperPageState();
}

class TrendingWallpaperPageState extends State<TrendingWallpaperPage> {
ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<TrendingWallpaperProvider>(context, listen: false).getTrendingWallpapers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;

    return Scaffold(
      body:SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // space,
                  // space,
                  // space,
                  Container(
                    height: ht * 0.08,
                    width: wt * 0.9,
                    decoration: BoxDecoration(
                      color: const Color(0xffeef1f6).withOpacity(.3),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Center(
                      child: Text(
                        'Trending Now',
                        style: TextStyle(
                          fontFamily: 'optica',
                        ),
                      ),
                    ),
                  ),
               TrendingWallpaperGrid(scrollController:scrollController),
                
                  const SizedBox(
                    height: 30,
                    child: Icon(
                      Icons.dangerous,
                      color: Colors.transparent,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

