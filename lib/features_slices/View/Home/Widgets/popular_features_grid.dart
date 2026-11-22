
import 'package:flutter/material.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Home/Model/home_feature_model.dart';

import '../Controller/home_controller.dart';
import 'home_feature_card.dart';


class PopularFeaturesGrid extends StatelessWidget {
  final HomeController controller;

  const PopularFeaturesGrid({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final features = HomeFeatureModel.popularFeatures;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: context.widthPct(0.045),
        mainAxisSpacing: context.heightPct(0.025),
        childAspectRatio: 1.03,
      ),
      itemBuilder: (context, index) {
        final feature = features[index];

        return HomeFeatureCard(
          feature: feature,
          onTap: () => controller.openFeature(feature.title),
        );
      },
    );
  }
}
