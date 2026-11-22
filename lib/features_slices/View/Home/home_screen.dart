import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Home/Controller/home_controller.dart';
import 'package:islam786/features_slices/View/Home/Widgets/home_drawer.dart';
import 'package:islam786/features_slices/View/Home/Widgets/home_header.dart';
import 'package:islam786/features_slices/View/Home/Widgets/home_section_title.dart';
import 'package:islam786/features_slices/View/Home/Widgets/last_read_banner.dart';
import 'package:islam786/features_slices/View/Home/Widgets/popular_features_grid.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.white,
      drawer: HomeDrawer(controller: controller),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: context.responsivePadding(
            horizontal: 0.058,
            vertical: 0.018,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(controller: controller),

              SizedBox(height: context.heightPct(0.035)),

              LastReadBanner(controller: controller),

              SizedBox(height: context.heightPct(0.038)),

              const HomeSectionTitle(title: 'Popular'),

              SizedBox(height: context.heightPct(0.025)),

              PopularFeaturesGrid(controller: controller),

              SizedBox(height: context.heightPct(0.035)),
            ],
          ),
        ),
      ),
    );
  }
}
