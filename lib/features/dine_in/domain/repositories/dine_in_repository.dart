import 'package:get/get.dart';
import 'package:chefstation_multivendor/api/api_client.dart';
import 'package:chefstation_multivendor/features/dine_in/domain/model/dine_in_model.dart';
import 'package:chefstation_multivendor/features/dine_in/domain/repositories/dine_in_repository_interface.dart';
import 'package:chefstation_multivendor/util/app_constants.dart';

class DineInRepository implements DineInRepositoryInterface {
  final ApiClient apiClient;
  DineInRepository({required this.apiClient});

  @override
  Future<DineInModel?> getRestaurantList({int? offset, required bool isDistance, required bool isRating, required bool isVeg, required bool isNonVeg, required bool isDiscounted, required List<int> selectedCuisines}) async {
    DineInModel? dineInModel;
    Response response = await apiClient.getData('${AppConstants.dineInRestaurantListUri}?offset=$offset&limit=10&sort_by=${isDistance ? 'distance' : isRating ? 'rating' : ''}&veg=${isVeg ? 1 : 0}&non_veg=${isNonVeg ? 1 : 0}&discount=${isDiscounted ? 1 : 0}&cuisine=$selectedCuisines');
    if (response.statusCode == 200) {
      dineInModel = DineInModel.fromJson(response.body);
    }
    return dineInModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) async {
    // Implementation for getting dine-in list - typically not needed for customer app
    // This method is part of the interface but not used in customer context
    return Future.value();
  }

}
