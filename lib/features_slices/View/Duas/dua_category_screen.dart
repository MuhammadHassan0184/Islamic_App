import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/features_slices/View/Duas/Controller/dua_controller.dart';

class DuaCategoryScreen extends GetView<DuaController> {
  const DuaCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map?;
    final categoryId = arguments?['id']?.toString() ?? '';
    final title = arguments?['title']?.toString() ?? 'Duain';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: Text(title),
        centerTitle: true,
      ),
      body: Obx(() {
        final duas = controller.getDuasByCategory(categoryId);

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (duas.isEmpty) {
          return const Center(child: Text('No Duas found in this category.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: duas.length,
          itemBuilder: (context, index) {
            final dua = duas[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    dua.arabic,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.8,
                      fontFamily: 'NotoNaskhArabic',
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    dua.urdu.isNotEmpty ? dua.urdu : dua.english,
                    style: const TextStyle(height: 1.5),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.toNamed('/dua-detail', arguments: dua),
              ),
            );
          },
        );
      }),
    );
  }
}
