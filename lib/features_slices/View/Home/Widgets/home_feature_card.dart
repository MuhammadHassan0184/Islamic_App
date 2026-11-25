// import 'package:flutter/material.dart';
// import 'package:islam786/Utils/mediaquery_extension.dart';
// import 'package:islam786/features_slices/View/Home/Model/home_feature_model.dart';

// class HomeFeatureCard extends StatelessWidget {
//   final HomeFeatureModel feature;
//   final VoidCallback onTap;

//   const HomeFeatureCard({
//     super.key,
//     required this.feature,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: feature.background,
//       borderRadius: BorderRadius.circular(21),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: onTap,
//         child: Stack(
//           children: [
//             Positioned(
//               right: -context.widthPct(0.08),
//               bottom: -context.heightPct(0.025),
//               child: Container(
//                 width: context.widthPct(0.43),
//                 height: context.heightPct(0.085),
//                 decoration: BoxDecoration(
//                   color: feature.accent,
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//               ),
//             ),

//             Padding(
//               padding: EdgeInsets.all(context.widthPct(0.047)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     feature.title,
//                     style: TextStyle(
//                       color: const Color(0xFF004139),
//                       fontSize: context.scaledFont(14),
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),

//                   const Spacer(),

//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Icon(
//                       feature.icon,
//                       color: feature.iconColor,
//                       size: context.widthPct(0.19),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:islam786/features_slices/View/Home/Model/home_feature_model.dart';

class HomeFeatureCard extends StatelessWidget {
  final HomeFeatureModel feature;
  final VoidCallback onTap;

  const HomeFeatureCard({
    super.key,
    required this.feature,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(21),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          child: SizedBox.expand(
            child: Image.asset(
              feature.image,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: Colors.grey,
                    size: 35,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
