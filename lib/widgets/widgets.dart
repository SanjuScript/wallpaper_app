import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:wallpaper_app/SCREENS/catogories_page.dart';

import 'package:flutter/material.dart';

Widget loadingImages(BuildContext context, String text, {bool isTapped = false}) {
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
      child: isTapped
          ? FutureBuilder(
              future: Future.delayed(Duration(seconds: 5)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text(
                      'Loading...',
                      style: const TextStyle(
                        fontFamily: 'optica',
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontFamily: 'optica',
                      ),
                    ),
                  );
                }
              },
            )
          : Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'optica',
                ),
              ),
            ),
    ),
  );
}

void navigatingfunction(
    BuildContext context, String title, String catogoryQuery) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AllCategoriesPage(categoryQuery: catogoryQuery, title: title,)));
}

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

Widget messageWithLoading(BuildContext context) {
  return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    loadingImages(context, 'Loading Image....'),
    const SizedBox(height: 20,),
    const Text(
      'Download Wallpaper To Get The Full HD Quality Resolution & Aspect Ratio',
      textAlign: TextAlign.center,
      style: TextStyle(
          letterSpacing: 1.2, fontFamily: 'optica', color: Colors.white),
    ),
  ]);
}