import 'dart:convert';

import 'package:chefstation_multivendor/api/local_client.dart';
import 'package:chefstation_multivendor/common/enums/data_source_enum.dart';
import 'package:chefstation_multivendor/common/models/product_model.dart';
import 'package:chefstation_multivendor/api/api_client.dart';
import 'package:chefstation_multivendor/features/product/domain/models/basic_campaign_model.dart';
import 'package:chefstation_multivendor/features/product/domain/repositories/campaign_repository_interface.dart';
import 'package:chefstation_multivendor/util/app_constants.dart';
import 'package:get/get_connect.dart';

class CampaignRepository implements CampaignRepositoryInterface {
  final ApiClient apiClient;

  CampaignRepository({required this.apiClient});

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future<BasicCampaignModel?> get(String? id) {
    return _getCampaignDetails(id!);
  }

  Future<BasicCampaignModel?> _getCampaignDetails(String campaignID) async {
    BasicCampaignModel? campaign;
    Response response = await apiClient.getData('${AppConstants.basicCampaignDetailsUri}$campaignID');
    if (response.statusCode == 200) {
      campaign = BasicCampaignModel.fromJson(response.body);
    }
    return campaign;
  }

  @override
  Future<dynamic> getList({int? offset, bool basicCampaign = false, DataSourceEnum? source}) {
   if(basicCampaign) {
     return _getBasicCampaignList();
   } else {
     return _getItemCampaignList(source: source);
   }
  }
  Future<List<BasicCampaignModel>?> _getBasicCampaignList() async {
    List<BasicCampaignModel>? basicCampaignList;
    Response response = await apiClient.getData(AppConstants.basicCampaignUri);
    if (response.statusCode == 200) {
      basicCampaignList = [];
      response.body.forEach((campaign) => basicCampaignList!.add(BasicCampaignModel.fromJson(campaign)));
    }
    return basicCampaignList;
  }

  Future<List<Product>?> _getItemCampaignList({DataSourceEnum? source}) async {
    List<Product>? itemCampaignList;
    String cacheId = AppConstants.itemCampaignUri;

    switch(source!){
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.itemCampaignUri);
        if(response.statusCode == 200){
          itemCampaignList = [];
          response.body.forEach((campaign) => itemCampaignList!.add(Product.fromJson(campaign)));
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }
      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          itemCampaignList = [];
          jsonDecode(cacheResponseData).forEach((campaign) {
            itemCampaignList!.add(Product.fromJson(campaign));
          });
        }
    }
    return itemCampaignList;
  }


  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}
