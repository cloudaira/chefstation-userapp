import 'package:chefstation_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:chefstation_multivendor/features/coupon/domain/models/coupon_model.dart';
import 'package:chefstation_multivendor/features/coupon/domain/models/customer_coupon_model.dart';
import 'package:chefstation_multivendor/features/coupon/domain/services/coupon_service_interface.dart';
import 'package:chefstation_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:chefstation_multivendor/helper/price_converter.dart';
import 'package:chefstation_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';

class CouponController extends GetxController implements GetxService {
  final CouponServiceInterface couponServiceInterface;
  CouponController({required this.couponServiceInterface});

  List<CouponModel>? _couponList;
  List<CouponModel>? get couponList => _couponList;

  CustomerCouponModel? _customerCouponModel;
  CustomerCouponModel? get customerCouponModel => _customerCouponModel;

  CouponModel? _coupon;
  CouponModel? get coupon => _coupon;

  double? _discount = 0.0;
  double? get discount => _discount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _freeDelivery = false;
  bool get freeDelivery => _freeDelivery;

  String? _checkoutCouponCode = '';
  String? get checkoutCouponCode => _checkoutCouponCode;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Future<void> getCouponList({int? restaurantId, int? orderRestaurantId, double? orderAmount}) async {
    if(Get.find<ProfileController>().userInfoModel == null){
      await Get.find<ProfileController>().getUserInfo();
    }
    _customerCouponModel = await couponServiceInterface.getCouponList(customerId: Get.find<ProfileController>().userInfoModel!.id, restaurantId: restaurantId, orderRestaurantId: orderRestaurantId, orderAmount: orderAmount);
    update();
  }

  Future<void> getRestaurantCouponList({required int restaurantId}) async {
    _couponList = await couponServiceInterface.getRestaurantCouponList(restaurantId: restaurantId);
    update();
  }

  Future<double?> applyCoupon(String coupon, double order, double deliveryCharge, double charge, double total, int? restaurantID, {bool hideBottomSheet = false}) async {
    _isLoading = true;
    _discount = 0;
    update();
    Response response = await couponServiceInterface.applyCoupon(couponCode: coupon, restaurantID: restaurantID, orderAmount: total);
    if (response.statusCode == 200) {
      _coupon = CouponModel.fromJson(response.body);
      if(_coupon!.couponType == 'free_delivery') {
        _processFreeDeliveryCoupon(deliveryCharge, order);
      } else {
        _processCoupon(order);
      }
    } else {
      _discount = 0.0;
      if(Get.find<CheckoutController>().isPartialPay || Get.find<CheckoutController>().paymentMethodIndex == 1) {
        Get.find<CheckoutController>().checkBalanceStatus(total);
      }
    }
    if((Get.isBottomSheetOpen! || Get.isDialogOpen!) && hideBottomSheet) {
      Get.back();
    }
    _isLoading = false;
    update();
    return _discount;
  }

  _processFreeDeliveryCoupon(double deliveryCharge, double order) {
    if(deliveryCharge > 0) {
      if (_coupon!.minPurchase! < order) {
        _discount = 0;
        _freeDelivery = true;
      } else {
        showCustomSnackBar('${'the_minimum_item_purchase_amount_for_this_coupon_is'.tr} '
            '${PriceConverter.convertPrice(_coupon!.minPurchase)} '
            '${'but_you_have'.tr} ${PriceConverter.convertPrice(order)}',
        );
        _coupon = null;
        _discount = 0;
      }
    } else {
      showCustomSnackBar('invalid_code_or'.tr);
    }
  }

  _processCoupon(double order) {
    if (_coupon!.minPurchase != null && _coupon!.minPurchase! < order) {
      if (_coupon!.discountType == 'percent') {
        if (_coupon!.maxDiscount != null && _coupon!.maxDiscount! > 0) {
          _discount = (_coupon!.discount! * order / 100) < _coupon!.maxDiscount! ? (_coupon!.discount! * order / 100) : _coupon!.maxDiscount;
        } else {
          _discount = _coupon!.discount! * order / 100;
        }
      } else {
        if(_coupon!.discount! > order) {
          _discount = order;
        } else {
          _discount = _coupon!.discount;
        }
      }
    } else {
      _discount = 0.0;
      showCustomSnackBar('${'the_minimum_item_purchase_amount_for_this_coupon_is'.tr} '
          '${PriceConverter.convertPrice(_coupon!.minPurchase)} '
          '${'but_you_have'.tr} ${PriceConverter.convertPrice(order)}',
      );
    }
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;
    _freeDelivery = false;
    if(notify) {
      update();
    }
  }

  void setCoupon(String? code, {isUpdate = true}){
    _checkoutCouponCode = code;
    if(isUpdate) {
      update();
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }
}
