import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/API/api.dart';
import 'package:wallpaper_app/MODEL/wall_muse_model.dart';

class SearchProvider with ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  int page = 1;
  String _searchQuery = '';
  List<Photos> _searchResults = [];
  bool _loading = false;
  String _error = '';

  String get searchQuery => _searchQuery;
  List<Photos> get searchResults => _searchResults;
  bool get loading => _loading;
  String get error => _error;

  set searchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  final _debounce = Debouncer(milliseconds: 500);

  Future<void> debouncedSearch(String query) async {
    _debounce.run(() {
      searchQuery = query;
      if (query.isNotEmpty) {
        searchPhotos(query);
      } else {
        clearSearch();
      }
    });
  }

  Future<void> searchPhotos(String query) async {
    _loading = true;
    _error = '';
    notifyListeners();

    final response = await http.get(
      Uri.parse(
          "https://api.pexels.com/v1/search?query=$query&per_page=80&page=$page"),
      headers: {"Authorization": apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final wallMuse = WallMuse.fromJson(data);
      _searchResults = wallMuse.photos ?? [];
    } else {
      _error = "Failed to load search results";
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> loadMorePages() async {
    page++;
    String searchPageUrl =
        "https://api.pexels.com/v1/search?query=$_searchQuery&per_page=80&page=$page";

    var url = Uri.parse(searchPageUrl);
    var response = await http.get(url, headers: {"Authorization": apiKey});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final wallMuse = WallMuse.fromJson(data);
      _searchResults.addAll(wallMuse.photos ?? []);
    } else {
      _error = "Failed to load more pages";
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults.clear();
    _error = '';
    _loading = false;
    notifyListeners();
  }
}

class Debouncer {
  final int milliseconds;
  late VoidCallback action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
