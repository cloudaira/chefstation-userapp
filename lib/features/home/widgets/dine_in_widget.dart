import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chefstation_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:chefstation_multivendor/common/widgets/custom_button_widget.dart';
import 'package:chefstation_multivendor/helper/route_helper.dart';
import 'package:chefstation_multivendor/util/dimensions.dart';
import 'package:chefstation_multivendor/util/images.dart';
import 'package:chefstation_multivendor/util/styles.dart';

class DineInWidget extends StatelessWidget {
  const DineInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall,
        left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeOverLarge,
      ),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

        const CustomAssetImageWidget(Images.dineInUser, height: 65, width: 80),

        Column(children: [

          Text('want_to_dine_in'.tr, style: robotoBold),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomButtonWidget(
            width: 115, height: 35, radius: Dimensions.radiusSmall,
            buttonText: 'view_restaurants'.tr,
            isBold: false, fontSize: Dimensions.fontSizeSmall,
            onPressed: () {
              Get.toNamed(RouteHelper.getDineInRestaurantScreen());
            },
          ),

        ]),

      ]),
    );
  }
}
