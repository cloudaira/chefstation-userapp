import 'package:chefstation_multivendor/api/api_client.dart';
import 'package:chefstation_multivendor/features/auth/domain/repositories/restaurant_registration_repo_interface.dart';
import 'package:chefstation_multivendor/features/business/domain/models/package_model.dart';
import 'package:chefstation_multivendor/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantRegistrationRepo implements RestaurantRegistrationRepoInterface {
  final ApiClient apiClient;

  RestaurantRegistrationRepo({required this.apiClient});

  @override
  Future<Response> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument) async {
    return await apiClient.postMultipartData(
      AppConstants.restaurantRegisterUri, data, [MultipartBody('logo', logo), MultipartBody('cover_photo', cover)], additionalDocument,
    );
  }

  @override
  Future<bool> checkInZone(String? lat, String? lng, int zoneId) async {
    Response response = await apiClient.getData('${AppConstants.checkZoneUri}?lat=$lat&lng=$lng&zone_id=$zoneId');
    if(response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }

  @override
  Future<PackageModel?> getList({int? offset}) async {
    PackageModel? packageModel;
    Response response = await apiClient.getData(AppConstants.restaurantPackagesUri);
    if(response.statusCode == 200) {
      packageModel = PackageModel.fromJson(response.body);
    }
    return packageModel;
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
}
