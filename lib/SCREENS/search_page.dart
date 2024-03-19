import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/COLORS/colors.dart';
import 'package:wallpaper_app/PROVIDER/image_search_query_provider.dart';
import 'package:wallpaper_app/animation/imageLoadingAnimation.dart';
import 'package:wallpaper_app/screens/image_full_view.dart';
import 'package:wallpaper_app/widgets/widgets.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;
    final searchProvider = Provider.of<SearchProvider>(context);
    
    return Scaffold(
      backgroundColor: GetColor.bgColor,
      body: Stack(
        children: [
      
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: ht / 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchProvider.textEditingController,
                          onChanged: (value) {
                            searchProvider.debouncedSearch(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search wallpapers...',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                searchProvider.textEditingController.clear();
                                searchProvider.clearSearch();
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          searchProvider
                              .debouncedSearch(searchProvider.searchQuery);
                        },
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (searchProvider.loading)
                  const CircularProgressIndicator()
                else if (searchProvider.error.isNotEmpty)
                  Text('Error: ${searchProvider.error}')
                else if (searchProvider.searchResults.isEmpty)
                  Center(
                    child: Text(
                      searchProvider.searchQuery.isEmpty
                          ? 'Start searching for wallpapers!'
                          : 'No results found!',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                else
                  Expanded(
                    child: MasonryGridView.builder(
                      padding: const EdgeInsets.all(5),
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // childAspectRatio: 0.6,
                        // crossAxisSpacing: 10,
                        // mainAxisSpacing: 10,
                      ),
                      itemCount: searchProvider.searchResults.length,
                      itemBuilder: (context, index) {
                        final photo = searchProvider.searchResults[index];
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => ImageFullScreenViewer(
                                        id: photo.id!,
                                      )),
                                ),
                              );
                            },
                            
                            child: CachedNetworkImage(
                              imageUrl: photo.src!.tiny!,
                              imageBuilder: (context, imageProvider) => Hero(
                                tag: photo.id!,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  child: Image.network(photo.src!.medium!))
                              ),
                              placeholder: (context, url) {
                                return const ImageLoadingAnimation();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
