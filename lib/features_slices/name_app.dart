import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/features_slices/View/Adaab/adaab_screen.dart';
import 'package:islam786/features_slices/View/Azkar/azkar_screen.dart';
import 'package:islam786/features_slices/View/Duas/duas_screen.dart';
import 'package:zi_core/zi_core_io.dart';

import '../app_shell/app_shell_io.dart';
import 'app_shell_controller.dart';

class NameAppView extends GetView<AppShellController> {
  const NameAppView({super.key});

  static final List<TabItem> _mainPages = [
    TabItem(icon: Icons.mosque_rounded, title: 'Dua'),
    TabItem(icon: Icons.auto_awesome_rounded, title: 'Azkar'),
    TabItem(icon: Icons.volunteer_activism_rounded, title: 'Adaab'),
    TabItem(icon: Icons.menu, title: 'Menu'),
  ];

  static final List<Widget> _pages = [
    const DuaScreen(),
    const AzkarScreen(),
    const AdaabScreen(),
    MenuView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.selectedIndex.value;
      return ZiScaffoldB(
        showPagePadding: false,
        body: IndexedStack(index: selectedIndex, children: _pages),
        bottomNavigationBar: ZiBottomBar(
          items: _mainPages,
          currentIndex: selectedIndex,
          onTap: controller.selectTab,
          type: ZiBottomBarType.fancy,
          style: ZiBottomBarStyle(
            backgroundColor: ZiColors.white,
            color: ZiColors.textMuted,
            colorSelected: ZiColors.primary,
          ),
        ),
      );
    });
  }
}
