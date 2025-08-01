import 'package:chefstation_multivendor/common/enums/data_source_enum.dart';
import 'package:chefstation_multivendor/common/models/product_model.dart';
import 'package:chefstation_multivendor/common/models/response_model.dart';
import 'package:chefstation_multivendor/common/models/review_model.dart';
import 'package:chefstation_multivendor/features/product/domain/models/review_body_model.dart';

abstract class ReviewServiceInterface {

  Future<List<Product>?> getReviewedProductList({required String type, DataSourceEnum? source});
  Future<ResponseModel> submitProductReview(ReviewBodyModel reviewBody);
  Future<ResponseModel> submitDeliverymanReview(ReviewBodyModel reviewBody);
  Future<List<ReviewModel>?> getRestaurantReviewList(String? restaurantID);
}
