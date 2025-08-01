import 'package:chefstation_multivendor/helper/responsive_helper.dart';
import 'package:chefstation_multivendor/util/dimensions.dart';
import 'package:chefstation_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class ChatSearchFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData suffixIcon;
  final Function iconPressed;
  final Function? onSubmit;
  final Function? onChanged;
  final Function()? onTap;
  const ChatSearchFieldWidget({super.key, required this.controller, required this.hint, required this.suffixIcon, required this.iconPressed,
    this.onSubmit, this.onChanged, this.onTap});

  @override
  State<ChatSearchFieldWidget> createState() => _ChatSearchFieldWidgetState();
}

class _ChatSearchFieldWidgetState extends State<ChatSearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      onTap: widget.onTap,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 60),
          borderSide: BorderSide(width: 1, color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 60),
          borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
        ),
        hintText: widget.hint,
        hintStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 60),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        suffixIcon: IconButton(
          onPressed: widget.iconPressed as void Function()?,
          icon: Icon(widget.suffixIcon, color: Theme.of(context).disabledColor, size: 25),
        ),
      ),
      onSubmitted: widget.onSubmit as void Function(String)?,
      onChanged: widget.onChanged as void Function(String)?,
    );
  }
}
