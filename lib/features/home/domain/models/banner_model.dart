import 'package:chefstation_multivendor/features/product/domain/models/basic_campaign_model.dart';
import 'package:chefstation_multivendor/common/models/product_model.dart';
import 'package:chefstation_multivendor/common/models/restaurant_model.dart';

class BannerModel {
  List<BasicCampaignModel>? campaigns;
  List<Banner>? banners;

  BannerModel({this.campaigns, this.banners});

  BannerModel.fromJson(Map<String, dynamic> json) {
    if (json['campaigns'] != null) {
      campaigns = [];
      json['campaigns'].forEach((v) {
        campaigns!.add(BasicCampaignModel.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners!.add(Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (campaigns != null) {
      data['campaigns'] = campaigns!.map((v) => v.toJson()).toList();
    }
    if (banners != null) {
      data['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  int? id;
  String? title;
  String? type;
  String? imageFullUrl;
  Restaurant? restaurant;
  Product? food;

  Banner({
    this.id,
    this.title,
    this.type,
    this.imageFullUrl,
    this.restaurant,
    this.food,
  });

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    imageFullUrl = json['image_full_url'];
    restaurant = json['restaurant'] != null ? Restaurant.fromJson(json['restaurant']) : null;
    food = json['food'] != null ? Product.fromJson(json['food']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['image_full_url'] = imageFullUrl;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    if (food != null) {
      data['food'] = food!.toJson();
    }
    return data;
  }
}
