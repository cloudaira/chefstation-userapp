import 'package:chefstation_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:chefstation_multivendor/features/order/controllers/order_controller.dart';
import 'package:chefstation_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:chefstation_multivendor/features/profile/widgets/account_deletion_bottom_sheet.dart';
import 'package:chefstation_multivendor/features/profile/widgets/notification_status_change_bottom_sheet.dart';
import 'package:chefstation_multivendor/features/profile/widgets/profile_button_widget.dart';
import 'package:chefstation_multivendor/features/profile/widgets/profile_card_widget.dart';
import 'package:chefstation_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:chefstation_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:chefstation_multivendor/features/verification/screens/new_pass_screen.dart';
import 'package:chefstation_multivendor/helper/date_converter.dart';
import 'package:chefstation_multivendor/helper/price_converter.dart';
import 'package:chefstation_multivendor/helper/responsive_helper.dart';
import 'package:chefstation_multivendor/helper/route_helper.dart';
import 'package:chefstation_multivendor/util/dimensions.dart';
import 'package:chefstation_multivendor/util/images.dart';
import 'package:chefstation_multivendor/util/styles.dart';
import 'package:chefstation_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebProfileWidget extends StatelessWidget {
  final ProfileController profileController;
  final OrderController orderController;
  const WebProfileWidget({super.key, required this.profileController, required this.orderController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController> (builder: (profileController) {
      bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
      return SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(children : [
          SizedBox(
            height: 243,
            child: Stack(children: [
              Container(
                height: 162,
                width: Dimensions.webMaxWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
                  image: const DecorationImage(image: AssetImage(Images.profileBackground), fit: BoxFit.fitWidth)
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                    child: Text('profile'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  ),
                ),
              ),

              Positioned(
                top: 96,
                left: (Dimensions.webMaxWidth/2) - 60,
                child: ClipOval(child: CustomImageWidget(
                  placeholder: isLoggedIn ? Images.profilePlaceholder : Images.guestIcon,
                  image: '${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.imageFullUrl : ''}',
                  height: 120, width: 120, fit: BoxFit.cover, imageColor: isLoggedIn ? Theme.of(context).hintColor : null,
                )),
              ),

              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    isLoggedIn ? '${profileController.userInfoModel!.fName} ${profileController.userInfoModel!.lName}' : 'guest_user'.tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                ),
              ),

              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: (){
                      Get.dialog(
                        Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
                          insetPadding: const EdgeInsets.all(22),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: AccountDeletionBottomSheet(
                            profileController: profileController,
                            isRunningOrderAvailable: orderController.runningOrderList != null && orderController.runningOrderList!.isNotEmpty,
                          ),
                        ),
                        useSafeArea: false,
                      );
                    },
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Image.asset(Images.profileDelete, height: 20, width: 20),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text('delete_account'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    ]),
                  ),
                ),
              ),

            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const SizedBox( width: Dimensions.paddingSizeLarge),

            Expanded(
              child: Container(
                height: 112,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.1), blurRadius: 5, spreadRadius: 1)],
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ClipOval(child: CustomImageWidget(
                    placeholder: isLoggedIn ? Images.profilePlaceholder : Images.guestIcon,
                    image: '${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.imageFullUrl : ''}',
                    height: 30, width: 30, fit: BoxFit.cover, imageColor: isLoggedIn ? Theme.of(context).hintColor : null,
                  )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    DateConverter.containTAndZToUTCFormat(profileController.userInfoModel!.createdAt!), textDirection: TextDirection.ltr,
                    style: robotoMedium.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeDefault : Dimensions.fontSizeExtraLarge),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    'since_joining'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                  ),
                ]),
              ),
            ),
            const SizedBox( width: Dimensions.paddingSizeOverLarge),

            Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Expanded(child: ProfileCardWidget(
              image: Images.walletProfile,
              data: PriceConverter.convertPrice(profileController.userInfoModel!.walletBalance),
              title: 'wallet_balance'.tr,
            )) : const SizedBox(),
            SizedBox(width: Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Dimensions.paddingSizeOverLarge : 0),

            isLoggedIn ? Expanded(
              child: ProfileCardWidget(
                image: Images.shoppingBagIcon,
                data: profileController.userInfoModel!.orderCount.toString(),
                title: 'total_order'.tr,
              ),
            ) : const SizedBox(),
            SizedBox(width: Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Dimensions.paddingSizeOverLarge : 0),

            Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? Expanded(child: ProfileCardWidget(
              image: Images.loyaltyIcon,
              data: profileController.userInfoModel!.loyaltyPoint != null ? profileController.userInfoModel!.loyaltyPoint.toString() : '0',
              title: 'loyalty_points'.tr,
            )) : const SizedBox(),
            SizedBox(width: Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? Dimensions.paddingSizeLarge : 0),
          ]),
          const SizedBox(height: Dimensions.paddingSizeOverLarge),

          GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 9,
            children: <Widget>[

              ProfileButtonWidget(icon: Icons.tonality_outlined, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),

              isLoggedIn ? GetBuilder<AuthController>(builder: (authController) {
                return ProfileButtonWidget(
                  icon: Icons.notifications, title: 'notification'.tr,
                  isButtonActive: authController.notification, onTap: () {
                  Get.dialog(const Dialog(child: NotificationStatusChangeBottomSheet()));
                },
                );
              }) : const SizedBox(),

              isLoggedIn ? ProfileButtonWidget(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                // Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
                Get.dialog(const NewPassScreen(fromPasswordChange: true, fromDialog: true, resetToken: '', number: ''));
              }) : const SizedBox(),

              isLoggedIn ? ProfileButtonWidget(icon: Icons.edit, title: 'edit_profile'.tr, onTap: () {
                Get.toNamed(RouteHelper.getUpdateProfileRoute());
              }) : const SizedBox(),
            ],
          ),
          const SizedBox( height: 100)

        ]),
      );
    });
  }
}
