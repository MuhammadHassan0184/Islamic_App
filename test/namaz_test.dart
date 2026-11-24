import 'package:flutter_test/flutter_test.dart';

import 'package:get/get.dart';
import 'package:islam786/features_slices/View/Namaz/Controller/namaz_controller.dart';
import 'package:islam786/features_slices/app_shell_binding.dart';
import 'package:islam786/features_slices/name_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home shell builds the Namaz tab with its controller', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialBinding: AppShellBinding(),
        home: const NameAppView(),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(Get.isRegistered<NamazController>(), isTrue);
  });
}
