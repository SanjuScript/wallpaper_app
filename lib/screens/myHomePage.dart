import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/model/catagoriesModel.dart';
import 'package:wallpaper_app/screens/searchPage.dart';
import 'package:wallpaper_app/screens/trendingWallpaper.dart';
import 'package:wallpaper_app/widgets/widgets.dart';
import '../animation/animationPageController.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CatorgoriModel> catogories = <CatorgoriModel>[];
  void permissionRequest() {
    Permission.storage.request();
  }

  @override
  void initState() {
    catogories = getCatogories();
    permissionRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      body: CachedNetworkImage(
        imageUrl: bgImage,
        imageBuilder: (context, imageProvider) => Container(
          height: ht,
          width: wt,
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: imageProvider),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SizedBox(
              height: ht,
              width: wt,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                SearchAnimationNavigation(
                                    const TrendingWallpaperPage()));
                          },
                          child: Container(
                            height: ht / 20,
                            width: wt * 0.9,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 189, 188, 188)
                                    .withOpacity(.3),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "#gettrendingwallpaper",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'optica',
                                      color: Colors.white),
                                ),
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        space,
                        Container(
                          height: ht * 0.2,
                          width: wt * 0.9,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 189, 188, 188)
                                  .withOpacity(.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          child: Row(
                            children: const [
                              Text(
                                " Hi \n WallMuse",
                                style: TextStyle(
                                    fontFamily: 'optica',
                                    fontSize: 30,
                                    color: Colors.white),
                              ),
                              SizedBox()
                            ],
                          ),
                        ),
                        space,
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                SearchAnimationNavigation(const SearchPage()));
                          },
                          child: Container(
                              height: ht * 0.08,
                              width: wt * 0.9,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: const Color(0xffeef1f6).withOpacity(.3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Find Wallpapper',
                                    style: TextStyle(
                                        letterSpacing: 1.2,
                                        fontFamily: 'optica',
                                        color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ],
                              ))),
                        ),
                        space,
                        space,
                        space,
                        GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(15),
                          itemCount: catogories.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: .8,
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    navigatingfunction(
                                        context, "Nature", "nature");
                                    break;
                                  case 1:
                                    navigatingfunction(
                                        context, "Wild Life", "wildlife");
                                    break;
                                  case 2:
                                    navigatingfunction(
                                        context, "Solid", "solid");
                                    break;
                                  case 3:
                                    navigatingfunction(context, "Cars", "cars");
                                    break;
                                  case 4:
                                    navigatingfunction(
                                        context, "Night", "night");
                                    break;
                                  case 5:
                                    navigatingfunction(
                                        context, "Coffee", "coffee");
                                    break;
                                }
                              },
                              child: catogoriesTile(
                                  context,
                                  catogories[index].imgUrl!,
                                  catogories[index].catogoriName!),
                            );
                          },
                          controller: scrollController,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
