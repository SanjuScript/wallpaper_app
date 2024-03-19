import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/ANIMATION/imageLoadingAnimation.dart';
import 'package:wallpaper_app/ANIMATION/loadingAnimation.dart';
import 'package:wallpaper_app/PROVIDER/trending_photos_provider.dart';

import 'package:wallpaper_app/screens/image_full_view.dart';
import 'package:wallpaper_app/widgets/widgets.dart';

class TrendingWallpaperGrid extends StatelessWidget {
  final ScrollController scrollController;
  const TrendingWallpaperGrid({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TrendingWallpaperProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.images.isEmpty) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              LoadingAnimationPage(),
            ],
          );
        } else {
          return Container(
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
                crossAxisCount: 3,
              ),
              itemCount: provider.images.length,
              itemBuilder: (context, index) {
                if (index == provider.images.length - 1) {
                  return InkWell(
                      onTap: () {
                        provider.loadMore();
                      },
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
                                id: provider.images[index].id!,
                              )),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: provider.images[index].src!.tiny!,
                      imageBuilder: (context, imageProvider) => Hero(
                          tag: provider.images[index].id!,
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Image.network(
                                  provider.images[index].src!.medium!))),
                      placeholder: (context, url) {
                        return const ImageLoadingAnimation();
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
