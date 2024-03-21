import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/API/api.dart';
import 'package:wallpaper_app/COLORS/colors.dart';
import 'package:wallpaper_app/HELPER/ad_helper.dart';
import 'package:wallpaper_app/HELPER/color_helper.dart';
import 'package:wallpaper_app/MODEL/wall_muse_model.dart';
import 'package:wallpaper_app/WIDGETS/download_button.dart';
import '../widgets/widgets.dart';

class ImageFullScreenViewer extends StatefulWidget {
  final int id;
  const ImageFullScreenViewer({super.key, required this.id});

  @override
  State<ImageFullScreenViewer> createState() => _ImageFullScreenViewerState();
}

class _ImageFullScreenViewerState extends State<ImageFullScreenViewer> {
  SinglePhoto? individualImage;
  getIndividualPhotosBySeperateApi() async {
    var url = Uri.parse("https://api.pexels.com/v1/photos/${widget.id}");
    var response = await http.get(url, headers: {
      "Authorization": apiKey,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final singlephoto = SinglePhoto.fromJson(data);
      setState(() {
        individualImage = singlephoto;
        log(individualImage.toString());
      });
    } else {
      log(response.statusCode.toString());
    }
  }

  RewardedAd? _rewardedAd;
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.adManagerRequest;
              saveFile(individualImage!.src!.tiny!);
            },
            onAdDismissedFullScreenContent: (ad) {
              setState(
                () {
                  ad.dispose();
                  _rewardedAd = null;
                },
              );
              loadRewardedAd();
            },
          );
          setState(
            () {
              _rewardedAd = ad;
            },
          );
        },
        onAdFailedToLoad: (error) {
          log(error.toString());
          // saveFile(inidividualImage['src']['original']);
        },
      ),
    );
  }

  void saveFile(String url) {
    FileDownloader.downloadFile(
      notificationType: NotificationType.all,
      url: url,
      onProgress: (fileName, progress) {
        setState(() {
          _progress = progress;
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

  double? _progress;

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

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          if (individualImage != null) _buildBackgroundImage(context, ht, wt),
          _buildContent(context, ht, wt),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(BuildContext context, double ht, double wt) {
    return SizedBox(
      height: ht,
      width: wt,
      child: CachedNetworkImage(
        imageUrl: individualImage!.src!.large2x!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.transparent),
        errorWidget: (context, url, error) =>
            Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double ht, double wt) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: individualImage != null
              ? hexToColor(individualImage!.avgColor!).withOpacity(.2)
              : Colors.black.withOpacity(.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (individualImage != null) _buildCachedNetworkImage(ht, wt),
              if (_progress != null)
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 10,
                  color: Colors.purple,
                  backgroundColor: Colors.white.withOpacity(.4),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCachedNetworkImage(double ht, double wt) {
    return CachedNetworkImage(
      placeholder: (context, url) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [messageWithLoading(context)],
      ),
      imageUrl: individualImage!.src!.large2x!,
      imageBuilder: (context, imageProvider) => Hero(
        tag: widget.id,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Image(
                    gaplessPlayback: true,
                    image: imageProvider,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                _buildDownloadButtons(ht, wt, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButtons(double ht, double wt, BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Center(
        child: SizedBox(
          height: ht * .25,
          width: wt * .90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DonwloadButton(
                  onTap: () async {
                    saveFile(individualImage!.src!.large2x!);
                  },
                  is1st: true,
                  text: "Donwload Image"),
              SizedBox(height: ht / 20),
              DonwloadButton(
                  onTap: () async {
                    saveFile(individualImage!.src!.original!);
                  },
                  is1st: true,
                  text: "Download Full Quality Image"),
            ],
          ),
        ),
      ),
    );
  }
}
