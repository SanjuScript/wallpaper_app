import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/COLORS/colors.dart';
import 'package:wallpaper_app/PROVIDER/trending_photos_provider.dart';
import 'package:wallpaper_app/WIDGETS/catogory_tile.dart';
import 'package:wallpaper_app/WIDGETS/trending_tile.dart';
import 'package:wallpaper_app/data/catogory_data.dart';
import 'package:wallpaper_app/model/catagories_model.dart';
import 'package:wallpaper_app/screens/search_page.dart';
import 'package:wallpaper_app/screens/trending_wallpapers.dart';
import 'package:wallpaper_app/widgets/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CatorgoriModel> catogories = <CatorgoriModel>[];
  final ScrollController _scrollController = ScrollController();

  void permissionRequest() {
    Permission.storage.request();
  }

  @override
  void initState() {
    catogories = getCatogories();
    permissionRequest();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TrendingWallpaperProvider>(context, listen: false)
          .getTrendingWallpapers();
    });
    Future.delayed(Duration.zero, () {
      Provider.of<TrendingWallpaperProvider>(context, listen: false)
          .getTrendingWallpapers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;

    return RefreshIndicator.adaptive(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () {
        setState(() {});
        return Future.delayed(const Duration(milliseconds: 400));
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: GetColor.bgColor,
        body: ListView(controller: _scrollController, children: [
          Column(
            children: [
              // space,
              SizedBox(
                height: 20,
              ),
              Container(
                height: ht * 0.2,
                width: wt * 0.9,
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 189, 188, 188).withOpacity(.3),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: const Center(
                  child: Text(
                    " Hi \n WallMuse",
                    style: TextStyle(
                      fontFamily: 'optica',
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              InkWell(
                onTap: () {
                
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                child: Container(
                  height: ht * 0.08,
                  width: wt * 0.9,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xffeef1f6).withOpacity(.3),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Find Wallpapper',
                          style: TextStyle(
                            letterSpacing: 1.2,
                            fontFamily: 'optica',
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: ht * .15,
                width: wt,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15),
                  itemCount: catogories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          switch (index) {
                            case 0:
                              navigatingfunction(context, "Nature", "nature");
                              break;
                            case 1:
                              navigatingfunction(
                                  context, "Wild Life", "wildlife");
                              break;
                            case 2:
                              navigatingfunction(context, "Solid", "solid");
                              break;
                            case 3:
                              navigatingfunction(context, "Cars", "cars");
                              break;
                            case 4:
                              navigatingfunction(context, "Night", "night");
                              break;
                            case 5:
                              navigatingfunction(context, "Coffee", "coffee");
                              break;
                          }
                        },
                        child: CatogoryTile(
                          imgurl: catogories[index].imgUrl!,
                          title: catogories[index].catogoriName!,
                        ),
                      ),
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TrendingWallpaperPage()));
                },
                child: Container(
                  height: ht / 20,
                  width: wt * 0.9,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 189, 188, 188)
                        .withOpacity(.3),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Center(
                    child: Text(
                      "#gettrendingwallpaper",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'optica',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              TrendingWallpaperGrid(scrollController: _scrollController)
            ],
          ),
        ]),
      ),
    );
  }
}
