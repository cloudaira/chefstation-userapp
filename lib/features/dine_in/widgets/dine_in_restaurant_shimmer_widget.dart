import 'package:flutter/material.dart';
import 'package:chefstation_multivendor/util/dimensions.dart';

class DineInRestaurantShimmerWidget extends StatelessWidget {
  const DineInRestaurantShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: SizedBox(height: 8),
        );
      },
    );
  }
}
