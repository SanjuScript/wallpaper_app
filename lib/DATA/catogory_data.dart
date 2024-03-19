import 'package:wallpaper_app/model/catagories_model.dart';

List<CatorgoriModel> getCatogories() {
  List<CatorgoriModel> categories = <CatorgoriModel>[];

  List<Map<String, String>> categoryData = [
    {
      "imgUrl":
          "https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg?auto=compress&cs=tinysrgb&w=600",
      "categoryName": "Nature"
    },
    {
      "imgUrl":
          "https://images.pexels.com/photos/397857/pexels-photo-397857.jpeg?auto=compress&cs=tinysrgb&w=600",
      "categoryName": "Wild life"
    },
    {
      "imgUrl":
          "https://images.pexels.com/photos/3010168/pexels-photo-3010168.jpeg?auto=compress&cs=tinysrgb&w=600",
      "categoryName": "Solid"
    },
    {
      "imgUrl":
          "https://images.pexels.com/photos/3156482/pexels-photo-3156482.jpeg?auto=compress&cs=tinysrgb&w=600",
      "categoryName": "Cars"
    },
    {
      "imgUrl":
          "https://images.pexels.com/photos/2387877/pexels-photo-2387877.jpeg?auto=compress&cs=tinysrgb&w=600",
      "categoryName": "Night"
    },
    {
      "imgUrl":
          "https://images.pexels.com/photos/302896/pexels-photo-302896.jpeg?auto=compress&cs=tinysrgb&w=600",
      "categoryName": "Coffee"
    },
  ];

  for (var data in categoryData) {
    categories.add(
      CatorgoriModel(
        imgUrl: data["imgUrl"]!,
        catogoriName: data["categoryName"]!,
      ),
    );
  }
  return categories;
}
