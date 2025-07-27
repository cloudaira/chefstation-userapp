import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final Function? onTap;
  final bool isSelected;
  const BottomNavItem({super.key, required this.iconData, this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Icon(
            iconData,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[400],
            size: isSelected ? 30 : 26,
          ),
        ),
      ),
    );
  }
}
