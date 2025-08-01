import 'dart:convert';
import 'package:chefstation_multivendor/common/widgets/image_viewer_screen_widget.dart';
import 'package:chefstation_multivendor/common/widgets/not_found_widget.dart';
import 'package:chefstation_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:chefstation_multivendor/features/auth/screens/new_user_setup_screen.dart';
import 'package:chefstation_multivendor/features/business/screens/subscription_payment_screen.dart';
import 'package:chefstation_multivendor/features/business/screens/subscription_success_or_failed_screen.dart';
import 'package:chefstation_multivendor/features/cart/screens/cart_screen.dart';
import 'package:chefstation_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:chefstation_multivendor/features/checkout/domain/models/pricing_view_model.dart';
import 'package:chefstation_multivendor/features/checkout/screens/checkout_screen.dart';
import 'package:chefstation_multivendor/features/checkout/screens/offline_payment_screen.dart';
import 'package:chefstation_multivendor/features/checkout/screens/order_successful_screen.dart';
import 'package:chefstation_multivendor/features/checkout/screens/payment_screen.dart';
import 'package:chefstation_multivendor/features/checkout/screens/payment_webview_screen.dart';
import 'package:chefstation_multivendor/features/dine_in/screens/dine_in_restaurant_screen.dart';
import 'package:chefstation_multivendor/features/favourite/screens/favourite_screen.dart';
import 'package:chefstation_multivendor/features/home/screens/map_view_screen.dart';
import 'package:chefstation_multivendor/features/html/enums/html_type.dart';
import 'package:chefstation_multivendor/features/html/screens/html_viewer_screen.dart';
import 'package:chefstation_multivendor/features/language/screens/language_screen.dart';
import 'package:chefstation_multivendor/features/location/screens/access_location_screen.dart';
import 'package:chefstation_multivendor/features/location/screens/map_screen.dart';
import 'package:chefstation_multivendor/features/location/screens/pick_map_screen.dart';
import 'package:chefstation_multivendor/features/notification/domain/models/notification_body_model.dart';
import 'package:chefstation_multivendor/features/notification/screens/notification_screen.dart';
import 'package:chefstation_multivendor/features/onboard/screens/onboarding_screen.dart';
import 'package:chefstation_multivendor/features/order/screens/guest_track_order_screen.dart';
import 'package:chefstation_multivendor/features/order/screens/order_details_screen.dart';
import 'package:chefstation_multivendor/features/order/screens/order_screen.dart';
import 'package:chefstation_multivendor/features/order/screens/order_tracking_screen.dart';
import 'package:chefstation_multivendor/features/order/screens/refund_request_screen.dart';
import 'package:chefstation_multivendor/features/profile/domain/models/update_user_model.dart';
import 'package:chefstation_multivendor/features/profile/screens/profile_screen.dart';
import 'package:chefstation_multivendor/features/profile/screens/update_profile_screen.dart';
import 'package:chefstation_multivendor/features/refer%20and%20earn/screens/refer_and_earn_screen.dart';
import 'package:chefstation_multivendor/features/restaurant/screens/all_restaurant_screen.dart';
import 'package:chefstation_multivendor/features/restaurant/screens/campaign_screen.dart';
import 'package:chefstation_multivendor/features/restaurant/screens/restaurant_product_search_screen.dart';
import 'package:chefstation_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:chefstation_multivendor/features/review/domain/models/rate_review_model.dart';
import 'package:chefstation_multivendor/features/review/screens/rate_review_screen.dart';
import 'package:chefstation_multivendor/features/review/screens/review_screen.dart';
import 'package:chefstation_multivendor/features/search/screens/search_screen.dart';
import 'package:chefstation_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:chefstation_multivendor/features/address/domain/models/address_model.dart';
import 'package:chefstation_multivendor/features/product/domain/models/basic_campaign_model.dart';
import 'package:chefstation_multivendor/features/order/domain/models/order_model.dart';
import 'package:chefstation_multivendor/common/models/product_model.dart';
import 'package:chefstation_multivendor/common/models/restaurant_model.dart';
import 'package:chefstation_multivendor/features/address/screens/add_address_screen.dart';
import 'package:chefstation_multivendor/features/address/screens/address_screen.dart';
import 'package:chefstation_multivendor/features/auth/screens/delivery_man_registration_screen.dart';
import 'package:chefstation_multivendor/features/auth/screens/restaurant_registration_screen.dart';
import 'package:chefstation_multivendor/features/auth/screens/sign_in_screen.dart';
import 'package:chefstation_multivendor/features/auth/screens/sign_up_screen.dart';
import 'package:chefstation_multivendor/features/category/screens/category_product_screen.dart';
import 'package:chefstation_multivendor/features/category/screens/category_screen.dart';
import 'package:chefstation_multivendor/features/chat/domain/models/conversation_model.dart';
import 'package:chefstation_multivendor/features/chat/screens/chat_screen.dart';
import 'package:chefstation_multivendor/features/chat/screens/conversation_screen.dart';
import 'package:chefstation_multivendor/features/coupon/screens/coupon_screen.dart';
import 'package:chefstation_multivendor/features/cuisine/screens/cuisine_restaurant_screen.dart';
import 'package:chefstation_multivendor/features/cuisine/screens/cuisine_screen.dart';
import 'package:chefstation_multivendor/features/dashboard/screens/dashboard_screen.dart';
import 'package:chefstation_multivendor/features/interest/screens/interest_screen.dart';
import 'package:chefstation_multivendor/features/loyalty/screens/loyalty_screen.dart';
import 'package:chefstation_multivendor/features/product/screens/item_campaign_screen.dart';
import 'package:chefstation_multivendor/features/product/screens/popular_food_screen.dart';
import 'package:chefstation_multivendor/features/splash/domain/models/deep_link_body.dart';
import 'package:chefstation_multivendor/features/splash/screens/splash_screen.dart';
import 'package:chefstation_multivendor/features/support/screens/support_screen.dart';
import 'package:chefstation_multivendor/features/update/screens/update_screen.dart';
import 'package:chefstation_multivendor/features/verification/screens/forget_pass_screen.dart';
import 'package:chefstation_multivendor/features/verification/screens/new_pass_screen.dart';
import 'package:chefstation_multivendor/features/verification/screens/verification_screen.dart';
import 'package:chefstation_multivendor/features/wallet/screens/wallet_screen.dart';
import 'package:chefstation_multivendor/helper/address_helper.dart';
import 'package:chefstation_multivendor/helper/maintance_helper.dart';
import 'package:chefstation_multivendor/util/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta_seo/meta_seo.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String onBoarding = '/on-boarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String verification = '/verification';
  static const String accessLocation = '/access-location';
  static const String pickMap = '/pick-map';
  static const String interest = '/interest';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String search = '/search';
  static const String restaurant = '/restaurant';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String coupon = '/coupon';
  static const String notification = '/notification';
  static const String map = '/map';
  static const String address = '/address';
  static const String orderSuccess = '/order-successful';
  static const String payment = '/payment';
  static const String checkout = '/checkout';
  static const String orderTracking = '/track-order';
  static const String basicCampaign = '/basic-campaign';
  static const String html = '/html-screen';
  static const String categories = '/categories';
  static const String categoryProduct = '/category-product';
  static const String popularFoods = '/popular-foods';
  static const String itemCampaign = '/item-campaign';
  static const String support = '/help-and-support';
  static const String rateReview = '/rate-and-review';
  static const String update = '/update';
  static const String cart = '/cart';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String restaurantReview = '/restaurant-review';
  static const String allRestaurants = '/restaurants';
  static const String wallet = '/wallet';
  static const String loyalty = '/loyalty';
  static const String searchRestaurantItem = '/search-Restaurant-item';
  static const String productImages = '/product-images';
  static const String referAndEarn = '/refer-and-earn';
  static const String messages = '/messages';
  static const String conversation = '/conversation';
  static const String mapView = '/map-view';
  static const String restaurantRegistration = '/restaurant-registration';
  static const String deliveryManRegistration = '/delivery-man-registration';
  static const String refund = '/refund';
  static const String order = '/order';
  static const String cuisine = '/cuisine';
  static const String cuisineRestaurant = '/cuisine-restaurant';
  static const String subscriptionSuccess = '/subscription-success';
  static const String subscriptionPayment = '/subscription-payment';
  static const String offlinePaymentScreen = '/offline-payment-screen';
  static const String guestTrackOrderScreen = '/guest-track-order-screen';
  static const String favourite = '/favourite-screen';
  static const String newUserSetupScreen = '/new-user-setup-screen';
  static const String dineInRestaurant = '/dine-in-restaurant';

  static String getInitialRoute({bool fromSplash = false}) => '$initial?from-splash=$fromSplash';
  static String getSplashRoute(NotificationBodyModel? body, DeepLinkBody? linkBody) {
    String data = 'null';
    String linkData = 'null';
    if(body != null) {
      List<int> encoded = utf8.encode(jsonEncode(body.toJson()));
      data = base64Encode(encoded);
    }
    if(linkBody != null) {
      List<int> encoded = utf8.encode(jsonEncode(linkBody.toJson()));
      linkData = base64Encode(encoded);
    }
    return '$splash?data=$data&link=$linkData';
  }
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getOnBoardingRoute() => onBoarding;
  static String getSignInRoute(String page) => '$signIn?page=$page';
  static String getSignUpRoute() => signUp;
  static String getVerificationRoute(String? number, String? email, String? token, String page, String? pass, String loginType, {String? session, UpdateUserModel? updateUserModel}) {
    String? authSession;
    String? userModel;
    if(session != null) {
      authSession = base64Url.encode(utf8.encode(session));
    }
    if(updateUserModel != null) {
      List<int> encoded = utf8.encode(jsonEncode(updateUserModel.toJson()));
      userModel = base64Encode(encoded);
    }
    return '$verification?page=$page&number=$number&email=$email&token=$token&pass=$pass&login_type=$loginType&session=$authSession&user_model=$userModel';
  }
  static String getAccessLocationRoute(String page) => '$accessLocation?page=$page';
  static String getPickMapRoute(String? page, bool canRoute) => '$pickMap?page=$page&route=${canRoute.toString()}';
  static String getInterestRoute() => interest;
  static String getMainRoute(String page) => '$main?page=$page';
  static String getForgotPassRoute() => forgotPassword;
  static String getResetPasswordRoute(String? phone, String token, String page) => '$resetPassword?phone=$phone&token=$token&page=$page';
  static String getSearchRoute() => search;
  static String getRestaurantRoute(int? id, {bool fromDinIn = false}) {
    if(kIsWeb) {
      // Define MetaSEO object
      MetaSEO meta = MetaSEO();
      // add meta seo data for web app as you want
      meta.ogTitle(ogTitle: 'Store Screen');
      meta.description(description: 'This is Store screen. Here have all information of store');
      meta.keywords(keywords: 'Flutter, Dart, SEO, Meta, Web');
    }
    return '$restaurant?id=$id&from_dine_in=$fromDinIn';
  }
  static String getOrderDetailsRoute(int? orderID, {bool? fromOffline, String? contactNumber, bool fromGuestTrack = false, bool fromNotification = false, bool? fromDineIn}) {
    return '$orderDetails?id=$orderID&from_offline=$fromOffline&contact=$contactNumber&from_guest_track=$fromGuestTrack&from_notification=$fromNotification&from_dine_in=$fromDineIn';
  }
  static String getProfileRoute() => profile;
  static String getUpdateProfileRoute() => updateProfile;
  static String getCouponRoute({required bool fromCheckout}) => '$coupon?fromCheckout=${fromCheckout ? 'true' : 'false'}';
  static String getNotificationRoute({bool fromNotification = false}) => '$notification?fromNotification=${fromNotification.toString()}';
  static String getMapRoute(AddressModel addressModel, String page, {String? restaurantName, Restaurant? restaurant, bool? isDineOrder}) {
    List<int> encoded = utf8.encode(jsonEncode(addressModel.toJson()));
    String data = base64Encode(encoded);
    String? restaurantModel;
    if(restaurant != null) {
      List<int> encoded = utf8.encode(jsonEncode(restaurant.toJson()));
      restaurantModel = base64Encode(encoded);
    }
    return '$map?address=$data&page=$page&restaurantName=$restaurantName&restaurant=$restaurantModel&isDineOrder=${isDineOrder.toString()}';
  }
  static String getAddressRoute() => address;
  static String getOrderSuccessRoute(String orderID, String status, double? amount, String? contactNumber, {bool? isDeliveryOrder}) => '$orderSuccess?id=$orderID&status=$status&amount=$amount&contact_number=$contactNumber&is_delivery_order=$isDeliveryOrder';
  static String getPaymentRoute(OrderModel orderModel, String? paymentMethod, {String? addFundUrl, String? subscriptionUrl, required String guestId, String? contactNumber, int? restaurantId, int? packageId}) {
    String data = base64Encode(utf8.encode(jsonEncode(orderModel.toJson())));
    return '$payment?order=$data&payment-method=$paymentMethod&add-fund-url=$addFundUrl&subscription-url=$subscriptionUrl&guest-id=$guestId&number=$contactNumber&restaurant_id=$restaurantId&package_id=$packageId';
  }
  static String getCheckoutRoute(String page, {bool fromDineIn = false}) => '$checkout?page=$page&from_dine_in=$fromDineIn';
  static String getOrderTrackingRoute(int? id, String? contactNumber) => '$orderTracking?id=$id&contact_number=$contactNumber';
  static String getBasicCampaignRoute(BasicCampaignModel basicCampaignModel) {
    String data = base64Encode(utf8.encode(jsonEncode(basicCampaignModel.toJson())));
    return '$basicCampaign?data=$data';
  }
  static String getHtmlRoute(String page) => '$html?page=$page';
  static String getCategoryRoute() => categories;
  static String getCategoryProductRoute(int? id, String name) {
    List<int> encoded = utf8.encode(name);
    String data = base64Encode(encoded);
    return '$categoryProduct?id=$id&name=$data';
  }
  static String getPopularFoodRoute(bool isPopular, {bool fromIsRestaurantFood = false, int? restaurantId}) => '$popularFoods?page=${isPopular ? 'popular' : 'reviewed'}&fromIsRestaurantFood=$fromIsRestaurantFood&restaurant_id=$restaurantId';
  static String getItemCampaignRoute() => itemCampaign;
  static String getSupportRoute() => support;
  static String getReviewRoute(RateReviewModel rateReviewModel) {
    String data = base64Encode(utf8.encode(jsonEncode(rateReviewModel.toJson())));
    return '$rateReview?data=$data';
  }
  static String getUpdateRoute(bool isUpdate) => '$update?update=${isUpdate.toString()}';
  static String getCartRoute({bool fromReorder = false, bool fromDineIn = false}) => '$cart?from_reorder=$fromReorder&from_dine_in=$fromDineIn';
  static String getAddAddressRoute(bool fromCheckout, int? zoneId) => '$addAddress?page=${fromCheckout ? 'checkout' : 'address'}&zone_id=$zoneId';
  static String getEditAddressRoute(AddressModel? address, {bool fromGuest = false}) {
    String data = 'null';
    if(address != null) {
      data = base64Url.encode(utf8.encode(jsonEncode(address.toJson())));
    }
    return '$editAddress?data=$data&from-guest=$fromGuest';
  }
  static String getRestaurantReviewRoute(int? restaurantID, String? restaurantName, Restaurant restaurant) {
    String data = base64Url.encode(utf8.encode(jsonEncode(restaurant.toJson())));
    return '$restaurantReview?id=$restaurantID&restaurantName=$restaurantName&restaurant=$data';
  }
  static String getAllRestaurantRoute(String page) => '$allRestaurants?page=$page';
  static String getWalletRoute({String? fundStatus, bool? fromMenuPage, bool fromNotification = false}) => '$wallet?payment_status=$fundStatus&from_menu_page=$fromMenuPage&from_notification=$fromNotification';
  static String getLoyaltyRoute() => loyalty;
  static String getSearchRestaurantProductRoute(int? productID) => '$searchRestaurantItem?id=$productID';
  static String getItemImagesRoute(Product product) {
    String data = base64Url.encode(utf8.encode(jsonEncode(product.toJson())));
    return '$productImages?item=$data';
  }
  static String getReferAndEarnRoute() => referAndEarn;
  static String getChatRoute({required NotificationBodyModel? notificationBody, User? user, int? conversationID, int? index, bool fromNotification = false}) {
    String notificationBody0 = 'null';
    if(notificationBody != null) {
      notificationBody0 = base64Encode(utf8.encode(jsonEncode(notificationBody.toJson())));
    }
    String user0 = 'null';
    if(user != null) {
      user0 = base64Encode(utf8.encode(jsonEncode(user.toJson())));
    }
    return '$messages?notification=$notificationBody0&user=$user0&conversation_id=$conversationID&index=$index&fromNotification=${fromNotification.toString()}';
  }
  static String getConversationRoute() => conversation;
  static String getMapViewRoute({bool? fromDineInScreen}) => '$mapView?from_dine_in_screen=${fromDineInScreen.toString()}';
  static String getRestaurantRegistrationRoute() => restaurantRegistration;
  static String getDeliverymanRegistrationRoute() => deliveryManRegistration;
  static String getRefundRequestRoute(String orderID) => '$refund?id=$orderID';
  static String getOrderRoute() => order;
  static String getCuisineRoute() => cuisine;
  static String getCuisineRestaurantRoute(int? cuisineId, String? name) => '$cuisineRestaurant?id=$cuisineId&name=$name';
  static String getSubscriptionSuccessRoute({String? status, required bool fromSubscription, int? restaurantId, int? packageId}) => '$subscriptionSuccess?flag=$status&from_subscription=$fromSubscription&restaurant_id=$restaurantId&package_id=$packageId';
  static String getSubscriptionPaymentRoute({required int? restaurantId, required int? packageId}) => '$subscriptionPayment?restaurant-id=$restaurantId&package-id=$packageId';
  static String getOfflinePaymentScreen({
    required PlaceOrderBodyModel placeOrderBody, required int? zoneId, required double total, required double? maxCodOrderAmount, required bool fromCart,
    required bool? isCodActive, required PricingViewModel pricingView}) {
    List<int> encoded = utf8.encode(jsonEncode(placeOrderBody.toJson()));
    List<int> encoded2 = utf8.encode(jsonEncode(pricingView.toJson()));
    String data = base64Encode(encoded);
    String pricingData = base64Encode(encoded2);
    return '$offlinePaymentScreen?order_body=$data&zone_id=$zoneId&total=$total&max_cod_amount=$maxCodOrderAmount&from_cart=$fromCart&cod_active=$isCodActive&pricing_body=$pricingData';
  }
  static String getGuestTrackOrderScreen(String orderId, String number) => '$guestTrackOrderScreen?order_id=$orderId&number=$number';
  static String getFavouriteScreen() => favourite;
  static String getNewUserSetupScreen({required String name, required String loginType, required String? phone, required String? email}) {
    return '$newUserSetupScreen?name=$name&login_type=$loginType&phone=$phone&email=$email';
  }
  static String getDineInRestaurantScreen() => dineInRestaurant;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => getRoute(DashboardScreen(pageIndex: 0, fromSplash: (Get.parameters['from-splash'] == 'true')))),
    GetPage(name: splash, page: () {
      NotificationBodyModel? data;
      DeepLinkBody? linkData;
      if(Get.parameters['data'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['data'] != null ? Get.parameters['data']!.replaceAll(' ', '+') : '');
        data = NotificationBodyModel.fromJson(jsonDecode(utf8.decode(decode)));
      }
      if(Get.parameters['link'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['link']!.replaceAll(' ', '+'));
        linkData = DeepLinkBody.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return SplashScreen(notificationBody: data, linkBody: linkData);
    }),
    GetPage(name: language, page: () => LanguageScreen(fromMenu: Get.parameters['page'] == 'menu')),
    GetPage(name: onBoarding, page: () => OnBoardingScreen()),
    GetPage(name: signIn, page: () => SignInScreen(
      exitFromApp: Get.parameters['page'] == signUp || Get.parameters['page'] == splash || Get.parameters['page'] == onBoarding,
      backFromThis: Get.parameters['page'] != splash && Get.parameters['page'] != onBoarding,
      fromResetPassword: Get.parameters['page'] == resetPassword,
    )),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    GetPage(name: verification, page: () {
      String? pass;
      if(Get.parameters['pass'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['pass']!.replaceAll(' ', '+'));
        pass = utf8.decode(decode);
      }
      String? session;
      if(Get.parameters['session'] != null && Get.parameters['session'] != 'null') {
        session = utf8.decode(base64Url.decode(Get.parameters['session'] ?? ''));
      }
      UpdateUserModel? userModel;
      if(Get.parameters['user_model'] != null && Get.parameters['user_model'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['user_model'] != null ? Get.parameters['user_model']!.replaceAll(' ', '+') : '');
        userModel = UpdateUserModel.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return VerificationScreen(
        number: Get.parameters['number'] != '' && Get.parameters['number'] != 'null' ? Get.parameters['number'] : null,
        fromSignUp: Get.parameters['page'] == signUp, token: Get.parameters['token'], password: pass,
        email: Get.parameters['email'] != '' && Get.parameters['email'] != 'null' ? Get.parameters['email'] : null, loginType: Get.parameters['login_type']!,
        firebaseSession: session, fromForgetPassword: Get.parameters['page'] == forgotPassword, userModel: userModel,
      );
    }),
    GetPage(name: accessLocation, page: () => AccessLocationScreen(
      fromSignUp: Get.parameters['page'] == signUp, fromHome: Get.parameters['page'] == 'home', route: null,
    )),
    GetPage(name: pickMap, page: () {
      PickMapScreen? pickMapScreen = Get.arguments;
      bool fromAddress = Get.parameters['page'] == 'add-address';
      return (fromAddress && pickMapScreen == null) ? const NotFoundWidget() : (pickMapScreen ?? PickMapScreen(
        fromSignUp: Get.parameters['page'] == signUp, fromSplash: Get.parameters['page'] == splash,
        fromAddAddress: fromAddress, route: Get.parameters['page'], canRoute: Get.parameters['route'] == 'true',
      ));
    }),
    GetPage(name: interest, page: () => const InterestScreen()),
    GetPage(name: main, page: () => getRoute(DashboardScreen(
      pageIndex: Get.parameters['page'] == 'home' ? 0 : Get.parameters['page'] == 'favourite' ? 1
          : Get.parameters['page'] == 'cart' ? 2 : Get.parameters['page'] == 'order' ? 3 : Get.parameters['page'] == 'menu' ? 4 : 0,
    ))),
    GetPage(name: forgotPassword, page: () => const ForgetPassScreen()),
    GetPage(name: resetPassword, page: () => NewPassScreen(
      resetToken: Get.parameters['token'], number: Get.parameters['phone'], fromPasswordChange: Get.parameters['page'] == 'password-change',
    )),
    GetPage(name: search, page: () => getRoute(const SearchScreen())),
    GetPage(name: restaurant, page: () {
      return getRoute(Get.arguments ?? RestaurantScreen(
        restaurant: Restaurant(id: Get.parameters['id'] != 'null' && Get.parameters['id'] != null ? int.parse(Get.parameters['id']!) : null),
        slug: Get.parameters['slug'] ?? '', fromDineIn: Get.parameters['from_dine_in'] == 'true',
      ), byPuss: Get.parameters['slug']?.isNotEmpty ?? false);
    }),
    GetPage(name: orderDetails, page: () {
      return getRoute(Get.arguments ?? OrderDetailsScreen(
        orderId: int.parse(Get.parameters['id'] ?? '0'),
        orderModel: null, fromOfflinePayment: Get.parameters['from_offline'] == 'true',
        contactNumber: Get.parameters['contact'],
        fromGuestTrack: Get.parameters['from_guest_track'] == 'true',
        fromNotification: Get.parameters['from_notification'] == 'true',
        fromDineIn: Get.parameters['from_dine_in'] == 'true',
      ));
    }),
    GetPage(name: profile, page: () => getRoute(const ProfileScreen())),
    GetPage(name: updateProfile, page: () => getRoute(const UpdateProfileScreen())),
    GetPage(name: coupon, page: () => getRoute(CouponScreen(fromCheckout: Get.parameters['fromCheckout'] == 'true'))),
    GetPage(name: notification, page: () => getRoute(NotificationScreen(fromNotification: Get.parameters['fromNotification'] == 'true'))),
    GetPage(name: map, page: () {
      List<int> decode = base64Decode(Get.parameters['address']!.replaceAll(' ', '+'));
      AddressModel data = AddressModel.fromJson(jsonDecode(utf8.decode(decode)));
      Restaurant? restaurant;
      if(Get.parameters['restaurant'] != null && Get.parameters['restaurant'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['restaurant'] != null ? Get.parameters['restaurant']!.replaceAll(' ', '+') : '');
        restaurant = Restaurant.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return getRoute(MapScreen(
        fromRestaurant: Get.parameters['page'] == 'restaurant', address: data, restaurantName: Get.parameters['restaurantName'],
        fromOrder: Get.parameters['page'] == 'order', restaurant: restaurant,
        fromDineInOrder: Get.parameters['isDineOrder'] == 'true',
      ));
    }),
    GetPage(name: address, page: () => getRoute(const AddressScreen())),
    GetPage(name: orderSuccess, page: () {
      return getRoute(OrderSuccessfulScreen(
        orderID: Get.parameters['id'],
        status: Get.parameters['status'] != null ? (Get.parameters['status']!.contains('success') ? 1 : 0) : (Get.parameters['flag'] == 'success' ? 1 : 0),
        totalAmount: null,
        contactPersonNumber: Get.parameters['contact_number'] != null && Get.parameters['contact_number'] != 'null'
            ? Get.parameters['contact_number']
            : Get.find<AuthController>().isGuestLoggedIn() ? Get.find<AuthController>().getGuestNumber() : null,
        isDeliveryOrder: Get.parameters['is_delivery_order'] == 'true',
      ));
    }),
    GetPage(name: payment, page: () {
      OrderModel data = OrderModel.fromJson(jsonDecode(utf8.decode(base64Decode(Get.parameters['order']!.replaceAll(' ', '+')))));
      String paymentMethod = Get.parameters['payment-method']!;
      String addFundUrl = '';
      String subscriptionUrl = '';
      if(Get.parameters['add-fund-url'] != null && Get.parameters['add-fund-url'] != 'null'){
        addFundUrl = Get.parameters['add-fund-url']!;
      }
      if(Get.parameters['subscription-url'] != null && Get.parameters['subscription-url'] != 'null'){
        subscriptionUrl = Get.parameters['subscription-url']!;
      }
      String guestId = Get.parameters['guest-id']!;
      String number = Get.parameters['number']!;
      int? restaurantId = (Get.parameters['restaurant_id'] != null && Get.parameters['restaurant_id'] != 'null') ? int.parse(Get.parameters['restaurant_id']!) : null;
      int? packageId = (Get.parameters['package_id'] != null && Get.parameters['package_id'] != 'null') ? int.parse(Get.parameters['package_id']!) : null;
      return getRoute(AppConstants.payInWevView ? PaymentWebViewScreen(
        orderModel: data, paymentMethod: paymentMethod, addFundUrl: addFundUrl, subscriptionUrl: subscriptionUrl,
        guestId: guestId, contactNumber: number, restaurantId: restaurantId, packageId: packageId,
      ) : PaymentScreen(orderModel: data, paymentMethod: paymentMethod, addFundUrl: addFundUrl, subscriptionUrl: subscriptionUrl,
        guestId: guestId, contactNumber: number, restaurantId: restaurantId, packageId: packageId,
      ));
    }),
    GetPage(name: checkout, page: () {
      CheckoutScreen? checkoutScreen = Get.arguments;
      bool fromCart = Get.parameters['page'] == 'cart';
      return getRoute(checkoutScreen ?? (!fromCart ? const NotFoundWidget() : CheckoutScreen(
        cartList: null, fromCart: Get.parameters['page'] == 'cart', fromDineInPage: Get.parameters['from_dine_in'] == 'true',
      )));
    }),
    GetPage(name: orderTracking, page: () => getRoute(OrderTrackingScreen(orderID: Get.parameters['id'], contactNumber: Get.parameters['contact_number']))),
    GetPage(name: basicCampaign, page: () {
      BasicCampaignModel data = BasicCampaignModel.fromJson(jsonDecode(utf8.decode(base64Decode(Get.parameters['data']!.replaceAll(' ', '+')))));
      return getRoute(CampaignScreen(campaign: data));
    }),
    GetPage(name: html, page: () => HtmlViewerScreen(
      htmlType: Get.parameters['page'] == 'terms-and-condition' ? HtmlType.termsAndCondition
          : Get.parameters['page'] == 'privacy-policy' ? HtmlType.privacyPolicy
          : Get.parameters['page'] == 'shipping-policy' ? HtmlType.shippingPolicy
          : Get.parameters['page'] == 'cancellation-policy' ? HtmlType.cancellation
          : Get.parameters['page'] == 'refund-policy' ? HtmlType.refund : HtmlType.aboutUs,
    )),
    GetPage(name: categories, page: () => getRoute(const CategoryScreen())),
    GetPage(name: categoryProduct, page: () {
      List<int> decode = base64Decode(Get.parameters['name']!.replaceAll(' ', '+'));
      String data = utf8.decode(decode);
      return getRoute(CategoryProductScreen(categoryID: Get.parameters['id'], categoryName: data));
    }),
    GetPage(name: popularFoods, page: () {
      return getRoute(PopularFoodScreen(
        isPopular: Get.parameters['page'] == 'popular', fromIsRestaurantFood: Get.parameters['fromIsRestaurantFood'] == 'true',
        restaurantId: (Get.parameters['restaurant_id'] != null && Get.parameters['restaurant_id'] != 'null') ? int.parse(Get.parameters['restaurant_id']!) : null,
      ));
    }),
    GetPage(name: itemCampaign, page: () => getRoute(const ItemCampaignScreen())),
    GetPage(name: support, page: () => getRoute(byPuss: true, const SupportScreen())),
    GetPage(name: update, page: () => UpdateScreen(isUpdate: Get.parameters['update'] == 'true')),
    GetPage(name: cart, page: () => getRoute(CartScreen(fromNav: false, fromReorder: Get.parameters['from_reorder'] == 'true', fromDineIn: Get.parameters['from_dine_in'] == 'true'))),
    GetPage(name: addAddress, page: () => getRoute(AddAddressScreen(fromCheckout: Get.parameters['page'] == 'checkout', zoneId: int.parse(Get.parameters['zone_id']!)))),
    GetPage(name: editAddress, page: () {
      AddressModel? data;
      if(Get.parameters['data'] != 'null') {
        data = AddressModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['data']!.replaceAll(' ', '+')))));
      }
      return getRoute(AddAddressScreen(
        fromCheckout: false, address: data, forGuest: Get.parameters['from-guest'] == 'true',
      ));
    }),
    GetPage(name: rateReview, page: () {
      RateReviewModel data = RateReviewModel.fromJson(jsonDecode(utf8.decode(base64Decode(Get.parameters['data']!.replaceAll(' ', '+')))));
      return getRoute(RateReviewScreen(rateReviewModel: data));
    }),
    GetPage(name: restaurantReview, page: () => getRoute(ReviewScreen(restaurantID: Get.parameters['id'], restaurantName: Get.parameters['restaurantName'], restaurant: Restaurant.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['restaurant']!.replaceAll(' ', '+')))))))),
    GetPage(name: allRestaurants, page: () => getRoute(
        AllRestaurantScreen(
          isPopular: Get.parameters['page'] == 'popular',
          isRecentlyViewed: Get.parameters['page'] == 'recently_viewed',
          isOrderAgain: Get.parameters['page'] == 'order_again',
        ),
    )),
    GetPage(name: wallet, page: () {
      return getRoute(WalletScreen(fundStatus: Get.parameters['flag'] ?? Get.parameters['payment_status'], fromMenuPage: Get.parameters['from_menu_page'] == 'true', fromNotification: Get.parameters['from_notification'] == 'true'));
    }),
    GetPage(name: loyalty, page: () => getRoute(const LoyaltyScreen())),
    GetPage(name: searchRestaurantItem, page: () => getRoute(RestaurantProductSearchScreen(storeID: Get.parameters['id']))),
    GetPage(name: productImages, page: () => getRoute(ImageViewerScreenWidget(
      product: Product.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['item']!.replaceAll(' ', '+'))))),
    ))),
    GetPage(name: referAndEarn, page: () => getRoute(const ReferAndEarnScreen())),
    GetPage(name: messages, page: () {
      NotificationBodyModel? notificationBody;
      if(Get.parameters['notification'] != 'null') {
        notificationBody = NotificationBodyModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['notification']!.replaceAll(' ', '+')))));
      }
      User? user;
      if(Get.parameters['user'] != 'null') {
        user = User.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['user']!.replaceAll(' ', '+')))));
      }
      return getRoute(ChatScreen(
        notificationBody: notificationBody, user: user, index: Get.parameters['index'] != 'null' ? int.parse(Get.parameters['index']!) : null,
        conversationID: (Get.parameters['conversation_id'] != null && Get.parameters['conversation_id'] != 'null') ? int.parse(Get.parameters['conversation_id']!) : null,
        fromNotification: Get.parameters['fromNotification'] == 'true',
      ));
    }),
    GetPage(name: conversation, page: () => const ConversationScreen()),
    GetPage(name: mapView, page: () => getRoute(MapViewScreen(fromDineInScreen: Get.parameters['from_dine_in_screen'] == 'true'))),
    GetPage(name: restaurantRegistration, page: () => const RestaurantRegistrationScreen()),
    GetPage(name: deliveryManRegistration, page: () => const DeliveryManRegistrationScreen()),
    GetPage(name: refund, page: () => RefundRequestScreen(orderId: Get.parameters['id'])),
    GetPage(name: order, page: () => getRoute(const OrderScreen())),
    GetPage(name: cuisine, page: () => getRoute(const CuisineScreen())),
    GetPage(name: cuisineRestaurant, page: () => getRoute(CuisineRestaurantScreen(cuisineId: int.parse(Get.parameters['id']!), name: Get.parameters['name']))),
    GetPage(name: subscriptionSuccess, page: () => getRoute(SubscriptionSuccessOrFailedScreen(
      success: Get.parameters['flag'] == 'success',
      fromSubscription: Get.parameters['from_subscription'] == 'true',
      restaurantId: (Get.parameters['restaurant_id'] != null && Get.parameters['restaurant_id'] != 'null') ? int.parse(Get.parameters['restaurant_id']!) : null,
      packageId: (Get.parameters['package_id'] != null && Get.parameters['package_id'] != 'null') ? int.parse(Get.parameters['package_id']!) : null,
    ))),
    GetPage(name: subscriptionPayment, page: () => SubscriptionPaymentScreen(restaurantId: int.parse(Get.parameters['restaurant-id']!), packageId: int.parse(Get.parameters['package-id']!))),
    GetPage(name: offlinePaymentScreen, page: () {
      List<int> decode = base64Decode(Get.parameters['order_body']!.replaceAll(' ', '+'));
      PlaceOrderBodyModel orderBody = PlaceOrderBodyModel.fromJson(jsonDecode(utf8.decode(decode)));

      List<int> decode2 = base64Decode(Get.parameters['pricing_body']!.replaceAll(' ', '+'));
      PricingViewModel pricingViewBody = PricingViewModel.fromJson(jsonDecode(utf8.decode(decode2)));

      return OfflinePaymentScreen(
        placeOrderBodyModel: orderBody, zoneId: int.parse(Get.parameters['zone_id']!),
        total: double.parse(Get.parameters['total']!),
        maxCodOrderAmount: (Get.parameters['max_cod_amount'] != null && Get.parameters['max_cod_amount'] != 'null') ? double.parse(Get.parameters['max_cod_amount']!) : null,
        fromCart: Get.parameters['from_cart'] == 'true', isCashOnDeliveryActive: Get.parameters['cod_active'] == 'true', pricingView: pricingViewBody,
      );
    }),
    GetPage(name: guestTrackOrderScreen, page: () => GuestTrackOrderScreen(
      orderId: Get.parameters['order_id']!, number: Get.parameters['number']!,
    )),
    GetPage(name: favourite, page: () => getRoute(const FavouriteScreen())),
    GetPage(name: newUserSetupScreen, page: () => NewUserSetupScreen(
      name: Get.parameters['name']!, loginType: Get.parameters['login_type']!,
      phone: Get.parameters['phone'] != '' && Get.parameters['phone'] != 'null' ? Get.parameters['phone']!.replaceAll(' ', '+') : null,
      email: Get.parameters['email'] != '' && Get.parameters['email'] != 'null' ? Get.parameters['email']!.replaceAll(' ', '+') : null,
    )),
    GetPage(name: dineInRestaurant, page: () => getRoute(const DineInRestaurantScreen())),
  ];

  static getRoute(Widget? navigateTo, {bool byPuss = false}) {
    double? minimumVersion = 0;
    if(GetPlatform.isAndroid) {
      minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionAndroid;
    }else if(GetPlatform.isIOS) {
      minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionIos;
    }
    return AppConstants.appVersion < minimumVersion! ? const UpdateScreen(isUpdate: true)
        : MaintenanceHelper.isMaintenanceEnable() ? const UpdateScreen(isUpdate: false)
        : (AddressHelper.getAddressFromSharedPref() == null && !byPuss)
        ? AccessLocationScreen(fromSignUp: false, fromHome: false, route: Get.currentRoute) : navigateTo;
  }
}
