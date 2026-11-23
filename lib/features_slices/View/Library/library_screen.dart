import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Library/Controller/library_controller.dart';
import 'package:islam786/features_slices/View/Library/Widgets/library_collection_card.dart';
import 'package:islam786/features_slices/View/Library/Widgets/library_search_field.dart';
import 'package:zi_core/zi_core_io.dart';

class LibraryScreen extends GetView<LibraryController> {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZiScaffoldB(
      appBar: const ZiAppBarB(title: 'Islamic Library', centerTitle: true),
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return _errorState(context);
        }

        final collections = controller.filteredCollections;
        return Column(
          children: [
            Padding(
              padding: context.responsivePadding(
                horizontal: 0.04,
                vertical: 0.014,
              ),
              child: LibrarySearchField(
                onChanged: (value) =>
                    controller.collectionSearchQuery.value = value,
              ),
            ),
            Expanded(
              child: collections.isEmpty
                  ? Center(
                      child: Text(
                        'No collections match your search.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: context.scaledFont(14),
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: context.responsivePadding(
                        horizontal: 0.04,
                        vertical: 0.008,
                      ),
                      itemCount: collections.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.isMobile ? 2 : 3,
                        crossAxisSpacing: context.widthPct(0.035),
                        mainAxisSpacing: context.heightPct(0.015),
                        childAspectRatio: context.isMobile ? 0.92 : 1.08,
                      ),
                      itemBuilder: (context, index) {
                        final collection = collections[index];
                        return LibraryCollectionCard(
                          collection: collection,
                          itemCount:
                              controller
                                  .contents[collection.fileName]
                                  ?.length ??
                              0,
                          onTap: () {
                            controller.itemSearchQuery.value = '';
                            Get.toNamed(
                              AppRoutes.libraryCollection,
                              arguments: collection,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _errorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.responsiveAll(0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: context.scaledFont(14),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: controller.loadCollections,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
