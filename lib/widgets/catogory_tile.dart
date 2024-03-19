import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CatogoryTile extends StatelessWidget {
  final String imgurl;
  final String title;
  const CatogoryTile({super.key, required this.imgurl, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      height: size.height * 0.20,
      width: size.width * 0.30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(imgurl), // Use CachedNetworkImageProvider
        ),
      ),
      child: Stack(
        children: [
          Container(
            height: size.height * 0.20,
            width: size.width * 0.30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'optica',
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
