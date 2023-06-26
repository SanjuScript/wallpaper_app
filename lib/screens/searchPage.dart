
import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/animation/imageLoadingAnimation.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/screens/imageFullscreenViewer.dart';
import 'package:wallpaper_app/widgets/widgets.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();
  ScrollController controller = ScrollController();


  int page = 1;

  String _searchQuery = '';
  List<dynamic> _searchResults = [];
  Future<void> searchPhotos(String query) async {
    final response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=80&page=$page"),
        headers: {
          "Authorization": apiKey,
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _searchResults = data['photos'];
      });
    } else {
      throw Exception("Failed TO Load Search");
    }
  }

  loadMorePages() async {
    setState(() {
      page++;
    });
    String searchPageUrl =
        "https://api.pexels.com/v1/search?query=$_searchQuery&per_page=80&page=$page";

    var url = Uri.parse(searchPageUrl);
    var response = await http.get(url, headers: {
      "Authorization": apiKey,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _searchResults.addAll(data['photos']);
      });
    } else {
      throw Exception("Failed To Add Search Potos");
    }
  }

  @override
  void initState() {
    searchPhotos('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;

    return Scaffold(
        body: CachedNetworkImage(
      imageUrl: bgImage,
      imageBuilder: (context, imageProvider) => Container(
          height: ht,
          width: wt,
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: imageProvider),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: SizedBox(
              height: ht,
              width: wt,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      height: ht / 14,
                    ),
                    textField(context, textEditingController, () async {
                      await searchPhotos(_searchQuery);
                    }, (value) async {
                      await searchPhotos(_searchQuery);
                    }, (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    }),
                    _searchResults.isEmpty
                        ? Center(
                            child: Padding(
                                padding: EdgeInsets.only(top: ht / 5 + 40),
                                child: loadingImages(
                                    context, "Search Something ...!!")))
                        : Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            padding: const EdgeInsets.all(10),
                            child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                controller: scrollController,
                                itemCount: _searchResults.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: .6,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) {
                                  final photo = _searchResults[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  ImageFullScreenViewer(
                                                    id: photo['id'],
                                                  ))));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: photo['src']['tiny'],
                                      imageBuilder: (context, imageProvider) =>
                                          Hero(
                                            tag: photo['id'],
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
                                        return ImageLoadingAnimation();
                                      },
                                    ),
                                  );
                                }),
                          ),
                    _searchResults.isEmpty
                        ? SizedBox()
                        : InkWell(
                            onTap: () {
                              loadMorePages();
                            },
                            child: Container(
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
    ));
  }
}
