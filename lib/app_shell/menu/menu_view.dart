// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/app_shell_controller.dart';
import 'package:zi_core/zi_core_io.dart';
import '../app_shell_io.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    // DO: Get user data from provider or state
    // const userName = 'User';
    // const userEmail = '';

    return ZiScaffoldB(
      showPagePadding: false,
      body: Column(
        children: [
          ziGap(20),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset("assets/Islamic_app_Icon.png"),
                        ),
                        SizedBox(height: 20),
                        // ZiSvgIcon(
                        //   path: ShellSVGs.avPerson,
                        //   color: ZiColors.primary,
                        //   size: 80,
                        // ),
                        //
                        // heroSectionContent(
                        //   // img: ShellImages.avPerson,
                        //   // svgImg: ShellSVGs.avPerson,
                        //   title: userName,
                        //   content: userEmail,
                        // ),
                      ],
                    ),
                  ],
                ),

                // ActionTile(
                //   title: "Free Plan",
                //   actionLabel: "Upgrade",
                //   onActionTap: () => UpgradeDialog.show(context),
                // ),
              ],
            ),
          ),
          ziGap(10),
          Divider(height: 2, color: ZiColors.border),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                buildGroupedMenu(context, showGroupTitle: false),
                // ZiMenuTile1(
                //   icon: Icons.power_settings_new_rounded,
                //   iconPrefixColor: Colors.red,
                //   label: "Logout",
                //   action: ZiTapAction(
                //     type: ZiTapActionType.custom,
                //     onTap: () async {
                //       // bool? isLogout = await ZiConfirmationUser.logout(
                //       //   context: context,
                //       // );
                //       // if (isLogout!) {
                //       //   // logout logic here
                //       //   Navigator.pushReplacement(
                //       //     context,
                //       //     MaterialPageRoute(builder: (context) => LoginView()),
                //       //   );
                //       // }
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: context.responsivePadding(
              horizontal: 0.045,
              vertical: 0.018,
            ),
            child: InkWell(
              onTap: () {
                Get.find<AppShellController>().selectTab(2);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  context.widthPct(0.045).clamp(14.0, 20.0).toDouble(),
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.16),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Image.asset('assets/Quran_image.png'),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Read Quran Pak',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: context.scaledFont(17),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Choose from all 30 Paras',
                            style: TextStyle(
                              color: AppColors.white.withValues(alpha: 0.82),
                              fontSize: context.scaledFont(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFFFFD36A),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
