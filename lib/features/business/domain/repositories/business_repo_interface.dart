import 'package:chefstation_multivendor/features/business/domain/models/business_plan_body.dart';
import 'package:chefstation_multivendor/interface/repository_interface.dart';
import 'package:get/get_connect/connect.dart';

abstract class BusinessRepoInterface<T> implements RepositoryInterface<T> {
  Future<Response> setUpBusinessPlan(BusinessPlanBody businessPlanBody);
  Future<Response> subscriptionPayment(String id, String? paymentName);
}
