import 'dart:convert';
import 'package:get/get.dart';
import 'package:chefstation_multivendor/common/models/online_cart_model.dart';
import 'package:chefstation_multivendor/api/api_client.dart';
import 'package:chefstation_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:chefstation_multivendor/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:chefstation_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:chefstation_multivendor/util/app_constants.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository implements CartRepositoryInterface<OnlineCart> {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  CartRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Response> addMultipleCartItemOnline(List<OnlineCart> carts) async {
    // List<OnlineCartModel> onlineCartList = [];
    List<Map<String, dynamic>> cartList = [];
    for (var cart in carts) {
      cartList.add(cart.toJson());
    }
    Response response = await apiClient.postData(AppConstants.addMultipleItemCartUri, {'item_list': cartList});
    // if(response.statusCode == 200) {
    //   onlineCartList = [];
    //   response.body.forEach((cart) => onlineCartList.add(OnlineCartModel.fromJson(cart)));
    // }
    return response;
  }

  @override
  void addToSharedPrefCartList(List<CartModel> cartProductList) {
    List<String> carts = [];
    for (var cartModel in cartProductList) {
      carts.add(jsonEncode(cartModel));
    }
    sharedPreferences.setStringList(AppConstants.cartList, carts);
  }

  @override
  Future<bool> clearCartOnline(String? guestId) async {
    Response response = await apiClient.postData('${AppConstants.removeAllCartUri}${guestId != null ? '?guest_id=$guestId' : ''}', {"_method": "delete"});
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateCartQuantityOnline(int cartId, double price, int quantity, String? guestId) async {
    Map<String, dynamic> data = {
      "cart_id": cartId,
      "price": price,
      "quantity": quantity,
    };
    Response response = await apiClient.postData('${AppConstants.updateCartUri}${guestId != null ? '?guest_id=$guestId' : ''}', data);
    return (response.statusCode == 200);
  }

  ///Add To Cart Online
  @override
  Future<Response> addToCartOnline(OnlineCart cart, String? guestId) async {
    Response response = await apiClient.postData('${AppConstants.addCartUri}${guestId != null ? '?guest_id=$guestId' : ''}', cart.toJson(), handleError: false);
    return response;
  }

  @override
  Future<bool> delete(int? id, {String? guestId}) async {
    Response response = await apiClient.postData('${AppConstants.removeItemCartUri}?cart_id=$id${guestId != null ? '&guest_id=$guestId' : ''}', {"_method": "delete"});
    return (response.statusCode == 200);
  }

  @override
  Future<List<OnlineCartModel>> get(String? id) async {
    List<OnlineCartModel> onlineCartList = [];
    Response response = await apiClient.getData('${AppConstants.getCartListUri}${id != null ? '?guest_id=$id' : ''}');
    if(response.statusCode == 200) {
      onlineCartList = [];
      response.body.forEach((cart) => onlineCartList.add(OnlineCartModel.fromJson(cart)));
    }
    return onlineCartList;
  }

  @override
  Future getList({int? offset}) async {
    // Implementation for getting cart list - typically not needed for customer app
    // This method is part of the interface but not used in customer context
    return Future.value();
  }

  @override
  Future<Response> update(Map<String, dynamic> cart, int? id) async {
    return await _updateCartOnline(cart, id);
  }

  Future<Response> _updateCartOnline(Map<String, dynamic> cart, int? guestId) async {
    Response response = await apiClient.postData('${AppConstants.updateCartUri}${guestId != null ? '?guest_id=$guestId' : ''}', cart, handleError: false);
    return response;
  }

  @override
  Future add(OnlineCart value) async {
    // Implementation for adding cart items - typically not needed for customer app
    // This method is part of the interface but not used in customer context
    return Future.value();
  }

  
}
