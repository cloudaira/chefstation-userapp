import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chefstation_multivendor/common/models/response_model.dart';
import 'package:chefstation_multivendor/common/widgets/custom_button_widget.dart';
import 'package:chefstation_multivendor/common/widgets/custom_image_widget.dart';
import 'package:chefstation_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:chefstation_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:chefstation_multivendor/features/auth/domain/centralize_login_enum.dart';
import 'package:chefstation_multivendor/features/auth/domain/models/auth_response_model.dart';
import 'package:chefstation_multivendor/features/auth/domain/models/social_log_in_body_model.dart';
import 'package:chefstation_multivendor/features/auth/screens/new_user_setup_screen.dart';
import 'package:chefstation_multivendor/helper/responsive_helper.dart';
import 'package:chefstation_multivendor/helper/route_helper.dart';
import 'package:chefstation_multivendor/util/dimensions.dart';
import 'package:chefstation_multivendor/util/images.dart';
import 'package:chefstation_multivendor/util/styles.dart';
class ExistingUserBottomSheet extends StatelessWidget {
  final IsExistUser userModel;
  final String? number;
  final String? email;
  final String loginType;
  final String? otp;
  final SocialLogInBodyModel? socialLogInBodyModel;
  const ExistingUserBottomSheet({super.key, required this.userModel, this.number, this.email, required this.loginType, this.otp, this.socialLogInBodyModel});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Container(
      width: 550,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
      // height: 500,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:  BorderRadius.vertical(top: const Radius.circular(Dimensions.radiusDefault), bottom: Radius.circular(isDesktop ? Dimensions.radiusDefault : 0)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        ResponsiveHelper.isDesktop(context) ? Align(
          alignment: Alignment.topRight,
          child: IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.clear)),
        ) : Container(
          height: 5, width: 35,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        SizedBox(height: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),

        ClipOval(child: CustomImageWidget(
          placeholder: Images.guestIconLight,
          imageColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
          image: userModel.image??'',
          height: 70, width: 70, fit: BoxFit.cover,
        )),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(userModel.name ?? 'Jhon Doe', style: robotoMedium, textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text('is_it_you'.tr, style: robotoBold, textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(text: number != null ? 'it_looks_like_the_phone'.tr : 'it_looks_like_the_email'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
            const TextSpan(text: ' '),

            TextSpan(text: number ?? email, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
            const TextSpan(text: ' '),

            TextSpan(
              text: 'you_entered_has_already_been_used_and_has_an_existing_account'.tr,
              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
            ),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeOverLarge),

        SafeArea(
          child: GetBuilder<AuthController>(
            builder: (authController) {
              return !authController.isLoading ? Row(children: [

                Expanded(child: CustomButtonWidget(
                  buttonText: 'no'.tr,
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                  fontSize: Dimensions.fontSizeDefault,
                  textColor: Theme.of(context).textTheme.bodyLarge!.color,
                  onPressed: () {
                    if(loginType == CentralizeLoginType.otp.name) {
                      authController.otpLogin(phone: number ?? email ?? '', loginType: loginType, otp: otp!, verified: 'no').then((response) {
                        _responseHandle(response);
                      });
                    } else {
                      socialLogInBodyModel!.verified = 'no';

                      authController.loginWithSocialMedia(socialLogInBodyModel!).then((response) {
                        _responseHandle(response);
                      });
                    }
                  },
                )),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(child: CustomButtonWidget(
                  buttonText: 'yes_its_me'.tr,
                  color: Theme.of(context).colorScheme.error,
                  fontSize: Dimensions.fontSizeDefault,
                  onPressed: () async {
                    if(loginType == CentralizeLoginType.otp.name) {
                      authController.otpLogin(phone: number ?? email ?? '', loginType: loginType, otp: otp!, verified: 'yes').then((response) {
                        _responseHandle(response);
                      });
                    } else {

                      socialLogInBodyModel!.verified = 'yes';

                      authController.loginWithSocialMedia(socialLogInBodyModel!).then((response) {
                        _responseHandle(response);
                      });
                    }
                  },
                )),

              ]) : const Center(child: CircularProgressIndicator());
            }
          ),
        ),

      ]),
    );
  }

  void _responseHandle(ResponseModel response) {
    Get.back();
    if(response.isSuccess && !response.authResponseModel!.isPersonalInfo!) {
      if(ResponsiveHelper.isDesktop(Get.context)) {
        Get.back();
        Get.dialog(NewUserSetupScreen(name: userModel.name??'', loginType: loginType, phone: number, email: email));
      } else {
        Get.toNamed(RouteHelper.getNewUserSetupScreen(name: userModel.name??'', loginType: loginType, phone: number, email: email));
      }
    } else if(response.isSuccess && response.authResponseModel!.isPersonalInfo!) {
      Get.offAllNamed(RouteHelper.getAccessLocationRoute('sign-in'));
    } else {
      Future.delayed(const Duration(milliseconds: 600), () {
        showCustomSnackBar(response.message);
      });
    }
  }
}
