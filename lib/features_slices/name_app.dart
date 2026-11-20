import 'package:flutter/material.dart';
import 'package:islam786/features_slices/View/Duas/Bindings/dua_binding.dart';
import 'package:islam786/features_slices/View/Duas/duas_screen.dart';
import 'package:zi_core/zi_core_io.dart';
import '../app_shell/app_shell_io.dart';

class NameAppView extends StatefulWidget {
  const NameAppView({super.key});

  @override
  State<NameAppView> createState() => _NameAppViewState();
}

class _NameAppViewState extends State<NameAppView> {
  int pageIndex = 0;
  List mainPavesView = [
    // home bottom screens
    // GlobalWidgets(),
    DuaScreen(),
    MenuView(),
  ];
  List<TabItem> mainPages = [
    TabItem(icon: Icons.mosque_rounded, title: 'Dua'),
    TabItem(icon: Icons.menu, title: 'Menu'),
  ];

  @override
  void initState() {
    super.initState();
    DuaBinding().dependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ZiScaffoldB(
      showPagePadding: false,
      body: mainPavesView[pageIndex],
      bottomNavigationBar: ZiBottomBar(
        items: mainPages,
        currentIndex: pageIndex,
        onTap: (i) => setState(() => pageIndex = i),
        type: ZiBottomBarType.fancy,
        style: ZiBottomBarStyle(
          backgroundColor: ZiColors.white,
          color: ZiColors.textMuted,
          colorSelected: ZiColors.primary,
        ),
      ),
    );
  }
}
