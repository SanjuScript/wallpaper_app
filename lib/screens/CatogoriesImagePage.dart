


import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/screens/imageFullscreenViewer.dart';

import '../animation/imageLoadingAnimation.dart';
import '../widgets/widgets.dart';



class AllcatoGoriesPage extends StatefulWidget {
  final String title;
  final String catogoryQuery;
  const AllcatoGoriesPage(
      {super.key, required this.catogoryQuery, required this.title});

  @override
  State<AllcatoGoriesPage> createState() => _AllcatoGoriesPageState();
}

class _AllcatoGoriesPageState extends State<AllcatoGoriesPage> {
  List catogoryImageByTap = [];
  int page = 1;
  getImageBySearchkeyword() async {
    var url = Uri.parse(
        "https://api.pexels.com/v1/search?query=${widget.catogoryQuery}&per_page=80");
    var response = await http.get(url, headers: {
      "Authorization": apiKey,
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        catogoryImageByTap = result['photos'];
      });
    });
  }

  loadMorePages() async {
    setState(() {
      page++;
    });
    String pageurl =
        "https://api.pexels.com/v1/search?query=${widget.catogoryQuery}&per_page=80&page=$page";

    var url = Uri.parse(pageurl);
    var response = await http.get(url, headers: {
      "Authorization": apiKey,
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        catogoryImageByTap.addAll(result['photos']);
      });
    });
  }

  @override
  void initState() {
    getImageBySearchkeyword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;
    return Scaffold(
      body: cachedImaegWidget(
          context,
          ht,
          wt,
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: SizedBox(
              height: ht,
              width: wt,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    space,
                    space,
                    space,
                    catogoryImageByTap.isEmpty
                        ? SizedBox(
                            height: ht / 2,
                          )
                        : Container(
                            height: ht * 0.08,
                            width: wt * 0.9,
                            decoration: BoxDecoration(
                              color: const Color(0xffeef1f6).withOpacity(.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Center(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                    fontFamily: 'optica',
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            )),
                    catogoryImageByTap.isEmpty
                        ? messageWithLoading(context)
                        : Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            padding: const EdgeInsets.all(10),
                            child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                controller: scrollController,
                                itemCount: catogoryImageByTap.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: .6,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  ImageFullScreenViewer(
                                                    id: catogoryImageByTap[
                                                        index]['id'],
                                                  ))));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: catogoryImageByTap[index]['src']
                                          ['tiny'],
                                      imageBuilder: (context, imageProvider) =>
                                          Hero(
                                              tag: catogoryImageByTap[index]['id'],
                                            child: Container(
                                                                                    decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(20)),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                filterQuality: FilterQuality.high,
                                                image: imageProvider),
                                                                                    ),
                                                                                  ),
                                          ),
                                      placeholder: (context, url) {
                                        return const ImageLoadingAnimation();
                                      },
                                    ),
                                  );
                                }),
                          ),
                    InkWell(
                      onTap: () {
                        loadMorePages();
                      },
                      child: catogoryImageByTap.isEmpty
                          ? const SizedBox()
                          : Container(
                              height: ht / 20,
                              width: wt * 0.9,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 157, 142, 142)
                                          .withOpacity(.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Load More",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'optica',
                                        color: Colors.black),
                                  ),
                                  Icon(Icons.local_fire_department_sharp),
                                ],
                              ),
                            ),
                    ),
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
            ),
          )),
    );
  }
}
