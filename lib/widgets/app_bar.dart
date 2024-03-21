import 'package:flutter/material.dart';
import 'package:wallpaper_app/COLORS/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget title;

  const CustomAppBar({
    Key? key,
    required this.height,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
              color:GetColor.bgColor,
              borderRadius: BorderRadius.circular(20),
          ),
      child: AppBar(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), 
          ),
        ),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        centerTitle: true,
        title: title,
        // centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
