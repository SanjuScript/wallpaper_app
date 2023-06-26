import 'package:wallpaper_app/model/catagoriesModel.dart';

//api key

String apiKey = "vkSlU8nE5cdTTJBhhfiZmYouo5Nfy0UOgolkHFPTOJ86IKU4jruiHwBl";

//catogory model function

List<CatorgoriModel> getCatogories() {
  List<CatorgoriModel> catogories = <CatorgoriModel>[];
  CatorgoriModel catorgoriModel = CatorgoriModel();

  catorgoriModel.imgUrl =
      "https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg?auto=compress&cs=tinysrgb&w=600";
  catorgoriModel.catogoriName = "Nature";
  catogories.add(catorgoriModel);
  catorgoriModel = CatorgoriModel();

  catorgoriModel.imgUrl =
      "https://images.pexels.com/photos/397857/pexels-photo-397857.jpeg?auto=compress&cs=tinysrgb&w=600";
  catorgoriModel.catogoriName = "Wild life";
  catogories.add(catorgoriModel);
  catorgoriModel = CatorgoriModel();

  catorgoriModel.imgUrl =
      "https://images.pexels.com/photos/3010168/pexels-photo-3010168.jpeg?auto=compress&cs=tinysrgb&w=600";
  catorgoriModel.catogoriName = "Solid";
  catogories.add(catorgoriModel);
  catorgoriModel = CatorgoriModel();

  catorgoriModel.imgUrl =
      "https://images.pexels.com/photos/3156482/pexels-photo-3156482.jpeg?auto=compress&cs=tinysrgb&w=600";
  catorgoriModel.catogoriName = "Cars";
  catogories.add(catorgoriModel);
  catorgoriModel = CatorgoriModel();

  catorgoriModel.imgUrl =
      "https://images.pexels.com/photos/2387877/pexels-photo-2387877.jpeg?auto=compress&cs=tinysrgb&w=600";
  catorgoriModel.catogoriName = "Night";
  catogories.add(catorgoriModel);
  catorgoriModel = CatorgoriModel();

  catorgoriModel.imgUrl =
      "https://images.pexels.com/photos/302896/pexels-photo-302896.jpeg?auto=compress&cs=tinysrgb&w=600";
  catorgoriModel.catogoriName = "Coffee";
  catogories.add(catorgoriModel);
  catorgoriModel = CatorgoriModel();

  return catogories;
}
