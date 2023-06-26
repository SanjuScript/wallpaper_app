import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import '../data/data.dart';
import '../widgets/adHelper.dart';
import '../widgets/widgets.dart';

class ImageFullScreenViewer extends StatefulWidget {
  final int id;
  const ImageFullScreenViewer({super.key, required this.id});

  @override
  State<ImageFullScreenViewer> createState() => _ImageFullScreenViewerState();
}

class _ImageFullScreenViewerState extends State<ImageFullScreenViewer> {
  // ignore: prefer_typing_uninitialized_variables, avoid_init_to_null
  var inidividualImage = null;
  getIndividualPhotosBySeperateApi() async {
    var url = Uri.parse("https://api.pexels.com/v1/photos/${widget.id}");
    var response = await http.get(url, headers: {
      "Authorization": apiKey,
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        inidividualImage = result;
      });
      // print(inidividualImage);
    });
  }

  RewardedAd? _rewardedAd;
  void loadRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) {
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  setState(() {
                    ad.dispose();
                    _rewardedAd = null;
                  });
                  loadRewardedAd();
                },
              );
              setState(() {
                _rewardedAd = ad;
              });
            },
            onAdFailedToLoad: (error) {}));
  }

  // Future<bool> saveFile(String url) async {
  //   Directory directory;

  //   try {
  //     if (Platform.isAndroid) {
  //       if (await requestpermission(Permission.storage)) {
  //         directory = (await getExternalStorageDirectory())!;

  //         String newPath = '';
  //         List<String> paths = directory.path.split("/");
  //         for (int x = 1; x < paths.length; x++) {
  //           String folder = paths[x];
  //           if (folder != "Android") {
  //             newPath += "/" + folder;
  //           } else {
  //             break;
  //           }
  //         }
  //         newPath = newPath + "/wallmuse";
  //         directory = Directory(newPath);
  //       } else {
  //         return false;
  //       }
  //     } else {
  //       if (await requestpermission(Permission.photos)) {
  //         directory = await getTemporaryDirectory();
  //       } else {
  //         return false;
  //       }
  //     }
  //     if (!await directory.exists()) {
  //       await directory.create(recursive: true);
  //     }
  //     if (await directory.exists()) {
  //       File saveFile = File(directory.path);
  //       await ImageDownloader.downloadImage(
  //         url,
  //       );
  //       if (Platform.isIOS) {
  //         print("object");
  //       }
  //       return true;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return false;
  // }

  // Future<bool> requestpermission(Permission permission) async {
  //   if (await permission.isGranted) {
  //     return true;
  //   } else {
  //     var result = await permission.request();
  //     if (result == PermissionStatus.granted) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  // Future<void> imageDownload(String url) async {
  //   Directory directory;
  //   if (Platform.isAndroid) {
  //     if (await requestpermission(Permission.storage)) {
  //       directory = (await getExternalStorageDirectory())!;

  //       String newPath = '';
  //       List<String> folders = directory.path.split("/");
  //       for (int x = 1; x < folders.length; x++) {
  //         String folder = folders[x];
  //         if (folder != "Android") {
  //           newPath += "/$folder";
  //         } else {
  //           break;
  //         }
  //       }

  //       newPath = "$newPath/wallmuse";
  //       directory = Directory(newPath);

  //       print(directory.path);
  //     } else {
  //       return null;
  //     }
  //   } else {
  //     print("ios");
  //   }
  // }

  void saveFile(String url) {
    FileDownloader.downloadFile(
      url: url,
      onProgress: (fileName, progress) {
        setState(() {
          _progrss = progress;
        });
      },
      onDownloadCompleted: (path) {
        customToast("Download Completed", context);
      },
      onDownloadError: (errorMessage) {
        customToast("$errorMessage:::Try Later", context);
      },
    );
  }

  @override
  void initState() {
    loadRewardedAd();
    getIndividualPhotosBySeperateApi();
    super.initState();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  double? _progrss;
  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CachedNetworkImage(
        placeholder: (context, url) {
          return loadingImages(context, 'Loading....');
        },
        fit: BoxFit.cover,
        width: wt,
        height: ht,
        imageUrl: bgImage,
        imageBuilder: (context, imageProvider) => Container(
          height: ht,
          width: wt,
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: imageProvider),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    inidividualImage != null
                        ? CachedNetworkImage(
                            placeholder: (context, url) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                messageWithLoading(context),
                                space,
                              ],
                            ),
                            imageUrl: inidividualImage['src']['large2x'],
                            imageBuilder: (context, imageProvider) => Hero(
                                tag: widget.id,
                              child: Container(
                                height: ht,
                                width: wt,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                        image: imageProvider)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _progrss != null
                                        ? LinearProgressIndicator(
                                            value: _progrss,
                                            minHeight: 10,
                                            color: Colors.purple,
                                            backgroundColor:
                                                Colors.white.withOpacity(.4),
                                          )
                                        : const SizedBox(),
                                    space,
                                    space,
                                    InkWell(
                                      onTap: () async {
                                        _rewardedAd?.show(
                                            onUserEarnedReward: (ad, reward) {
                                          saveFile(
                                              inidividualImage['src']['large2X']);
                                        });
                                      },
                                      child: Container(
                                        height: ht / 18,
                                        width: wt / 2,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                128, 148, 138, 138),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                width: 1, color: Colors.white)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(),
                                            Text(
                                              "Download Image",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'optica',
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.download,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        _rewardedAd?.show(
                                            onUserEarnedReward: (ad, reward) {
                                          saveFile(inidividualImage['src']
                                              ['original']);
                                        });
                                      },
                                      child: Container(
                                        height: ht / 18,
                                        width: wt / 2 + 50,
                                        margin: EdgeInsets.symmetric(
                                            vertical: ht / 20),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                128, 148, 138, 138),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                width: 1, color: Colors.white)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(),
                                            Text(
                                              "Download Full Quality Image",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'optica',
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.download,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              messageWithLoading(context),
                              space,
                            ],
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
