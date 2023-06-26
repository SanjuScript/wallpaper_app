import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:wallpaper_app/screens/CatogoriesImagePage.dart';
import '../animation/animationPageController.dart';

//catogories Tile Widget

Widget catogoriesTile(
  BuildContext context,
  String imgUrl,
  String title,
) {
  final ht = MediaQuery.of(context).size.height;
  final wt = MediaQuery.of(context).size.width;
  return Stack(
    children: [
      Container(
        height: ht / 2,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imgUrl),
          ),
        ),
      ),
      Container(
        decoration: const BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: ht / 2,
        child: Center(
            child: Text(
          title,
          style: const TextStyle(
              fontFamily: 'optica', fontSize: 15, color: Colors.white),
        )),
      ),
    ],
  );
}

//cached image network image

Widget cachedImaegWidget(
  BuildContext context,
  double ht,
  wt,
  Widget child,
) {
  return CachedNetworkImage(
      imageUrl: bgImage,
      imageBuilder: (context, imageProvider) => Container(
            height: ht,
            width: wt,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: imageProvider,
              ),
            ),
            child: child,
          ));
}

//when image is in waiting stage

Widget loadingImages(BuildContext context, String text) {
  final ht = MediaQuery.of(context).size.height;
  final wt = MediaQuery.of(context).size.width;
  return Center(
    child: Container(
        height: ht * 0.08,
        width: wt * 0.5,
        decoration: BoxDecoration(
          color: const Color(0xffeef1f6).withOpacity(.3),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'optica',
            ),
          ),
        )),
  );
}

//function to navigate to page

void navigatingfunction(
    BuildContext context, String title, String catogoryQuery) {
  Navigator.push(
      context,
      SearchAnimationNavigation(AllcatoGoriesPage(
        title: title,
        catogoryQuery: catogoryQuery,
      )));
}

//textfield widget

Widget textField(
    BuildContext context,
    TextEditingController controller,
    void Function() onPress,
    void Function(String) onSubmitted,
    void Function(String) onChanged) {
  final ht = MediaQuery.of(context).size.height;
  final wt = MediaQuery.of(context).size.width;
  return Container(
      height: ht * 0.08,
      width: wt * 0.9,
      decoration: BoxDecoration(
        color: const Color(0xffeef1f6).withOpacity(.6),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: TextField(
          autofocus: true,
          onChanged: onChanged,
          controller: controller,
          onSubmitted: onSubmitted,
          style: TextStyle(fontFamily: 'optica'),
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: onPress,
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              contentPadding: const EdgeInsets.all(15),
              border: InputBorder.none,
              hintText: 'Find Wallpapper',
              hintStyle: const TextStyle(fontFamily: 'optica')),
          cursorColor: const Color.fromARGB(255, 206, 209, 212).withOpacity(.7),
        ),
      ));
}

//toast message

void customToast(String message, BuildContext context) {
  showToast(message.toUpperCase(),
      textStyle: const TextStyle(
          fontSize: 17,
          fontFamily: "bold",
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(206, 25, 184, 120)),
      animation: StyledToastAnimation.slideFromTop,
      curve: Curves.easeOutCubic,
      position: const StyledToastPosition(align: Alignment.topCenter),
      alignment: Alignment.topCenter,
      reverseCurve: Curves.easeOutCirc,
      duration: const Duration(seconds: 3),
      animDuration: const Duration(milliseconds: 500),
      context: context,
      backgroundColor: Colors.white.withOpacity(.4),
      borderRadius: BorderRadius.circular(10),
      reverseAnimation: StyledToastAnimation.slideToTop);
}

//image loading with text

Widget messageWithLoading(BuildContext context) {
  return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    loadingImages(context, 'Loading Image....'),
    space,
    const Text(
      'Download Wallpaper To Get The Full HD Quality Resolution & Aspect Ratio',
      textAlign: TextAlign.center,
      style: TextStyle(
          letterSpacing: 1.2, fontFamily: 'optica', color: Colors.white),
    ),
  ]);
}

//background image for all

String bgImage =
    "https://images.pexels.com/photos/1995730/pexels-photo-1995730.jpeg?auto=compress&cs=tinysrgb&w=600";

//space bar

const space = SizedBox(
  height: 20,
);

//controller

ScrollController scrollController = ScrollController();
