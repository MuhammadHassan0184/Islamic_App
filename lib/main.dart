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
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/features_slices/View/Duas/duas_screen.dart';
import 'package:zi_core/zi_core_io.dart';
import 'app_shell/app_shell_io.dart';
import 'features_slices/View/Duas/Bindings/dua_binding.dart';

void main() {
  ziCoreInit(beta: true);

  ZiColors.override(ZiColorOverrides(primary: AppColors.primary));

  AppConfig.environment = ZiEnvironment.production;

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
      ),

      // Keep your existing splash screen.
      home: ZiSplashScreen(),

      // Dua navigation route.
      getPages: [
        GetPage(
          name: '/duas',
          page: () => const DuaScreen(),
          binding: DuaBinding(),
        ),
      ],
    );
  }
}
