import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chefstation_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:chefstation_multivendor/common/widgets/custom_button_widget.dart';
import 'package:chefstation_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:chefstation_multivendor/helper/responsive_helper.dart';
import 'package:chefstation_multivendor/util/dimensions.dart';
import 'package:chefstation_multivendor/util/images.dart';
import 'package:chefstation_multivendor/util/styles.dart';
class NotificationStatusChangeBottomSheet extends StatelessWidget {
  const NotificationStatusChangeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isDesktop(context) ? BorderRadius.circular(Dimensions.radiusLarge) : const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: GetBuilder<AuthController>(builder: (authController) {
        return Column(mainAxisSize: MainAxisSize.min, children: [

          ResponsiveHelper.isDesktop(context) ?
              Align(alignment: Alignment.topRight, child: IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.clear))) : Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: 35),

          const CustomAssetImageWidget(
            Images.warning, height: 50, width: 50,
          ),
          const SizedBox(height: 35),

          Text('are_you_sure'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              authController.notification ? 'if_you_disable_this_option_you_will_not_receive_system_notifications'.tr
                  : 'when_you_enable_this_option_you_will_be_notified_with_the_system_notifications'.tr,
              style: robotoRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),

          Row(children: [

            Expanded(
              child: !authController.notificationLoading ? CustomButtonWidget(
                onPressed: () async {
                  await authController.setNotificationActive(!authController.notification);
                  Get.back();
                },
                buttonText: 'yes'.tr,
                color: Theme.of(context).colorScheme.error,
              ) : Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.error)),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: CustomButtonWidget(
                onPressed: () {
                  Get.back();
                },
                buttonText: 'no'.tr,
                color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),

          ]),

        ]);
      }),
    );
  }
}
