import 'dart:convert';

import 'package:block_test_app/models/category_model.dart';

class ProductModule {
  int? id;
  String? title;
  int? price;
  String? description;
  List<String>? images;
  String? creationAt;
  String? updatedAt;
  CategoryModel? category;
  bool? _isFav;

  bool get isFavorite => _isFav ?? false;

  set setFav(bool value) => _isFav = value;

  ProductModule(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.images,
      this.creationAt,
      this.updatedAt,
      this.category})
      : _isFav = false;

  ProductModule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    images = json['images'].cast<String>();
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
    _isFav = false;
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['images'] = images;
    data['creationAt'] = creationAt;
    data['updatedAt'] = updatedAt;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }

  String encode(List<ProductModule> products) => json.encode(
        products
            .map<Map<String, dynamic>>((product) => product.toJson())
            .toList(),
      );

  List<ProductModule> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<ProductModule>((item) => ProductModule.fromJson(item))
          .toList();
}
