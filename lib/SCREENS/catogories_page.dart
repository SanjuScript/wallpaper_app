import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/ANIMATION/imageLoadingAnimation.dart';
import 'package:wallpaper_app/API/api.dart';
import 'package:wallpaper_app/COLORS/colors.dart';
import 'package:wallpaper_app/MODEL/wall_muse_model.dart';
import 'package:wallpaper_app/WIDGETS/app_bar.dart';
import 'package:wallpaper_app/screens/image_full_view.dart';
import 'package:wallpaper_app/widgets/widgets.dart';

class AllCategoriesPage extends StatefulWidget {
  final String title;
  final String categoryQuery;

  const AllCategoriesPage({
    Key? key,
    required this.title,
    required this.categoryQuery,
  }) : super(key: key);

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  List<Photos> categoryImages = [];
  int page = 1;
  ScrollController scrollController = ScrollController();


  Future<void> getImageByCategory() async {
    final url = Uri.parse(
        "https://api.pexels.com/v1/search?query=${widget.categoryQuery}&per_page=80");
    final response = await http.get(url, headers: {"Authorization": apiKey});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final wallMuse = WallMuse.fromJson(data);
      setState(() {
        categoryImages = wallMuse.photos ?? [];
      });
    } else {
      log(response.statusCode.toString());
    }
  }

  Future<void> loadMorePages() async {
    setState(() {
      page++;
    });

    final pageUrl =
        "https://api.pexels.com/v1/search?query=${widget.categoryQuery}&per_page=80&page=$page";
    final url = Uri.parse(pageUrl);
    final response = await http.get(url, headers: {"Authorization": apiKey});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final wallMuse = WallMuse.fromJson(data);
      setState(() {
        categoryImages.addAll(wallMuse.photos ?? []);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getImageByCategory();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(height: 50, title: Text(widget.categoryQuery)),
      backgroundColor: GetColor.bgColor,
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: MasonryGridView.builder(
                    shrinkWrap: true,
                    controller: scrollController,
                    padding: const EdgeInsets.all(5),
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: categoryImages.length,
                    itemBuilder: (context, index) {
                      if (index == categoryImages.length - 1) {
                        return InkWell(
                            onTap: loadMorePages,
                            child: loadingImages(context, 'Load more'));
                      }
                      return Padding(
                        padding: const EdgeInsets.all(3),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => ImageFullScreenViewer(
                                      id: categoryImages[index].id!,
                                    )),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: categoryImages[index].src!.tiny!,
                            imageBuilder: (context, imageProvider) => Hero(
                                tag: categoryImages[index].id!,
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Image.network(
                                        categoryImages[index].src!.medium!))),
                            placeholder: (context, url) {
                              return const ImageLoadingAnimation();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
