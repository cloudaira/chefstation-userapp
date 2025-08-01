import 'package:chefstation_multivendor/common/widgets/my_text_field_widget.dart';
import 'package:chefstation_multivendor/features/order/domain/models/order_model.dart';
import 'package:chefstation_multivendor/features/product/domain/models/review_body_model.dart';
import 'package:chefstation_multivendor/features/review/controllers/review_controller.dart';
import 'package:chefstation_multivendor/features/review/widgets/delivery_man_widget.dart';
import 'package:chefstation_multivendor/util/dimensions.dart';
import 'package:chefstation_multivendor/util/styles.dart';
import 'package:chefstation_multivendor/common/widgets/custom_button_widget.dart';
import 'package:chefstation_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryManReviewWidget extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  final String orderID;
  const DeliveryManReviewWidget({super.key, required this.deliveryMan, required this.orderID});

  @override
  State<DeliveryManReviewWidget> createState() => _DeliveryManReviewWidgetState();
}

class _DeliveryManReviewWidgetState extends State<DeliveryManReviewWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(builder: (reviewController) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          widget.deliveryMan != null ? DeliveryManWidget(deliveryMan: widget.deliveryMan) : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(
                color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                blurRadius: 5, spreadRadius: 1,
              )],
            ),
            child: Column(children: [
              Text(
                'rate_his_service'.tr,
                style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return InkWell(
                      child: Icon(
                        reviewController.deliveryManRating < (i + 1) ? Icons.star_border : Icons.star,
                        size: 25,
                        color: reviewController.deliveryManRating < (i + 1) ? Theme.of(context).disabledColor
                            : Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        reviewController.setDeliveryManRating(i + 1);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(
                'share_your_opinion'.tr,
                style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              MyTextFieldWidget(
                maxLines: 5,
                capitalization: TextCapitalization.sentences,
                controller: _controller,
                hintText: 'write_your_review_here'.tr,
                fillColor: Theme.of(context).disabledColor.withValues(alpha: 0.05),
              ),
              const SizedBox(height: 40),

              // Submit button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: CustomButtonWidget(
                  buttonText: 'submit'.tr,
                  isLoading: reviewController.isLoading,
                  onPressed: () {
                    if (reviewController.deliveryManRating == 0) {
                      showCustomSnackBar('give_a_rating'.tr);
                    } else if (_controller.text.isEmpty) {
                      showCustomSnackBar('write_a_review');
                    } else {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      ReviewBodyModel reviewBodyModel = ReviewBodyModel(
                        deliveryManId: widget.deliveryMan!.id.toString(),
                        rating: reviewController.deliveryManRating.toString(),
                        comment: _controller.text,
                        orderId: widget.orderID,
                      );
                      reviewController.submitDeliveryManReview(reviewBodyModel).then((value) {
                        if (value.isSuccess) {
                          showCustomSnackBar(value.message, isError: false);
                          _controller.text = '';
                        } else {
                          showCustomSnackBar(value.message);
                        }
                      });
                    }
                  },
                ),
              ),
            ]),
          ),

        ]))),
      );
    });
  }
}
