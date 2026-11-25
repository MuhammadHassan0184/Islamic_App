import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Services/app_permission_service.dart';
import 'package:zi_core/zi_core_io.dart';

import '../../app_shell_io.dart';

class ZAppGateView extends StatelessWidget {
  const ZAppGateView({super.key});

  @override
  Widget build(BuildContext context) {
    return ZiScaffoldB(
      body: ListView(
        children: [
          ziGap(40),
          Image.asset(ShellImages.onBoarding1, height: 280),
          ziGap(10),
          heroSectionContent(
            title: ShellData.zGate.title,
            content: ShellData.zGate.info,
            isTitle: true,
          ),
          ziGap(10),
          // ZiButtonB(
          //   expand: true,
          //   label: "Create New Account",
          //   variant: ZiButtonVariantB.primary,
          //   action: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const SignupView()),
          //     );
          //   },
          // ),
          // ziGap(10),
          // ZiButtonB(
          //   expand: true,
          //   label: "Login Account",
          //   variant: ZiButtonVariantB.outline,
          //   action: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(builder: (_) => const LoginView()),
          //     );
          //   },
          // ),
          ziGap(10),
          ZiButtonB(
            expand: true,
            label: "Get Started",
            action: () async {
              await AppPermissionService.showPermissionSheet(
                context,
                onCompleted: () => Get.offAllNamed(AppRoutes.home),
              );
            },
          ),
        ],
      ),
    );
  }
}
