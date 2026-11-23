import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Data/Models/dua_model.dart';
import 'package:islam786/features_slices/View/Duas/Controller/dua_controller.dart';

class DuaCategoryScreen extends GetView<DuaController> {
  const DuaCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    late final String categoryId;
    late final String title;

    if (arguments is DuaModel) {
      categoryId = arguments.category;
      title = _formatCategory(arguments.category);
    } else if (arguments == null || arguments is Map) {
      final categoryArguments = arguments as Map?;
      categoryId = categoryArguments?['id']?.toString() ?? '';
      title = categoryArguments?['title']?.toString() ?? 'Duain';
    } else {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          title: const Text('Duain'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Unable to open this Dua category. Please go back and try again.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
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
              color: AppColors.white,
              elevation: 2,
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
                onTap: () => Get.toNamed(AppRoutes.duaDetail, arguments: dua),
              ),
            );
          },
        );
      }),
    );
  }

  String _formatCategory(String category) {
    if (category.isEmpty) return 'Duain';
    return category
        .split('_')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
