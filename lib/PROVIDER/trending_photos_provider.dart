import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/API/api.dart';
import 'package:wallpaper_app/MODEL/wall_muse_model.dart';
import 'package:http/http.dart' as http;


class TrendingWallpaperProvider extends ChangeNotifier {
  List<Photos> _images = [];
  bool _isLoading = false;
  int _page = 1;

  List<Photos> get images => _images;
  bool get isLoading => _isLoading;

  Future<void> getTrendingWallpapers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {"Authorization": apiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final wallMuse = WallMuse.fromJson(data);
        _images = wallMuse.photos ?? [];
      }
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false; // Move this line outside of the try-catch block
    notifyListeners(); // Notify listeners after updating the state
  }


  
  Future<void> loadMore() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      _page++;
      String pageurl = "https://api.pexels.com/v1/curated?per_page=80&page=$_page";

      var url = Uri.parse(pageurl);
      var response = await http.get(url, headers: {"Authorization": apiKey});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final wallMuse = WallMuse.fromJson(data);
        _images.addAll(wallMuse.photos ?? []);
      }
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false; // Move this line outside of the try-catch block
    notifyListeners(); // Notify listeners after updating the state
  }
}
