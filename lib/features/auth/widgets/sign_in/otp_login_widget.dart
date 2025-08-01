import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chefstation_multivendor/common/widgets/custom_button_widget.dart';
import 'package:chefstation_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:chefstation_multivendor/common/widgets/validate_check.dart';
import 'package:chefstation_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:chefstation_multivendor/features/auth/widgets/social_login_widget.dart';
import 'package:chefstation_multivendor/features/auth/widgets/trams_conditions_check_box_widget.dart';
import 'package:chefstation_multivendor/features/language/controllers/localization_controller.dart';
import 'package:chefstation_multivendor/helper/responsive_helper.dart';
import 'package:chefstation_multivendor/util/dimensions.dart';
import 'package:chefstation_multivendor/util/styles.dart';
class OtpLoginWidget extends StatelessWidget {
  final TextEditingController phoneController;
  final FocusNode phoneFocus;
  final String? countryDialCode;
  final Function(CountryCode countryCode)? onCountryChanged;
  final Function() onClickLoginButton;
  final bool socialEnable;
  const OtpLoginWidget({super.key, required this.phoneController, required this.phoneFocus, required this.onCountryChanged, required this.countryDialCode, required this.onClickLoginButton, this.socialEnable = false});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return GetBuilder<AuthController>(
      builder: (authController) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : 0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text('login'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            CustomTextFieldWidget(
              hintText: 'phone_number_format'.tr,
              controller: phoneController,
              focusNode: phoneFocus,
              inputAction: TextInputAction.done,
              inputType: TextInputType.phone,
              isPhone: true,
              onCountryChanged: onCountryChanged,
              countryDialCode: countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
              labelText: 'phone'.tr,
              required: true,
              validator: (value) => ValidateCheck.validateEmptyText(value, "please_enter_phone_number".tr),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => authController.toggleRememberMe(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 24, width: 24,
                      child: Checkbox(
                        side: BorderSide(color: Theme.of(context).hintColor),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: Theme.of(context).primaryColor,
                        value: authController.isActiveRememberMe,
                        onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text('remember_me'.tr, style: robotoRegular),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            TramsConditionsCheckBoxWidget(authController: authController, fromDialog: true),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            CustomButtonWidget(
              // height: isDesktop ? 50 : null,
              // width:  isDesktop ? 250 : null,
              buttonText: 'login'.tr,
              radius: Dimensions.radiusDefault,
              isBold: isDesktop ? false : true,
              isLoading: authController.isLoading,
              onPressed: onClickLoginButton,
              fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            socialEnable ? const SocialLoginWidget(onlySocialLogin: false) : const SizedBox(),

            socialEnable && isDesktop ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),

            !socialEnable ? const SizedBox(height: 100) : const SizedBox(),

          ]),
        );
      }
    );
  }
}
