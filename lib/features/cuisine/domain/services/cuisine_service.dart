import 'package:chefstation_multivendor/common/enums/data_source_enum.dart';
import 'package:chefstation_multivendor/features/cuisine/domain/models/cuisine_model.dart';
import 'package:chefstation_multivendor/features/cuisine/domain/models/cuisine_restaurants_model.dart';
import 'package:chefstation_multivendor/features/cuisine/domain/repositories/cuisine_repository_interface.dart';
import 'package:chefstation_multivendor/features/cuisine/domain/services/cuisine_service_interface.dart';

class CuisineService implements CuisineServiceInterface {
  final CuisineRepositoryInterface cuisineRepositoryInterface;
  CuisineService({required this.cuisineRepositoryInterface});

  @override
  Future<CuisineModel?> getCuisineList({DataSourceEnum? source}) async {
    return await cuisineRepositoryInterface.getList(source: source!);
  }

  @override
  List<int?> generateCuisineIds(CuisineModel? cuisineModel) {
    List<int?> cuisineIds = [];
    if(cuisineModel != null) {
      cuisineIds.add(0);
      for (var cuisine in cuisineModel.cuisines!) {
        cuisineIds.add(cuisine.id);
      }
    }
    return cuisineIds;
  }

  @override
  Future<CuisineRestaurantModel?> getRestaurantList(int offset, int cuisineId) async {
    return await cuisineRepositoryInterface.getRestaurantList(offset, cuisineId);
  }
}
