// import 'package:flutter/material.dart';
// import 'package:islam786/Config/Colors/app_colors.dart';
// import 'package:zi_core/zi_core_io.dart';

// import 'app_shell/app_shell_io.dart';

// void main() {
//   ziCoreInit(beta: true);
//   ZiColors.override(
//     ZiColorOverrides(
//       primary: AppColors.primary,
//       // primary: const Color(0xFFF97316),
//       // secondary: const Color(0xFF55FFFF),
//       // tertiary: const Color(0xFF55FF55),
//     ),
//   );
//   AppConfig.environment = ZiEnvironment.production;
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'ZiToKit zi_6',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: ZiColors.primary),
//       ),
//       // home: const MyHomePage(title: 'Flutter Demo Home Page'),
//       home: ZiSplashScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:zi_core/zi_core_io.dart';
import 'app_shell/app_shell_io.dart';

const _lightSystemBars = SystemUiOverlayStyle(
  // statusBarColor: Colors.white,
  // statusBarIconBrightness: Brightness.dark,
  // statusBarBrightness: Brightness.light,
  // systemNavigationBarColor: Colors.white,
  // systemNavigationBarDividerColor: Colors.white,
  // systemNavigationBarIconBrightness: Brightness.dark,
  // systemStatusBarContrastEnforced: false,
  // systemNavigationBarContrastEnforced: false,
  statusBarColor: AppColors.primary,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarDividerColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarContrastEnforced: false,
);

void main() {
  ziCoreInit(beta: true);

  ZiColors.override(ZiColorOverrides(primary: AppColors.primary));

  AppConfig.environment = ZiEnvironment.production;
  SystemChrome.setSystemUIOverlayStyle(_lightSystemBars);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZiToKit zi_6',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ZiColors.primary),
        appBarTheme: const AppBarTheme(systemOverlayStyle: _lightSystemBars),
      ),

      // Keep your existing splash screen.
      home: ZiSplashScreen(),

      getPages: AppRoutes.pages,
      builder: (context, child) {
        final topInset = MediaQuery.paddingOf(context).top;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _lightSystemBars,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: Colors.white),
              // Android edge-to-edge makes the status bar transparent, so color
              // only the top inset. The navigation bar area stays white.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topInset,
                child: const ColoredBox(color: AppColors.primary),
              ),
              SafeArea(child: child ?? const SizedBox.shrink()),
            ],
          ),
        );
      },
    );
  }
}
